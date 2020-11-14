clear all; close all; clc;

type = 'array';

if strcmp(type, 'waldo')
    ImageFolder = 'Datasets/ProcessScanpath_waldo/stimuli/';
    prefix = 'img_id_';
    load(['Datasets/SubjectArray/waldo.mat']);
    NumImg = 67;
    
elseif strcmp(type, 'array')
    ImageFolder = 'Datasets/ProcessScanpath_array/stimuli_simplified/';
    totalmask = load(['Datasets/ProcessScanpath_array/saliencyMask/masktotal.mat']);
    totalmask = totalmask.masktotal;
    prefix = 'array_';
    NumImg = 300;
    numarray = 6;
else
    ImageFolder = 'Datasets/ProcessScanpath_naturaldesign/stimuli/';
    prefix = 'gray';
    NumImg = 240;
    
end

WriteDir = ['Datasets/ProcessScanpath_array/CRecog_' type '/'];
mkdir(WriteDir);

matlist = ['pytorch/vgg16_compute_recog_map/Recog_' type '/'];
%scale = [128, 256, 512, 1024]; 

if strcmp(type, 'array')
    scale = [224];
else
    scale = [32 64 128];
end


%figure;
for i = 1:NumImg
    i
    
    if strcmp(type, 'array')
        stimuliname = [prefix num2str(i) '.jpg'];    
    else
        stimuliname = [prefix sprintf('%03d',i) '.jpg'];  
    end
    stimuli = imread([ImageFolder stimuliname]);  
    
%     h = imshow(stimuli);
    [wid hei cha] = size(stimuli);
    
    if strcmp(type, 'array')
        totalentropy = zeros(wid, hei, numarray);
        for n = 1:numarray
            load(['pytorch/vgg16_compute_recog_map/Recog_' type '/img_' num2str(i) '_' num2str(n) '.jpg' '_' num2str(scale) '.mat']);
            salimg = imread(['Datasets/ProcessScanpath_array/saliencyMask/mask' num2str(n) '.jpg']);
            salimg = mat2gray(salimg)* recogmap;
            totalentropy(:,:,n) = salimg; 
        end
        
    else
        totalentropy = zeros(wid, hei, length(scale));
        for s = 1:length(scale)
            load(['pytorch/vgg16_compute_recog_map/Recog_' type '/' stimuliname '_' num2str(scale(s)) '.mat']);
            %entropymap = imgaussfilt(salmap,1);
            entropymap = recogmap;
    %         imshow(entropymap);
    %         pause;
            entropymap = imresize(entropymap, [wid hei]);
            totalentropy(:,:,s) = entropymap;       
        end
    end
    
    entropy = mean(totalentropy, 3);
    entropy = mat2gray(entropy);   
    
%     heat = heatmap_overlay(stimuli, entropy);
%     imshow(heat);
%     imshow(entropy);
% %     %imshow(stimuli);
% %     imshow(entropy);
% %     hold on;
% %     g = imshow(entropymap);
% %     set(g, 'AlphaData', entropymap);   
% %     hold off;
%     pause;
    imwrite(entropy, [WriteDir stimuliname]);
end