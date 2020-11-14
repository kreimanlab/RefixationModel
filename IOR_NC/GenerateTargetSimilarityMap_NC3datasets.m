% %% naturaldesign
% clear all;close all;clc;
% 
% LayerList = [1];
% FixData = [];
% Fix_posx = {};
% Fix_posy = {};
% 
% receptiveSize = 200;
% arraysize = 80;
% w = 1024;
% h = 1280;
% 
% for i = 1:240
%     i
%     piecedir = dir(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/croppednaturaldesign/img_id_' sprintf('%03d',i)  '_*_layer31_30.mat']);
%     wholeimg = zeros(length(LayerList),w, h);
% 
%     for l = 1: length(LayerList)
%         for j = 1: length(piecedir)
%             %j
%             comp = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/croppednaturaldesign/' piecedir(j).name(1:end-15) '.jpg']);
%             input = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/croppednaturaldesign/' piecedir(j).name]);
%             input = input.x;
%             input = imresize(input, [size(comp,1) size(comp,2)]);
%             C = strsplit(piecedir(j).name,'_');        
%             startpos = str2num(C{4});
%             endpos = str2num(C{5});
%             wholeimg(l,startpos: startpos+size(comp,1) - 1, endpos: endpos+size(comp,2) - 1) = input;
%             %wholeimg1 = squeeze(mat2gray( wholeimg(l,:,:)));
%             
% %             subplot(1,2,1);
% %             imshow(wholeimg1);
% %             subplot(1,2,2);
% %             imshow(uint8(overallimg));
% %             pause;
% %             imshow(heatmap_overlay(img,wholeimg1));
% %             pause(0.05);
%         end
%         wholeimg(l,:,:) = mat2gray(wholeimg(l,:,:));
%     end
%     
%     wholeimg = squeeze(mean(wholeimg,1));
%     wholeimg = mat2gray(wholeimg);
%     imshow(wholeimg);
%     pause;
%     imwrite(wholeimg, ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarity_naturaldesign/gray' sprintf('%03d',i) '.jpg']);
% %     imshow(mat2gray(wholeimg));
% %     pause;   
%         
%     %subplot(1,2,1);
%     %imshow(heatmap_overlay(gt,wholeimg));
%     %subplot(1,2,2);
%     %imshow(gt);
%     %pause(0.010);
%     
%     
%     
% end

%% waldo
clear all;close all;clc;

LayerList = [1];
w = 1024;
h = 1280;

load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/waldo.mat']);
mkdir('/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarity_waldo/');
for i = 1:length(MyData)/2
    
    trial = MyData(i);
    trialname = trial.targetname;
        
    img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/WaldoBookSeries/CroppedJPEG/' trialname]);
    img = imresize(img, [w, h]);
    display(['img: ' num2str(i)]);
    size(img);
    piecedir = dir(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/WaldoBookSeries/choppedwaldo/img_id' trialname(8:end-4)  '_*_layer31_30.mat']);
    wholeimg = zeros(length(LayerList),size(img,1), size(img,2));
    %overallimg = zeros(size(img,1),size(img,2),3);
       
    for l = 1: length(LayerList)
        for j = 1: length(piecedir)
            %j
            input = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/WaldoBookSeries/choppedwaldo/' piecedir(j).name]);
            comp = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/WaldoBookSeries/choppedwaldo/' piecedir(j).name(1:end-15) '.jpg' ]);
            input = input.x;
            input = imresize(input, [size(comp,1) size(comp,2)]);
            C = strsplit(piecedir(j).name,'_');        
            startpos = str2num(C{5});
            endpos = str2num(C{6});
            wholeimg(l,startpos: startpos+size(comp,1) - 1, endpos: endpos+size(comp,2) - 1) = input;            
        end
        wholeimg(l,:,:) = mat2gray(wholeimg(l,:,:));
    end
    
    wholeimg = squeeze(mean(wholeimg,1));
    
    maskname = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/WaldoBookSeries/mask/' trialname];
    if exist(maskname, 'file') == 2 
        mask = imread(maskname);
        mask = imresize(mask,[size(wholeimg,1) size(wholeimg,2)]);
        mask = rgb2gray(mask);
        mask = double(im2bw(mask,0.5));
        wholeimg = wholeimg.*mask;
    end
%     imshow(wholeimg);
%     pause;
    imwrite(wholeimg, ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarity_waldo/img_id_' sprintf('%03d',i) '.jpg']);
    
end

% %% array
% clear all; close all; clc;
% maskind = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliencyMask/maskind.mat']);
% maskind = maskind.maskind;
% maskind = imresize(maskind, [64 64]);
% 
% rect = [38 52 1 15; ...
%     14 26 1 15; ...
%     1 14 25 40; ...
%     14 26 50 64; ...
%     39 51 50 64; ...
%     52 64 25 40];
% 
% offset = 0.2;
% emptymask = zeros(size(maskind));
% for i = 1:6
%     emptymask(rect(i,1):rect(i,2), rect(i,3):rect(i,4)) = i;
% end
% emptymask = emptymask';
% emptymask = emptymask(:);
% indmask = emptymask';
% mask = zeros(size(indmask));
% mask(find(indmask>0)) = 1;
% indmask = double(indmask);
% mask = double(mask);
% save('Mat/mask_array_ps.mat', 'indmask', 'mask');
% 
% load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/array.mat']);
% totalmask = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliencyMask/masktotal.mat']);
% totalmask = totalmask.masktotal;
% NumImg = length(MyData)/2;
% 
% for i = 1: NumImg
%         
%     trial = MyData(i);    
%     
%     salimg = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/results/topdownHuman/result_30_31_' num2str(i) '.mat']);
%     salimg = salimg.x;
%     salimg = mat2gray(salimg);
%     salimg = double(imresize(salimg, size(totalmask)));
%     salimg = salimg.*totalmask;
%     %salimg = mat2gray(salimg);
%     imwrite(salimg, ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarity_array/array_' num2str(i) '.jpg']);
% end

