from datasets import ScanpathLoadDatasets
from torchvision import transforms
import torch
import os
import scipy.io as sio
from numpy import asarray
import scipy.io as spio
import numpy as np
import random
from PIL import Image


print(' Computing Model ')

entro_folder = 'x'

#train scanpath prediction
# Applying Transforms to the Data
image_transforms = { 
    'train': transforms.Compose([ 
        #transforms.ToPILImage(),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485], std=[0.229])
    ]),
    'valid': transforms.Compose([ 
        #transforms.ToPILImage(),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485], std=[0.229])
    ]),
    'test': transforms.Compose([
        #transforms.ToPILImage(),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485], std=[0.229])
    ])
}
transform = image_transforms['train']

# Data parameters
split = '1' #cross validation choose among 1 - 3
datatype = 'array' #choose one among waldo, naturaldesign, cmonkey, wmonkey, naturalsaliency, array
deterministic = False #flag indicating whether taking the max or sampling from policy
topK = 1 #take the sample from top K max probability
n_channel = 3

savemoddir = 'models_conv_only/'
itermodel = 0
print('no training. see below for loaded weights')

    
saveresultdir = 'results_' + datatype + '/'

if not os.path.exists(saveresultdir):
    os.mkdir(saveresultdir)

workers = 1  # for data-loading; right now, only 1 works with h5py
imgsize = 1024/16 #image size
txt_folder = 'pytorch/datalist/' 

if datatype == 'naturalsaliency':
    img_folder = 'Datasets/ProcessScanpath_naturalsaliency/stimuli/'
    gt_folder = 'Datasets/ProcessScanpath_naturalsaliency/CGround_saliency/'
    sal_folder = 'Datasets/ProcessScanpath_naturaldesign/CSaliency_naturaldesign/'
    #entro_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_naturaldesign/'    
    imgtestlist = 'pytorch/datalist/imglist_naturaldesign.txt'
    #imgtestlist = os.path.join(txt_folder, 'testsetImg_' + datatype + '_' + split + '.txt')    
    NumFixSteps = 14
    
elif datatype == 'naturaldesign':
    img_folder = 'Datasets/ProcessScanpath_naturaldesign/stimuli/'
    gt_folder = 'Datasets/ProcessScanpath_naturaldesign/CGround_naturaldesign/'
    sal_folder = 'Datasets/ProcessScanpath_naturaldesign/CSimilarity_naturaldesign/'
    #sal_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarityWeighted_naturaldesign/'
    #entro_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_naturaldesign/'
    recog_folder = 'Datasets/ProcessScanpath_naturaldesign/CRecog_naturaldesign/'
    imgtestlist = 'pytorch/datalist/imglist_naturaldesign.txt'
    #imgtestlist = os.path.join(txt_folder, 'testsetImg_' + datatype + '_' + split + '.txt') 
    NumFixSteps = 55
    Thres = 0.3066 * 255 #0.3066
    
elif datatype == 'waldo':
    img_folder = 'Datasets/ProcessScanpath_waldo/stimuli/'
    gt_folder = 'Datasets/ProcessScanpath_waldo/CGround_waldo/'
    sal_folder = 'Datasets/ProcessScanpath_waldo/CSimilarity_waldo/'
    #sal_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarityWeighted_waldo/'
    #entro_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_waldo/'
    recog_folder = 'Datasets/ProcessScanpath_waldo/CRecog_waldo/'
    imgtestlist = 'pytorch/datalist/imglist_waldo.txt'
    NumFixSteps = 55
    Thres = 0.5*255 #0.5 * 255 #0.1902
    
elif datatype == 'cmonkey':
    img_folder = 'Datasets/CMonkey/stimuli/'
    gt_folder = 'Datasets/CMonkey/CGround_saliency/'
    sal_folder = 'Datasets/CMonkey/CSaliency_cmonkey/'
    #entro_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_cmonkey/'
    imgtestlist = 'pytorch/datalist/imglist_cmonkey.txt'
    NumFixSteps = 4

elif datatype == 'array':
    img_folder = 'Datasets/ProcessScanpath_array/stimuli_simplified/'
    gt_folder = 'Datasets/ProcessScanpath_array/CGround_array/'
    sal_folder = 'Datasets/ProcessScanpath_array/CSimilarity_array/'
    #sal_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarityWeighted_array/'
    #entro_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_array/'
    recog_folder = 'Datasets/ProcessScanpath_array/CRecog_array/'
    imgtestlist = 'pytorch/datalist/imglist_array.txt'
    NumFixSteps = 12
    Thres = 0.5 * 255 #0.506
    
    mat = spio.loadmat('IOR_NC/Mat/mask_array_ps.mat')
    #indmask = torch.from_numpy(mat['indmask'].astype(int)).cuda()
    mask = mat['mask'].astype(np.double)
#    print(mask)
else:
    img_folder = 'Datasets/WMonkey/stimuli/'
    sal_folder = 'Datasets/WMonkey/CSaliency_wmonkey/'
    gt_folder = 'Datasets/WMonkey/CGround_saliency/'
    #entro_folder = '/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_wmonkey/'
    imgtestlist = 'pytorch/datalist/imglist_wmonkey.txt'
    NumFixSteps = 8
    

if __name__ == '__main__':
    
    # customized dataloader
    MyDataset = ScanpathLoadDatasets(imgsize, txt_folder, img_folder, gt_folder, sal_folder, entro_folder, datatype, split, transform)
    #drop the last batch since it is not divisible by batchsize
    
#    dataiter = iter(train_loader)
#    images, labels = dataiter.next()
    
#    print(images.shape)
#    print(labels)
#    print(images[0].max())
#    print(images[0].min())
    #print(images[1].max())
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    #model = torch.load(savemoddir + '_model_split_' + split + '_epoch_' + str(itermodel) + '.pt')
    print(savemoddir + '_model_split_' + split + '_epoch_' + str(itermodel) + '.pt')
    model = torch.load(savemoddir + '_model_split_' + split + '_epoch_' + str(itermodel) + '.pt',map_location=torch.device('cpu'))
    #model = model.conv1
    model = model.eval().to(device)
#    print('weight:')
#    print(model.conv1.weight.shape)
    
    #memory only
    #waldo, naturaldesign, naturalsaliency, wmonkey, cmonkey, array: 1 0.2346 -0.93
    
    with torch.no_grad():        
        model.conv1.weight[0, 0, 0, 0] = 1 #sal 1
        model.conv1.weight[0, 1, 0, 0] = 0.2346  #sac 0.2346
        model.conv1.weight[0, 2, 0, 0] =  -0.93  #IOR -0.93
#        
#    print('weight:')
#    print(model.conv1.weight)
#    images = images.to(device)
#    out = model(images)
#    print(out.shape)
    
    imglist = []
    with open(imgtestlist,'rb') as f:    
    #with open(os.path.join(txt_folder, 'testsetImg_' + datatype + '_' + split + '.txt'),'rb') as f:
        #self.imglist = [os.path.join(img_folder, line.strip()) for line in f]
        imglist = [line.strip() for line in f]

    for i in range(len(imglist)):
        
        imgname = imglist[i]
        print('processing img#[' + str(i) + ']: ' + imgname)
              
        if datatype == 'array' or datatype == 'waldo' or datatype == 'naturaldesign':
            recogmap = Image.open(recog_folder + imgname)
            recogmap = recogmap.resize((imgsize,imgsize))
            recogmap = np.array(recogmap.getdata()).reshape(1,imgsize*imgsize)
            
            gtmap = Image.open(gt_folder + imgname)
            gtmap = gtmap.resize((imgsize,imgsize))
            gtmap = np.array(gtmap.getdata()).reshape(1,imgsize*imgsize)
            #print(recogmap.max())
            #print(gtmap.max())
              
        fix = []
        fix.append( (imgsize/2-1)*imgsize+ imgsize/2)
        psmat = []
        IOR = []
        sacprior = []
        
        for t in range(NumFixSteps):
            
            #model.conv1.weight[0, 2, 0, 0] = random.random() * -1 # for mem abla # comment if not used
            inputs, IORcopy, sacpriorTcopy = MyDataset.step(imgname, fix)
            #inputs = inputs.view(1, n_channel, imgsize, imgsize).cuda()
            inputs = inputs.view(1, n_channel, imgsize, imgsize)
            #print(inputs.shape)
            #outputs = model(inputs).cuda()            
            outputs = model(inputs)
            #print(outputs.shape)
            outputs = outputs.exp().detach().cpu()
            
            if datatype == 'array':
#                print('im here')
#                print(outputs.shape)
#                print(mask.shape)          
#                print(outputs.data[0][22:26])
#                print(type(mask))
                outputs = np.multiply(outputs, mask)
#                print(outputs[0][22:26])
            
            #print(outputs.shape)
            

            # # previous version:
            # if deterministic:
            #     ret, predictions = torch.max(outputs, 1)
            # else:
            #     #dist = torch.distributions.Categorical(logits=outputs)
            #     #predictions = dist.sample().view(1,1)
            #     #print(predictions)
            #     sortedval, indices = torch.sort(outputs, dim = 1, descending = True)
            #     dist = torch.distributions.Categorical(logits=sortedval[0][0:topK])
            #     predictions_ind = dist.sample().view(1,1)
            #     #print(predictions_ind)
            #     #print(indices.shape)
            #     #print(sortedval)
            #     #ind = random.randint(0,topK)
            #     #print(ind)
            #     predictions = indices[0][predictions_ind]
            #     #print(predictions)
                

            # mod version 
            if deterministic: # 1. deterministic, get the max
                ret, predictions = torch.max(outputs, 1)
            else:
                if topK > 0: # 2. choose next fix randomly within the topK
                    sortedval, indices = torch.sort(outputs, dim = 1, descending = True)
                    dist = torch.distributions.Categorical(logits=sortedval[0][0:topK])
                    predictions_ind = dist.sample().view(1,1)
                    predictions = indices[0][predictions_ind]
                else: # 3. choose next fix from the distribution
                    dist = torch.distributions.Categorical(logits=outputs)
                    predictions_ind = dist.sample().view(1,1)
                    predictions = predictions_ind



            
            #print(predictions)
            fix.append(predictions.item())
            psmat.append(outputs.data.cpu().reshape(imgsize,imgsize).numpy())
            #print(psmat)
            #convert PIL image to numpy array
            IORcopy = asarray(IORcopy)
            sacpriorTcopy = asarray(sacpriorTcopy)
            #print(sacpriorTcopy.shape)
            IOR.append(IORcopy)
            sacprior.append(sacpriorTcopy)
            #print(fix)
            
            #perform recognition
            if datatype == 'array' or datatype == 'naturaldesign':
                if recogmap[0][predictions.item()] >= Thres and gtmap[0][predictions.item()] > 250:
                    #target found
                    #print('target found')
                    #print(recogmap[0][predictions.item()])
                    #print(gtmap[0][predictions.item()])
                    break
            elif datatype == 'waldo':
                #if ((recogmap[0][predictions.item()] >= 0.02 and recogmap[0][predictions.item()] <= 0.1) or (recogmap[0][predictions.item()] >= 0.14 and recogmap[0][predictions.item()] <= 0.2)) and gtmap[0][predictions.item()] > 250:
                if recogmap[0][predictions.item()] >= Thres and gtmap[0][predictions.item()] > 250:
                    #target found
                    print('==============target found')
                    #print(recogmap[0][predictions.item()])
                    #print(gtmap[0][predictions.item()])
                    break
                #else:
                    #print('cannot find waldo')
                
                    
                
                    
    
        print(fix)
        #print(psmat.shape)
        #print(IOR.shape)
        #print(sacprior.shape)                

        sio.savemat(saveresultdir + imgname + '.mat', {'fix':fix, 'psmat': psmat, 'sacprior': sacprior, 'IOR':IOR})
    
    
    
print(' Model computed')

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
