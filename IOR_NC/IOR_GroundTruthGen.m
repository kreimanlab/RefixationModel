clear all; close all; clc;
addpath('ScanMatch');
type = 'array'; %waldo, wizzard, naturaldesign, array

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
   
    fix1 = [365 988 0 ];
    fix2 = [90 512 0];
    fix3 = [365 36 0];
    fix4 = [915 36 0];
    fix5 = [1190 512 0];
    fix6 = [915 988 0];

    FIXLIST = [fix1; fix2; fix3; fix4; fix5; fix6];

elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end
    
markerlist = {'r','g','b','c','k','m',     'r*-','g*-','b*-','c*-','k*-','m*-',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;

centerR = [];

if strcmp(type, 'array')
    for i = 1:NumStimuli/2
        trial = MyData(i);
        [gtind num] = find(  trial.arraycate == trial.targetcate);
        ctrx = FIXLIST(gtind,1);
        ctry = FIXLIST(gtind,2);
        
        centerR = [centerR ctrx ctry];
    end
    
    
end
        
if strcmp(type, 'naturaldesign')
    for i = 1:NumStimuli/2
        
        img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(i) '.jpg' ]); 
        img = imresize(img, [Imgw Imgh]);
        img = im2bw(img,0.5);        
        [row, col] = find(img==1);
        leftx = min(col);lefty = min(row);rightx = max(col);righty = max(row);
        ctrx = floor((leftx + rightx)/2); %horizontal; 1280
        ctry = floor((lefty + righty)/2); %vertical; 1024
        centerR = [centerR ctrx ctry];
    end
end

if strcmp(type, 'waldo')
    for i = 1:NumStimuli/2
        
        trial = MyData(i);
        img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/WaldoBookSeries/CroppedJPEG/gt' trial.targetname(8:end)]); 
        img = imresize(img, [Imgw Imgh]);
        img = im2bw(img,0.5);        
        [row, col] = find(img==1);
        leftx = min(col);lefty = min(row);rightx = max(col);righty = max(row);
        ctrx = floor((leftx + rightx)/2); %horizontal; 1280
        ctry = floor((lefty + righty)/2); %vertical; 1024
        centerR = [centerR ctrx ctry];
    end
end
        
centerR = reshape(centerR, [2 NumStimuli/2]);        
save(['Mat/GTRatioList_' type '.mat'],'centerR');        
        
        
