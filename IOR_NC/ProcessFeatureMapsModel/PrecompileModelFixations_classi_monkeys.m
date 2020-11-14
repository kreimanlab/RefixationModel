clear all; close all; clc;

type = 'cmonkey';
modelname = 'conv_only'; %'conv_only''classi',scanpathpred_infor', 'scanpathpred', 'curiosity_recog','ScanPred_conv_only_SacSize'
resultdir = 'results_';

if strcmp(type, 'wmonkey')
    filename = 'Datasets/WMonkey/raw/paul_20191111.h5';
    imgnameList = h5read(filename,'/im_fns');
    ImgFolder = 'Datasets/WMonkey/stimuli/';
    
elseif strcmp(type, 'cmonkey')
    load(['IOR_NC/Mat/cmonkey_Fix.mat']);
    imgnameList = Fix_pic;
    ImgFolder = 'Datasets/CMonkey/stimuli/';
end
Cmonkeysize = 596;
imgsize = [64 64];
Fix_posx = {}; Fix_posy = {}; Fix_time = {}; Fix_pic = {}; Fix_start={}; Fix_end={};

for i = 1:length(imgnameList)
    display(i);    
    imgname = imgnameList{i};
    imgname = imgname(find(~isspace(imgname)));
    load(['pytorch/ScanPred_' modelname '/' resultdir type '/' imgname '.mat']);
          
    fix  = fix+1; %python zero-indexed
    fixtrack = [1:length(fix)];
    fixtrack(diff(fix) == 0) = [];
    fix(diff(fix)==0) = [];
    [Fix_x, Fix_y] = ind2sub(imgsize, fix);
    %convert to same as carlos imgsize 596
    fixx = (double(Fix_x)/double(imgsize(1)) * Cmonkeysize)';
    fixy = (double(Fix_y)/double(imgsize(2)) * Cmonkeysize)';    
    fixx = int32(fixx);
    fixy = int32(fixy);    
    
    Fix_posx = [Fix_posx; fixx'];
    Fix_posy = [Fix_posy; fixy'];    
    Fix_pic = [Fix_pic; imgname];
    
    %% for visualization only
%     img = imread([ImgFolder imgname]);
%     img = imresize(img, [Cmonkeysize,Cmonkeysize]);
%     counter = 0;   
%     fixtrack = fixtrack(1:length(fixtrack)-1);
%     for t = fixtrack
%         subplot(2,2,1);
%         imshow(img); hold on;
%         plot(fixx(1:counter+1), fixy(1:counter+1), 'r.');
%         subplot(2,2,2);        
%         imshow(mat2gray(double(squeeze(psmat(t,:,:)))));
%         subplot(2,2,3);        
%         imshow(squeeze(sacprior(t,:,:)));
%         subplot(2,2,4);        
%         imshow(squeeze(IOR(t,:,:)));
%         drawnow;
%         pause(2);
%         counter = counter+1;
%     end
    
end

save(['IOR_NC/Mat/' type '_' modelname '_Fix.mat'],'Fix_posx','Fix_posy','Fix_time','Fix_pic');


