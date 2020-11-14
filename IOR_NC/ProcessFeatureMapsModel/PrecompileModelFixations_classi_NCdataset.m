clear all; close all; clc; %datacursormode on;

type = 'waldo'; %naturaldesign, naturalsaliency, waldo
modelname = 'conv_only'; %conv_only, classi,ScanPred_conv_only_SacSize
resultdir = 'results_';
%'scanpathpred_infor',
%'scanpathpred','classi','ablated_entro','ablated_entro_sal','ablated_sal'

if strcmp(type, 'naturaldesign') || strcmp(type, 'naturalsaliency')
    NumImg = 240;
    imgprefix = 'gray';
    ylimm = [0 1];
    xlimm = [0 30];
    %ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered_gray_3channels/';
    ImgFolder = 'Datasets/ProcessScanpath_naturaldesign/stimuli/';
elseif strcmp(type, 'waldo')
    NumImg = 67;
    imgprefix = 'img_id_';
    ylimm = [0 0.6];
    xlimm = [0 30];
    ImgFolder = 'Datasets/ProcessScanpath_waldo/stimuli/';
else
    NumImg = 300;
    imgprefix = 'array_';
    ylimm = [0 1];
    xlimm = [0 6];
end

finalimgsize = [1280 1024];
imgsize = [64 64];
Fix_posx = {}; Fix_posy = {}; Fix_time = {}; Fix_pic = {}; Fix_start={}; Fix_end={};
scoremat = [];
modelwrongclick = [];

for i = 1:NumImg
    display(i);    
    imgname = [imgprefix sprintf('%03d',i) '.jpg'];
    load(['pytorch/ScanPred_' modelname '/' resultdir type '/' imgname '.mat']);
    %load(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/ScanPred_kld/results_' type '/' imgname '.mat']);
        
    fix  = fix+1; %python zero-indexed
    fixtrack = [1:length(fix)];
    fixtrack(diff(fix) == 0) = [];
    fix(diff(fix)==0) = [];
    
    [Fix_x, Fix_y] = ind2sub(imgsize, fix);
    %convert to same as carlos imgsize 596
    fixx = (double(Fix_x)/double(imgsize(1)) * finalimgsize(1))';
    fixy = (double(Fix_y)/double(imgsize(2)) * finalimgsize(2))';    
    fixx = int32(fixx);
    fixy = int32(fixy);
    
    if strcmp(type, 'naturaldesign')
        [mouseclickwrong, fixy, fixx, score] = fcn_findtargetcheck_naturaldesign(fixy, fixx, i);
        scoremat = [scoremat; score];
        modelwrongclick= [modelwrongclick mouseclickwrong];
    elseif strcmp(type, 'waldo')
        [mouseclickwrong, fixy, fixx, score] = fcn_findtargetcheck_waldo(fixy, fixx, i);
        scoremat = [scoremat; score];
        modelwrongclick= [modelwrongclick mouseclickwrong];
    end
    fixtrack = fixtrack(1:length(fixx));
    
    %% for visualization only 
%     %failure only
%     if strcmp(type, 'naturalsaliency')
%     %if sum(score) == 1 
%         img = imread([ImgFolder imgname]);
%         counter = 0;   
%         fixtrack = fixtrack(1:length(fixtrack)-1);
%         for t = fixtrack
%             subplot(2,2,1);
%             imshow(img);
%             hold on;
%             plot(fixx(1:counter+1), fixy(1:counter+1), 'r.');
%             subplot(2,2,2);        
%             imshow(mat2gray(double(squeeze(psmat(t,:,:)))));
%             subplot(2,2,3);        
%             imshow(squeeze(sacprior(t,:,:)));
%             subplot(2,2,4);        
%             imshow(squeeze(IOR(t,:,:)));
%             drawnow;
%             pause;
%             counter = counter+1;
%         end
%     %end
%     else
%         if sum(score) == 1 
%             img = imread([ImgFolder imgname]);
%             counter = 0;   
%             fixtrack = fixtrack(1:length(fixtrack)-1);
%             for t = fixtrack
%                 subplot(2,2,1);
%                 imshow(img);
%                 hold on;
%                 plot(fixx(1:counter+1), fixy(1:counter+1), 'r.');
%                 subplot(2,2,2);        
%                 imshow(mat2gray(double(squeeze(psmat(t,:,:)))));
%                 %imwrite(mat2gray(double(squeeze(psmat(t,:,:)))), ['/home/mengmi/Desktop/EPSfigs/ComputationalEgs/predicted/predicted_' num2str(t) '.jpg']);
%                 
%                 subplot(2,2,3);        
%                 imshow(squeeze(sacprior(t,:,:)));
%                 %imwrite(squeeze(sacprior(t,:,:)), ['/home/mengmi/Desktop/EPSfigs/ComputationalEgs/sacprior/sacprior_' num2str(t) '.jpg']);
%                 
%                 subplot(2,2,4);        
%                 imshow(squeeze(IOR(t,:,:)));
%                 %imwrite(squeeze(IOR(t,:,:)), ['/home/mengmi/Desktop/EPSfigs/ComputationalEgs/IORmem/IORmem_' num2str(t) '.jpg']);
%                 
%                 drawnow;
%                 pause;
%                 counter = counter+1;
%             end
%         end
%     
%     end
%     
    Fix_posx = [Fix_posx; fixx'];
    Fix_posy = [Fix_posy; fixy'];    
    Fix_pic = [Fix_pic; imgname];
end

save(['IOR_NC/Mat/' type '_' modelname '_Fix.mat'],'modelwrongclick', 'Fix_posx','Fix_posy','Fix_pic','scoremat');

% if strcmp(type, 'naturaldesign') || strcmp(type, 'waldo')
%     hb = figure;
%     hold on;
%     NumFix = 80;
%     NumSubj = 15;
% 
%     errorbar([1:NumFix], cumsum(nanmean(scoremat,1)), nanstd(scoremat,[],1)/(length(NumImg)),'b');
% 
%     load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/DataForPlot/IVSNrecog_' type '.mat']);
%     scoremat = zeros(NumImg,NumFix);
%     for h = 1:NumImg
%         if ~isnan(hm(h))
%             scoremat(h,hm(h)) = 1;
%         end
%     end
%     errorbar([1:NumFix], cumsum(nanmean(scoremat,1)), nanstd(scoremat,[],1)/(length(NumImg)),'b--');
% 
%     load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/DataForPlot/humanRecog_' type '.mat']);
%     scoretotal = [];
%     for s = 1:NumSubj
%         hm = hrecog(s,:);
%         scoremat = zeros(NumImg,NumFix);
%         for h = 1:NumImg
%             if ~isnan(hm(h))
%                 scoremat(h,hm(h)) = 1;
%             end
%         end
%         scoretotal = [scoretotal; nanmean(scoremat,1)];
%     end
%     errorbar([1:NumFix], cumsum(nanmean(scoretotal,1)), nanstd(scoretotal,[],1)/(length(NumImg)),'r');
% 
%     ylim(ylimm);
%     xlim(xlimm);
%     xlabel('Fixation Number');
%     ylabel('Cummulative performance');
%     legend('ReturnModel','IVSNrecog','Humans');
%     
%     display(['modelwrongclick: ' num2str(mean(modelwrongclick)) ]);
% end
