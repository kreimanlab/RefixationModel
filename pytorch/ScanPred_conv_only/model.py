#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May  5 16:27:22 2020

@author: mengmi
"""

from torchvision import models
import torch.nn as nn

import torch.nn as nn
import torch.nn.functional as F


class Net(nn.Module):
    def __init__(self, n_channel, device, imgsize):
        self.imgsize = imgsize
        self.n_channel = n_channel
        
        super(Net, self).__init__()
#        self.conv1 = nn.Conv2d(self.n_channel, self.n_channel, 3, 1, 1)
#        self.conv2 = nn.Conv2d(self.n_channel, 1, 1, 1, 0)
        #self.fc1 = nn.Linear(1*self.imgsize*self.imgsize, self.imgsize*self.imgsize)
        
        #self.conv1 = nn.Conv2d(self.n_channel, self.n_channel, 3, 1, 1)
        #self.fc1 = nn.Linear(self.n_channel*self.imgsize*self.imgsize, self.imgsize*self.imgsize)
        
        self.conv1 = nn.Conv2d(self.n_channel, 1, 1, 1, 0)
        
        #self.pool = nn.MaxPool2d(2,2,0)
        #self.conv2 = nn.Conv2d(self.n_channel, 1, 3, 1, 1)
        #self.adaptpool = nn.AdaptiveMaxPool2d((7,7))        
        #self.fc2 = nn.Linear(self.imgsize*self.imgsize, self.imgsize*self.imgsize)
        #self.logsoft = nn.LogSoftmax(dim=1)
        
    def forward(self, x):
        
#        x = F.relu(self.conv1(x))
#        x = F.relu(self.conv2(x))
#        x = x.view(-1, 1*self.imgsize*self.imgsize)
        #x = self.fc1(x)
        
        #x = F.relu(self.conv1(x))
        #x = x.view(-1, self.n_channel*self.imgsize*self.imgsize)
        #x = self.fc1(x)
        
        #x = self.pool(F.relu(self.conv1(x)))
        #x = self.pool(F.relu(self.conv2(x)))
        #x = self.pool(F.relu(self.conv1(x)))        
        #x = F.relu(self.fc1(x))        
        #x = self.logsoft(x)
        #x = self.fc3(x)
        
        x = self.conv1(x)
        x = x.view(-1, 1*self.imgsize*self.imgsize)
        return x


    