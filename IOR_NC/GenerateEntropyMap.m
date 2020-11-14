clear all; close all; clc;

type = 'waldo'; %'naturaldesign','waldo','wmonkey','cmonkey'

if strcmp(type, 'wmonkey')
    ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli/'    
elseif strcmp(type, 'cmonkey')
    ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuliRGB/'; 
elseif strcmp(type, 'waldo')
    ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean/';
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/waldo.mat']);
else
    ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered_gray_3channels/'    
end

WriteDir = ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_' type '/'];
mkdir(WriteDir);
imglist = dir([ImageFolder '*.*']);
matlist = dir(['/media/mengmi/KLAB15/Mengmi/Proj_memory/Entropy_' type '/*.mat']);
scale = [64, 512, 1024]; 

%figure;
for i = 1:length(imglist)-2
    i
    stimuli = imread([ImageFolder imglist(i+2).name]);    
%     h = imshow(stimuli);
    [wid hei cha] = size(stimuli);
    
    totalentropy = zeros(wid, hei, length(scale));
    for s = 1:length(scale)
        load(['/media/mengmi/KLAB15/Mengmi/Proj_memory/Entropy_' type '/' imglist(i+2).name '_' num2str(scale(s)) '.mat']);
        entropymap = imgaussfilt(entropymap,2);
        %imshow(entropymap);
        entropymap = imresize(entropymap, [wid hei]);
        totalentropy(:,:,s) = entropymap;       
    end
    
    %entropy = mean(totalentropy, 3);
    entropy = squeeze(totalentropy(:,:,3));
    entropy = mat2gray(entropy);
        
    %rotate entropy map by 90
    entropy = imrotate(entropy,-90);
    entropy = flipdim(entropy,2);
    entropy = mat2gray(entropy);
    entropy = imresize(entropy, [wid hei]);
    
    if strcmp(type, 'waldo')
        imgid = imglist(i+2).name;
        imgid = str2num(imgid(end-6:end-4));
        trialname = MyData(imgid).targetname;
        maskname = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/WaldoBookSeries/mask/' trialname];
        if exist(maskname, 'file') == 2 
            mask = imread(maskname);
            mask = imresize(mask,[size(entropy,1) size(entropy,2)]);
            mask = rgb2gray(mask);
            mask = double(im2bw(mask,0.5));
            entropy = entropy.*mask;
            entropy = mat2gray(entropy);
        end
    end
%     heat = heatmap_overlay(stimuli, entropymap);
    subplot(1,2,1);
    imshow(entropy);
    subplot(1,2,2);
    imshow(stimuli);
    %imshow(heat);
%     imshow(stimuli);
% %     imshow(entropy);
%     hold on;
%     g = imshow(entropymap);
%     set(g, 'AlphaData', entropymap);   
%     hold off;
    pause;
    imwrite(entropy, [WriteDir imglist(i+2).name]);
end