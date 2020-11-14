clear all; close all; clc;

type = 'array'; %array, naturaldesign, naturalsaliency, waldo
modelname = 'conv_only';  %conv_only, classi
%'scanpathpred_infor',
%'scanpathpred','classi','ablated_entro','ablated_entro_sal','ablated_sal'

if strcmp(type, 'naturaldesign') || strcmp(type, 'naturalsaliency')
    NumImg = 240;
    imgprefix = 'gray';
    ylimm = [0 1];
    xlimm = [0 30];
    NumFix = 80;
    
elseif strcmp(type, 'waldo')
    NumImg = 67;
    imgprefix = 'img_id_';
    ylimm = [0 0.6];
    xlimm = [0 30];
    NumFix = 80;
    
else
    NumImg = 300;
    imgprefix = 'array_';
    ylimm = [0 1];
    xlimm = [0 6];
    NumFix = 6;
    %scanpath processed coordinates
    fix1 = [365 988 0 ];
    fix2 = [90 512 0];
    fix3 = [365 36 0];
    fix4 = [915 36 0];
    fix5 = [1190 512 0];
    fix6 = [915 988 0];
    fixO = [fix1; fix2; fix3; fix4; fix5; fix6];
    
    ImgFolder = 'Datasets/ProcessScanpath_array/stimuli_simplified/';
end

% load(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/Mat/distri_recog_' type '.mat']);
% load(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/Mat/distri_recog_' type '_distriF.mat']);

load('IOR_NC/Mat/mask_array_ps.mat');
load(['Datasets/SubjectArray/array.mat']);

finalimgsize = [1280 1024];
imgsize = [64 64];
Fix_posx = {}; Fix_posy = {}; Fix_time = {}; Fix_pic = {}; Fix_start={}; Fix_end={};
scoremat = [];

for i = 1:NumImg
    display(i);  
    trial = MyData(i);
    
    imgname = [imgprefix num2str(i) '.jpg'];
    load(['pytorch/ScanPred_' modelname '/results_' type '/' imgname '.mat']);
    %load(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/ScanPred_kld/results_' type '/' imgname '.mat']);
        
    fix  = fix+1; %python zero-indexed
    fixtrack = [1:length(fix)];
    fixtrack(diff(fix) == 0) = [];
    fix(diff(fix)==0) = [];
    
    
    fix = indmask(fix);
    fix = fix(2:end);
    fixtrack = fixtrack(2:end);
    fixtrack(diff(fix)==0) = [];
    fix(diff(fix)==0) = [];
    
    if strcmp(type, 'naturaldesign')
        [fixx, fixy, score] = fcn_findtargetcheck_naturaldesign(fixx, fixy, i);
        scoremat = [scoremat; score];
    elseif strcmp(type, 'waldo')
        [fixx, fixy, score] = fcn_findtargetcheck_waldo(fixx, fixy, i);
        scoremat = [scoremat; score];
    else
        [fix, score] = fcn_findtargetcheck_array(fix, i, trial);
        scoremat = [scoremat; score];
    end
    fixtrack = fixtrack(1:length(fix));
    
    fixx = fixO(fix,1);
    fixy = fixO(fix,2);
    fixx = [640; fixx]; 
    fixy = [512; fixy];   
    fixx = int32(fixx);
    fixy = int32(fixy);
    
    if sum(score) == 1
        display('target found')
    end
    %% for visualization only
%     %failure only
%     if sum(score) == 1
%         fix
%         img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli_array_screen_inference/' imgname]);
%         img = img(190:840,265:1015);
%         img = imresize(img, [1024 1280]);
%         [gtind num] = find(  trial.arraycate == trial.targetcate);
%         counter = 0;
%         fixtrack = fixtrack(1:length(fixtrack)-1)
%         for t = fixtrack
%             subplot(2,2,1);        
%             imshow(img);             
%             hold on;
%             fixx(1:counter+1)
%             fixy(1:counter+1)
%             plot(fixx(1:counter+1), fixy(1:counter+1), 'r.');
%             title(['gt = ' num2str(gtind)]);
%             subplot(2,2,2);        
%             imshow(mat2gray(double(squeeze(psmat(t,:,:)))));
%             title('predicted prob');
%             subplot(2,2,3);        
%             imshow(squeeze(sacprior(t,:,:)));
%             title('sac prior');
%             subplot(2,2,4);        
%             imshow(squeeze(IOR(t,:,:)));
%             title(['IOR; t=' num2str(t)]);            
%             pause;
%             counter = counter+1;
%         end
%     end

    Fix_posx = [Fix_posx; fixx'];%need to be 1 x N dim
    Fix_posy = [Fix_posy; fixy'];%need to be 1 x N dim     
    Fix_pic = [Fix_pic; imgname];
end

save(['IOR_NC/Mat/' type '_' modelname '_Fix.mat'],'Fix_posx','Fix_posy','Fix_pic','scoremat');

% if strcmp(type, 'naturaldesign') || strcmp(type, 'waldo') || strcmp(type, 'array')
%     hb = figure;
%     hold on;    
%     NumSubj = 15;
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
%     scoretotal = [];
%     for s = 1:NumSubj
%         load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/DataForPlot/human_subj' num2str(s) '_array_recog.mat']);
%         
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
% end
