% %% naturaldesign
% clear all;close all;clc;
% 
% w = 64;
% h = 64;
% 
% for i = 1:240
%     i
%     wholeimg = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(i) '.jpg' ]);
%     gt = imresize(wholeimg, [w h]);
%     gt = im2bw(gt,0.5);
%     gtimg = double(gt);
%     gtimg = mat2gray(gtimg);
%     imshow(gtimg);
%     %pause;
%     imwrite(gtimg, ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CGround_naturaldesign/gray' sprintf('%03d',i) '.jpg']);
%    
%     
% end

% %% waldo
% clear all;close all;clc;
% 
% w = 64;
% h = 64;
% 
% load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/waldo.mat']);
% mkdir('/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CGround_waldo/');
% for i = 1:length(MyData)/2
%             
%     path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean_gt/gt_' sprintf('%03d', i) '.jpg'];
%     gt = imread(path);
%     gt = imresize(gt,[w,h]);
%     gt = mat2gray(gt);
%     gt = im2bw(gt,0.5);
%     gtimg = double(gt);
% %     imshow(gtimg); 
% %     pause;
%     imwrite(gtimg, ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CGround_waldo/img_id_' sprintf('%03d',i) '.jpg']);
%     
% end

% %% array
% clear all; close all; clc;
% w = 64; h= 64;
% load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/array.mat']);
% NumImg = length(MyData)/2;
% 
% for i = 1: NumImg
%         
%     trial = MyData(i);    
%     [gtind num] = find(  trial.arraycate == trial.targetcate);
%     salimg = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliencyMask/mask' num2str(gtind) '.jpg']);
%     gt = imresize(salimg,[w,h]);
%     gt = mat2gray(gt);
%     gt = im2bw(gt,0.5);    
% %     imshow(gt); 
% %     pause;
%     imwrite(gt, ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CGround_array/array_' num2str(i) '.jpg']);
% end
