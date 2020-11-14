clear all; close all; clc;

type = 'naturaldesign'; %choose among array, naturaldesign, waldo, cmonkey, wmonkey
%naturaldesign has same saliency as naturalsaliency


if strcmp(type, 'wmonkey')
    ImageFolder = 'Datasets/WMonkey/stimuli/'    
elseif strcmp(type, 'cmonkey')
    ImageFolder = 'Datasets/CMonkey/stimuli/'; 
elseif strcmp(type, 'waldo')
    ImageFolder = 'Datasets/ProcessScanpath_waldo/stimuli/';
    load(['Datasets/SubjectArray/waldo.mat']);
elseif strcmp(type, 'array')
    ImageFolder = 'Datasets/ProcessScanpath_array/stimuli_simplified/';
    totalmask = load(['Datasets/ProcessScanpath_array/saliencyMask/masktotal.mat']);
    totalmask = totalmask.masktotal;
else
    ImageFolder = 'Datasets/ProcessScanpath_naturaldesign/stimuli/'    
end

WriteDir = ['Datasets/ProcessScanpath_naturaldesign/CSaliency_' type '/'];
mkdir(WriteDir);
imglist = dir([ImageFolder '*.*']);
matlist = dir(['pytorch/vgg16_compute_saliency_map/Salmap_' type '/*.mat']);
%scale = [128, 256, 512, 1024]; 
scale = [1024]; 
TS = [1 2 4];

%figure;
for i = 1:length(imglist)-2
    i
    stimuli = imread([ImageFolder imglist(i+2).name]);    
%     h = imshow(stimuli);
    [wid hei cha] = size(stimuli);
    
    totalentropy = zeros(wid, hei, length(TS));
    for s = 1:length(TS)
        load(['pytorch/vgg16_compute_saliency_map/Salmap_' type '/' imglist(i+2).name '_' num2str(scale(1)) '_' num2str(TS(s)) '.mat']);
        %entropymap = imgaussfilt(salmap,1);
        entropymap = salmap;
%         imshow(entropymap);
%         pause;
        entropymap = imresize(entropymap, [wid hei]);
        totalentropy(:,:,s) = entropymap;       
    end
    
    entropy = mean(totalentropy, 3);
    entropy = mat2gray(entropy);
    
    if strcmp(type, 'waldo')
        imgid = imglist(i+2).name;
        imgid = str2num(imgid(end-6:end-4));
        trialname = MyData(imgid).targetname;
        maskname = ['Datasets/ProcessScanpath_waldo/mask/' trialname];
        if exist(maskname, 'file') == 2 
            mask = imread(maskname);
            mask = imresize(mask,[size(entropy,1) size(entropy,2)]);
            mask = rgb2gray(mask);
            mask = double(im2bw(mask,0.5));
            entropy = entropy.*mask;
            entropy = mat2gray(entropy);
        end
    end
    
    if strcmp(type, 'array')
        entropy = entropy.*totalmask;
        entropy = mat2gray(entropy);
    end
    
    if strcmp(type, 'naturaldesign')
        boundary_tor = 25;
        entropy(1:size(entropy,1),1:boundary_tor) = 0;
        entropy(1:size(entropy,1),size(entropy,2)-boundary_tor:size(entropy,2)) = 0;
        entropy(1:boundary_tor,1:size(entropy,2)) = 0;
        entropy(size(entropy,1)-boundary_tor:size(entropy,1),1:size(entropy,2)) = 0;
        entropy = mat2gray(entropy);
    end
    
%     heat = heatmap_overlay(stimuli, entropy);
%     imshow(heat);
% %     imshow(entropy);
% %     %imshow(stimuli);
% %     imshow(entropy);
% %     hold on;
% %     g = imshow(entropymap);
% %     set(g, 'AlphaData', entropymap);   
% %     hold off;
%     pause;
    imwrite(entropy, [WriteDir imglist(i+2).name]);
end
