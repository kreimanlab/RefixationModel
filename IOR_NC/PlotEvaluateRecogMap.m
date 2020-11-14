clear all; close all; clc;

type = 'naturaldesign';

if strcmp(type, 'waldo')
    ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean/';
    prefix = 'img_id_';
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/waldo.mat']);
    NumImg = 67;
    
elseif strcmp(type, 'array')
    ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuliRGB/';
    totalmask = load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliencyMask/masktotal.mat']);
    totalmask = totalmask.masktotal;
    prefix = 'array_';
    NumImg = 300;
    numarray = 6;
else
    ImageFolder = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered_gray_3channels/';
    prefix = 'gray';
    NumImg = 240;
    
end

w = 1024;h=1280;
GTFolder = ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CGround_' type '/' ];
%RecogFolder = ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CSimilarity_' type '/'];
RecogFolder = ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CRecog_' type '/'];

%% comment out
% AccumT = {};
% AccumF = {};
% AccumM = [];
% distriT = [];
% distriF = [];
% 
% if strcmp(type, 'array')
%     load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
%     for i = 1:NumImg
%         i
%         trial = MyData(i);
%         [gtind num] = find(  trial.arraycate == trial.targetcate);
%         ff = [];
%         for chosenfix = 1:6
%             
%             load(['/media/mengmi/KLAB15/Mengmi/Proj_memory/Recog_array/img_' num2str(i) '_' num2str(chosenfix) '.jpg_224.mat']);
%             if chosenfix == gtind
%                 Trecogmap = recogmap;
%             else
%                 ff = [ff recogmap];
%             end            
%             
%         end
%         allff = mat2gray([Trecogmap ff]);
%         AccumT = [AccumT allff(1)]; 
%         AccumM = [AccumM allff(1)]; 
%         distriT = [distriT allff(1)];
%         AccumF = [AccumF allff(2:end)'];
%     end
%     
% else   
% 
%     for i = 1:NumImg
%         i
%         if strcmp(type, 'array')
%             stimuliname = [prefix num2str(i) '.jpg'];    
%         else
%             stimuliname = [prefix sprintf('%03d',i) '.jpg'];  
%         end
%         stimuli = imread([ImageFolder stimuliname]);
%         gt = imread([GTFolder stimuliname]);
%         gt = imresize(gt, [w h]);
%         gt = mat2gray(gt);
% 
%         gt = imdilate(gt, strel('disk',100));
%         %imshow(gt);
%         
%         recogmap = imread([RecogFolder stimuliname]);
%         recogmap = imresize(recogmap, [w h]);
%         recogmap = mat2gray(recogmap);
% 
% 
%         targetval = recogmap(find(gt >= 0.95));
%         targetmean = mean(targetval);
%         distriT = [distriT; targetval];
% 
%         otherval = recogmap(find(gt<0.95));
%         %distriF = [distriF; otherval];
% 
%         AccumT = [AccumT targetval];
%         AccumF = [AccumF otherval];
%         AccumM = [AccumM mean(targetmean)];
%     end
% 
% end
% %distriF = distriF(1:length(distriT));
% thres = mean(AccumM);
% save(['Mat/distri_recog_' type '.mat'],'distriT','AccumT','AccumM','thres');
% save(['Mat/distri_recog_' type '_distriF.mat'],'AccumF','-v7.3');

%% stop commenting
% load(['Mat/distri_recog_' type '.mat']);
% load(['Mat/distri_recog_' type '_distriF.mat']);        
%  
% %% bar plot for False positive; etc
% FP = []; FN = []; TP = []; TN = [];
% average = zeros(2,2);
% for i = 1:NumImg
%     i
%     T = AccumT{i};
%     F = AccumF{i};   
%     
%     targets = [ones(1,length(T)), zeros(1, length(F)) ];
%     outputs = [T; F]';
%     
%     if strcmp(type, 'waldo')
%         %outputs = (outputs > 0.14 & outputs < 0.2) | (outputs > 0.02 & outputs < 0.1);
%         outputs = (outputs > 0.5);
%         %outputs = (outputs <0.2);
%     else
%         outputs = (outputs > thres);
%     end
%     
%     outputs = double(outputs);
%     [c,cm,ind,per] = confusion(targets,outputs);
%     if strcmp(type, 'array')
%         cm = cm/6;
%     else
%         cm = cm/(w*h);
%     end
%     %plotconfusion(targets,outputs);
%     average = average + cm;
% end
% averagec = average/NumImg;
% averageplot = averagec(:);
% hb = figure;
% 
% bar(averageplot(2:4));
% %[TN, FN, FP, TP]
% ylim([0 0.5]);
% xticks([1:3]);
% xticklabels({'FN','FP','TP'});
% ylabel('probability');
% title(type);
% printpostfix = '.eps';
% printmode = '-depsc'; %-depsc
% printoption = '-r200'; %'-fillpage'
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['Figures/RecogModelStats_' type printpostfix],printmode,printoption);
% datacursormode(hb)

%% Human False positive
%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
else
    HumanNumFix = 65;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end

wrongclick = [];
for s = 1:length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    %nanmean(subjclickwrong)
    %length(subjclickwrong)
    %subjclickwrong = subjclickwrong(1:NumStimuli/2);    
    wrongclick = [wrongclick nanmean(subjclickwrong)];
end
save(['Mat/mouseclick_human_' type '.mat'],'wrongclick');
hb = figure;
bar(wrongclick);
hold on;
plot([1:length(subjlist)], nanmean(wrongclick)*ones(1,length(subjlist)), 'k--');
title(['dataset: ' type ]);
xlabel('subject number');
ylabel('false positive')
display(['=========initial click was wrong']);
display(['mean: ' num2str(mean(wrongclick))]);
display(['STD: ' num2str(std(wrongclick)) ]);
 
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/FalsePositiveHumans_' type printpostfix],printmode,printoption);
    
    
%% Similarity and Recog Value distribution between targets and non-targets
% TD = []; NTD = []; TD2 = [];
% binranges = [0:0.02:1];
% average = zeros(2,2);
% for i = 1:NumImg
%     i
%     T = AccumT{i};
%     F = AccumF{i};
%     
%     if strcmp(type, 'array') && i>180
%         TD2 = [TD2; T];
%     else
%         TD = [TD; T];
%     end
%     NTD = [NTD; F];
% end
% 
% linewidth = 3;
% hb = figure; hold on;
% firstRT = TD;
% bincounts = histc(firstRT,binranges);
% plot(binranges, bincounts/sum(bincounts),'b-','LineWidth',linewidth);
% 
% if strcmp(type, 'array')
%     firstRT = TD2;
%     bincounts = histc(firstRT,binranges);
%     plot(binranges, bincounts/sum(bincounts),'c-','LineWidth',linewidth);
% end
% firstRT = NTD;
% bincounts = histc(firstRT,binranges);
% plot(binranges, bincounts/sum(bincounts),'r-','LineWidth',linewidth);
% 
% %title('ReactionTimeFirstFix');
% xlabel('Cosine Similarity value','FontSize', 11);
% ylabel('Proportion','FontSize', 11);
% if strcmp(type, 'array')
%     legend({'target (diff)','target (same)','non-target'});
% else
%     legend({'target','non-target'});
% end
% xlim([0 1]);
% ylim([0 1]); 
% title(type);
% printpostfix = '.eps';
% printmode = '-depsc'; %-depsc
% printoption = '-r200'; %'-fillpage'
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['Figures/RecogModelDistri_' type printpostfix],printmode,printoption);
    

