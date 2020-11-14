from torch.utils.data import Dataset
import os
from PIL import Image
import numpy as np
import torch
from torchvision import transforms
import scipy.io as spio

class ScanpathLoadDatasets(Dataset):
    """
    A PyTorch Dataset class to be used in a PyTorch DataLoader to create batches.
    """

    def __init__(self, imgsize, txt_folder, img_folder, gt_folder, sal_folder, entro_folder, datatype, split, transform=None):
        """
        :param data_folder: folder where data files are stored
        :param data_name: base name of processed datasets
        :param split: split, one of 'TRAIN', 'VAL', or 'TEST'
        :param transform: image transform pipeline
        :param Gfiltersz: image gaussian blur filter size
        :param Gblursigma: image gaussian blur variance
        """
        self.imgsize = imgsize        
        self.imgfolder = img_folder
        self.sal_folder = sal_folder
        self.entro_folder = entro_folder
        self.gt_folder = gt_folder
        
        self.split = split
        self.datatype = datatype
        self.scanpathlist = []
        self.labellist = []
        self.imglist = []
        
        ##construct IOR map; MemT; sigma parameter:
        #array: 0.92, 0.5, 0.1 
        #naturalsaliency, naturaldesign, cmonkey, wmonkey: 0.92 0.5 0.02
        #waldo: 0.92, 0.5, 0.032
        
        ##revised array parameter to fit scanpath offsets
        #array: 0.92, 0.5, 0.08
        #naturalsaliency, naturaldesign, cmonkey, wmonkey: 0.92 0.5 0.02
        #waldo: 0.92, 0.47, 0.017
        
        self.decayMem = 0.92 #default: 0.92
        self.MemT = 0.5 #the minimum thres; clip smaller values to this thres; default = 0
        self.sigma = 0.02 #default: 0.03
        
        if self.datatype == 'array':
            self.sigma = 0.08
        elif self.datatype == 'waldo':
            self.sigma = 0.017
            self.MemT = 0.47
        
        #GTtransform
        self.GTtransforms = transforms.Compose([transforms.ToTensor()])
        
        self.action_map_x, self.action_map_y = np.meshgrid(range(self.imgsize),range(self.imgsize))
        self.action_map_x = self.action_map_x.flatten()
        self.action_map_y = self.action_map_y.flatten()
       
        if self.datatype == 'naturaldesign' or self.datatype == 'naturalsaliency':
            with open(os.path.join(txt_folder, 'trainsetImg_' + self.datatype + '_' + self.split + '.txt'),'rb') as f:
                #self.imglist = [os.path.join(img_folder, line.strip()) for line in f]
                self.imglist = [line.strip() for line in f]
                
            with open(os.path.join(txt_folder, 'trainsetPath_' + self.datatype + '_' + self.split + '.txt'),'rb') as f:
                #self.imglist = [os.path.join(img_folder, line.strip()) for line in f]
                self.scanpathlist = [line.strip().split() for line in f]
                 
            with open(os.path.join(txt_folder, 'trainsetGT_' + self.datatype + '_' + self.split + '.txt'),'rb') as f:
                self.labellist = [int(line) for line in f]
                
            # Total number of datapoints
            self.dataset_size = len(self.imglist)

        if self.datatype == 'array':
            self.sacprior = []
            for i in range(7):
                self.sacprior_name = 'IOR_NC/Figures/' + self.datatype + '_2Dsaccadeprior_' + str(i) + '.jpg'
                self.sacpriorfix = Image.open(self.sacprior_name)
                self.sacprior.append(self.sacpriorfix.resize((self.imgsize,self.imgsize)))
                
            mat = spio.loadmat('IOR_NC/Mat/mask_array_ps.mat')
            self.indmask = mat['indmask']
            self.mask = mat['mask'].astype(float)
            
        else:
            self.sacprior_name = 'IOR_NC/Figures/' + self.datatype + '_2Dsaccadeprior.jpg'
            self.sacprior = Image.open(self.sacprior_name)
            self.sacprior = self.sacprior.resize((self.imgsize*2,self.imgsize*2))

        # PyTorch transformation pipeline for the image (normalizing, etc.)
        self.transform = transform
        

    def __getitem__(self, i):
                
        # Read images
        #print(self.imglist[i])
        #print(self.binlist[i])
        #print(self.labellist[i])
        salmap = Image.open(self.sal_folder + self.imglist[i])
        #entromap = Image.open(self.entro_folder + self.imglist[i]) 
        
        if self.datatype == 'naturalsaliency' or self.datatype == 'wmonkey' or self.datatype == 'cmonkey':
            gtmap = Image.open(self.gt_folder + 'gt.jpg')
        else:
            gtmap = Image.open(self.gt_folder + self.imglist[i]) 
        
        salmap = salmap.resize((self.imgsize,self.imgsize)) 
        #entromap = entromap.resize((self.imgsize,self.imgsize)) 
        gtmap = gtmap.resize((self.imgsize,self.imgsize)) 
        #print(self.sal_folder + self.imglist[i])
        #salmap.show()
        #print(self.entro_folder + self.imglist[i])
        #entromap.show()         
        
        self.fix = self.scanpathlist[i]
        #print(self.fix)
        self.fix = [int(x)-1 for x in self.fix] 
        #print(self.fix)
        
        sacpriorT = self.__getSacPriormap__(self.fix[-1]-1)
        IOR = self.__getIORmap__(self.fix)
        #sacpriorT.show()
        #IOR.show()
        
        if self.transform is not None:
            salmap = self.transform(salmap)
            #entromap = self.transform(entromap)
            gtmap = self.transform(gtmap)
            sacpriorT = self.transform(sacpriorT)
            IOR = self.transform(IOR)
      
        #concateImg = torch.cat((salmap, gtmap, sacpriorT, IOR), 0) 
        #concateImg = torch.cat((salmap, entromap, sacpriorT, IOR), 0)  
        concateImg = torch.cat((salmap, sacpriorT, IOR), 0)
                    
        label = self.labellist[i] - 1 
        
        GTmap = self.__getGTmap__(label)
        GTmap = self.GTtransforms(GTmap)
        
        return concateImg, GTmap, label, self.action_map_x[self.fix[-1]], self.action_map_y[self.fix[-1]], self.action_map_x[label], self.action_map_y[label]
    
    def step(self, imgname, fix):
                
        # Read images
        #print(self.imglist[i])
        #print(self.binlist[i])
        #print(self.labellist[i])
        salmap = Image.open(self.sal_folder + imgname)
        #entromap = Image.open(self.entro_folder + imgname) 
        
        if self.datatype == 'naturalsaliency' or self.datatype == 'wmonkey' or self.datatype == 'cmonkey':
            gtmap = Image.open(self.gt_folder + 'gt.jpg')
        else:
            gtmap = Image.open(self.gt_folder + imgname) 
        
        salmap = salmap.resize((self.imgsize,self.imgsize)) 
        #entromap = entromap.resize((self.imgsize,self.imgsize))
        gtmap = gtmap.resize((self.imgsize,self.imgsize))
        
        if self.datatype == 'array':
#            print(len(self.sacprior))
#            print(fix[-1])
#            print(self.indmask[0][fix[-1]])            
            sacpriorT = self.sacprior[self.indmask[0][fix[-1]]]
#            print(sacpriorT.size)
        else:
            sacpriorT = self.__getSacPriormap__(fix[-1])
            
        IOR = self.__getIORmap__(fix)
        
        IORcopy = IOR.copy()
        sacpriorTcopy = sacpriorT.copy()
        #sacpriorT.show()
        #IOR.show()
        
        if self.transform is not None:
            salmap = self.transform(salmap)
            #entromap = self.transform(entromap)
            gtmap = self.transform(gtmap)
            sacpriorT = self.transform(sacpriorT)
            IOR = self.transform(IOR)
      
        #concateImg = torch.cat((salmap, gtmap, sacpriorT, IOR), 0) 
        #concateImg = torch.cat((salmap, entromap, sacpriorT, IOR), 0)   
        concateImg = torch.cat((salmap, sacpriorT, IOR), 0)                    
        
        return concateImg, IORcopy, sacpriorTcopy
        

    def __len__(self):
        return self.dataset_size

    def __getIORmap__(self, fix):
        NumSteps = len(fix)
        IORmaps = np.zeros((self.imgsize, self.imgsize, NumSteps))
        
        for i in range(NumSteps):            
            mr = pow(self.decayMem,(NumSteps-i-1))
            if mr < self.MemT:
                mr = self.MemT  
        
            x, y = np.meshgrid(np.linspace(0,1,self.imgsize), np.linspace(0,1,self.imgsize))
            ctrx = 1.0/self.imgsize*self.action_map_x[fix[i]]
            ctry = 1.0/self.imgsize*self.action_map_y[fix[i]]
            d = np.sqrt((x-ctrx)*(x-ctrx)+(y-ctry)*(y-ctry))
            
            g = mr*np.exp(-( (d)**2 / ( 2.0 * self.sigma**2 ) ) )
            IORmaps[:,:, i] = g
        
        IORmap = np.max(IORmaps, axis=2)
        IOR = Image.fromarray(np.uint8(IORmap*255) , 'L')
        IOR = IOR.resize((self.imgsize,self.imgsize))              
        return IOR
    
    def __getGTmap__(self, curfix):
        
        mr = 1     
        x, y = np.meshgrid(np.linspace(0,1,self.imgsize), np.linspace(0,1,self.imgsize))
        ctrx = 1.0/self.imgsize*self.action_map_x[curfix]
        ctry = 1.0/self.imgsize*self.action_map_y[curfix]
        d = np.sqrt((x-ctrx)*(x-ctrx)+(y-ctry)*(y-ctry))
        g = mr*np.exp(-( (d)**2 / ( 2.0 * self.sigma**2 ) ) )
                
        GTmap = Image.fromarray(np.uint8(g*255) , 'L')
        GTmap = GTmap.resize((self.imgsize,self.imgsize))              
        return GTmap
    
    def __getSacPriormap__(self, curfix):
        
        ctrx = self.action_map_x[curfix]
        ctry = self.action_map_y[curfix]        
        topleftx = self.imgsize - ctrx - 1
        toplefty = self.imgsize - ctry - 1
        sacpriorT = self.sacprior.crop((topleftx,toplefty, topleftx+self.imgsize,toplefty+self.imgsize))
        sacpriorT = sacpriorT.resize((self.imgsize,self.imgsize))   
        return sacpriorT
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
        
