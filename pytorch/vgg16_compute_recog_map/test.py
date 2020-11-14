#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 16 13:54:14 2019

@author: mengmi
"""

#%env CUDA_VISIBLE_DEVICES=2

import torch
from torchvision import models, transforms
import numpy as np
import os
import torch.nn as nn
import scipy.io as sio
from PIL import Image
#from matplotlib import pyplot as plt

# Applying Transforms to the Data
image_transforms = { 
    'train': transforms.Compose([
        transforms.Resize(size=224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ]),
    'valid': transforms.Compose([
        transforms.Resize(size=224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ]),
    'test': transforms.Compose([
        transforms.Resize(size=224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ])
}

def predict(loss, model, test_image_name, target_image_name, write_image_name, width, height, stride):
    '''
    Function to predict the class of a single test image
    Parameters
        :param model: Model to test
        :param test_image_name: Test image

    '''
    transform = image_transforms['test']
    test_image = Image.open(test_image_name)
    test_image = test_image.resize((width, height))
    
    target_image = Image.open(target_image_name)
    target_image = target_image.resize((224, 224))
    target_tensor = transform(target_image)
    target_tensor = target_tensor.view(1,3,224,224).cuda()
    
    row = np.arange(0, width, stride)
    col = row
    salmap = np.empty((len(row),len(col)))
     
    for c in col:
        for r in row:
            #print('col: '+str(c) +'; row: ' + str(r))
            startx = r
            starty = c
            endx = startx + stride
            endy = starty + stride   
#            print(startx)
#            print(starty)
#            print(endx)
#            print(endy)
            
            test_image_pad_crop = test_image.crop((startx, starty, endx, endy)) 
            #test_image_pad_crop = test_image
            test_image_tensor = transform(test_image_pad_crop)
            
            if torch.cuda.is_available():
                test_image_tensor = test_image_tensor.view(1, 3, 224, 224).cuda()
            else:
                test_image_tensor = test_image_tensor.view(1, 3, 224, 224)
    
            inputs = torch.cat((test_image_tensor, target_tensor), 0)
            with torch.no_grad():
                model.eval()
                # Model outputs log probabilities
                out = model(inputs)
                #print(out.shape)
                outI = nn.functional.softmax(out[0], dim=0)  #test image
                outT = nn.functional.softmax(out[1], dim=0)  #target image
                #print(outI.shape)
                #print(outT.shape)
                loss = Loss(outI, outT)
#                print(loss.item())
                out = loss.item()
                #print(out)
#                print(salmap.shape)
                coordr = (endx) /stride -1
                coordc = (endy) /stride -1
#                print(coordr)
#                print(coordc)
                
                salmap[coordc,coordr] = out
            
    print('ps collection done')
    
    #xmax, xmin = salmap.max(), salmap.min()
    #salmap = (salmap - xmin)/(xmax - xmin)
    #img = Image.fromarray(np.uint8(salmap*255) , 'L')
    sio.savemat(write_image_name, {'recogmap':salmap})
    
if __name__=='__main__':
    
    # Load pre-trained model
    modelvgg = models.vgg16(pretrained=True)
    model = modelvgg
    #model = nn.Sequential(*[modelvgg.features[i] for i in range(23)])
    #print(model)
    # Freeze model parameters
    for param in model.parameters():
        param.requires_grad = False
    
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    model = model.to(device)
    print(model)    
    
    #cosine loss
    Loss = nn.CosineSimilarity(dim = 0).to(device)
    
    DATASETTYPE = 'naturaldesign' #choose among types: 'waldo','naturaldesign','array'
    SCALETYPE = 1 #choose among 1, 2, 3 scaling types
    
    if DATASETTYPE == 'array':
        SCALETYPE = 1
    #width, stride
    #1024, 512
    #1024, 256
    #1024, 128
    
    if SCALETYPE == 1:
        width = 1024
        height = width
        stride = 32
        
    elif  SCALETYPE == 2:
        width = 1024
        height = width
        stride = 64
        
    else: 
        width = 1024
        height = width
        stride = 128
     
    if DATASETTYPE == 'array':
        TextFile = 'pytorch/gym_scanpathpred/envs/datalist/entrylist_array.txt'
    else:
        TextFile = 'pytorch/gym_scanpathpred/envs/datalist/imglist_' + DATASETTYPE + '.txt'
    
    TargetFile = 'pytorch/gym_scanpathpred/envs/datalist/targetlist_' + DATASETTYPE + '.txt'
    
    if DATASETTYPE == 'naturaldesign':        
        ImageFolder = 'Datasets/ProcessScanpath_naturaldesign/stimuli/'
        TargetFolder = 'Datasets/ProcessScanpath_naturaldesign/stimuli/'
    elif DATASETTYPE == 'waldo':
        ImageFolder = 'Datasets/ProcessScanpath_waldo/stimuli/'
        TargetFolder = 'Datasets/ProcessScanpath_waldo/choppedtarget/'
    elif DATASETTYPE == 'array':
        ImageFolder = 'Datasets/ProcessScanpath_array/Entry_array/'
        TargetFolder = 'Datasets/ProcessScanpath_array/stimuli_simplified/'
        width = 224
        height = 224
        stride = 224
        
    WriteDir = 'Recog_' + DATASETTYPE + '/'

    with open(TextFile,'rb') as f:
        imglist = [os.path.join(line.strip()) for line in f]
    
    with open(TargetFile,'rb') as f:
        targetlist = [os.path.join(line.strip()) for line in f]
    
    counterI = 0
    for filename in imglist:
        print('processing: #' + str(counterI+1) + '/' + str(len(imglist)) + ' ' + filename)
        imagename = ImageFolder + filename
        targetname = TargetFolder + targetlist[counterI]
        
        writename = WriteDir + filename + '_' + str(stride) + '.mat'
        print('image path: ' + imagename)
        print('target path: ' + targetname)
        print('write path: ' + writename)
        predict(Loss, model, imagename, targetname, writename, width, height, stride)
        counterI = counterI + 1
    
