clear all; close all; clc;

type = 'array'; %'naturaldesign','waldo','wmonkey','cmonkey'
ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuliRGB/';   
WriteDir = ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CEntropy_' type '/'];
mkdir(WriteDir);
NumImg = 300;
numarray = 6;

totalmask = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliencyMask/masktotal.mat']);
totalmask = totalmask.masktotal;

%figure;
for i = 1:NumImg
    i
    stimuli = imread([ImageFolder 'array_' num2str(i) '.jpg']);    
%     h = imshow(stimuli);
    [wid hei cha] = size(stimuli);
    
    totalentropy = zeros(wid, hei);
    for s = 1:numarray
        chosenmask = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliencyMask/mask' num2str(s) '.mat']);
        chosenmask = chosenmask.mask;
        load(['/media/mengmi/KLAB15/Mengmi/Proj_memory/Entropy_' type '/img_' num2str(i) '_' num2str(s) '.jpg.mat']);
        %entropymap
        totalentropy = totalentropy + chosenmask*entropymap;
    end
    
    entropy = mat2gray(totalentropy);
      
%     subplot(1,2,1);
%     imshow(entropy);
%     subplot(1,2,2);
%     imshow(stimuli);
%     %imshow(heat);
% %     imshow(stimuli);
% % %     imshow(entropy);
% %     hold on;
% %     g = imshow(entropymap);
% %     set(g, 'AlphaData', entropymap);   
% %     hold off;
%     pause;
    imwrite(entropy, [WriteDir 'array_' num2str(i) '.jpg']);
end