#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
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

TS = 4
 #choose among 1, 2, 4

# Applying Transforms to the Data
image_transforms = { 
    'train': transforms.Compose([
        transforms.Resize(size=1024/TS),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ]),
    'valid': transforms.Compose([
        transforms.Resize(size=1024/TS),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ]),
    'test': transforms.Compose([
        transforms.Resize(size=1024/TS),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ])
}

def predict(model, test_image_name, write_image_name, width, height, stride):
    '''
    Function to predict the class of a single test image
    Parameters
        :param model: Model to test
        :param test_image_name: Test image

    '''
    transform = image_transforms['test']
    test_image = Image.open(test_image_name)
    test_image = test_image.resize((width, height))

    row = np.arange(0, width, stride)
    col = row
    salmap = np.empty((128/TS*width/stride,128/TS*width/stride))
     
    for c in col:
        for r in row:
            #print('col: '+str(c) +'; row: ' + str(r))
            startx = r
            starty = c
            endx = startx + stride - 1
            endy = starty + stride - 1        
            test_image_pad_crop = test_image.crop((startx, starty, endx, endy))    
            test_image_tensor = transform(test_image_pad_crop)
            
            if torch.cuda.is_available():
                test_image_tensor = test_image_tensor.view(1, 3, 1024/TS, 1024/TS).cuda()
            else:
                test_image_tensor = test_image_tensor.view(1, 3, 1024/TS, 1024/TS)
    
            with torch.no_grad():
                model.eval()
                # Model outputs log probabilities
                out = model(test_image_tensor)
                out = torch.sum(out, dim=1).squeeze()
                featureW, featureH = out.shape
                out = out.cpu().numpy()
                salmap[starty/stride*featureW+0:starty/stride*featureW+featureW,startx/stride*featureW+0:startx/stride*featureW+featureW] = out
           
    
    print('ps collection done')
    
    xmax, xmin = salmap.max(), salmap.min()
    salmap = (salmap - xmin)/(xmax - xmin)
    #img = Image.fromarray(np.uint8(salmap*255) , 'L')
    sio.savemat(write_image_name, {'salmap':salmap})
    
if __name__=='__main__':
    
    
    # Load pre-trained model
    modelvgg = models.vgg16(pretrained=True)
    model = nn.Sequential(*[modelvgg.features[i] for i in range(23)])
    #print(pretrain_vgg16)
    # Freeze model parameters
    for param in model.parameters():
        param.requires_grad = False
    
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    model = model.to(device)
    print(model)    
    
    DATASETTYPE = 'array' #choose among types: 'array','wmonkey','naturaldesign', 'cmonkey', 'waldo'
    SCALETYPE = 4 #fixed; do NOT change
    #width, stride
    #1024, 512
    #1024, 256
    #1024, 128
    #1024, 1024
    
    if SCALETYPE == 1:
        width = 1024
        height = width
        stride = 512
        
    elif  SCALETYPE == 2:
        width = 1024
        height = width
        stride = 256
        
    elif  SCALETYPE == 3: 
        width = 1024
        height = width
        stride = 128
    else:
        width = 1024
        height = width
        stride = 1024
        
    
    TextFile = 'gym_scanpathpred/envs/datalist/imglist_' + DATASETTYPE + '.txt'
    if DATASETTYPE == 'wmonkey':
        ImageFolder = 'Datasets/WMonkey/stimuli/'    
    elif DATASETTYPE == 'naturaldesign':
        ImageFolder = 'Datasets/ProcessScanpath_naturaldesign/stimuli/'
    elif DATASETTYPE == 'waldo':
        ImageFolder = 'Datasets/ProcessScanpath_waldo/stimuli/'
    elif DATASETTYPE == 'array':
        ImageFolder = 'Datasets/ProcessScanpath_array/stimuli_simplified/'
    else:
        ImageFolder = 'Datasets/WMonkey/stimuli/'
        
    WriteDir = 'Salmap_' + DATASETTYPE + '/'

    with open(TextFile,'rb') as f:
        imglist = [os.path.join(line.strip()) for line in f]
    
    counterI = 0
    for filename in imglist:
        print('processing: #' + str(counterI+1) + '/' + str(len(imglist)) + ' ' + filename)
        imagename = ImageFolder + filename
        writename = WriteDir + filename + '_' + str(stride) + '_' + str(TS) + '.mat'
        print('image path: ' + imagename)
        print('write path: ' + writename)
        predict(model, imagename, writename, width, height, stride)
        counterI = counterI + 1
    
