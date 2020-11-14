clear all; close all; clc;

type = 'naturaldesign';

if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
   MaxPlotFix = 6; 
   xtickrange = [1:MaxPlotFix];
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
elseif strcmp(type, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 80;
    xtickrange = [1 10:10:MaxPlotFix];
end
    
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);

[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;
ImgSz = 64;

imgvalid = [1:NumStimuli/2];
Splits = 3; %must be divisible by total number of images
Blk = NumStimuli/2/Splits;
TrainSet = {};
TestSet = {};
for b = 1:Splits
    ts = [(b-1)*Blk+1:b*Blk];
    all = [1:NumStimuli/2];
    all(ts) = [];
    trains = all;
    TrainSet = [TrainSet trains];
    TestSet = [TestSet ts];
end

for S = 1:length(TrainSet)
    
    fileIDGT = fopen(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/datalist/trainsetGT_' type '_' num2str(S) '.txt'],'w');
    fileIDImg = fopen(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/datalist/trainsetImg_' type '_' num2str(S) '.txt'],'w');
    fileIDPath = fopen(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/datalist/trainsetPath_' type '_' num2str(S) '.txt'],'w');
        
    for s = 1: length(subjlist)
        load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
        PosX = FixData.Fix_posx;
        PosY = FixData.Fix_posy;
        PosX = PosX(seqInd);
        PosY = PosY(seqInd);

        %all trials
        Firstx = PosX(1:NumStimuli/2);
        Firsty = PosY(1:NumStimuli/2);

        for i = TrainSet{S}
            fx = int32(double(Firstx{i})/Imgh*ImgSz);
            fy = int32(double(Firsty{i})/Imgw*ImgSz);
            fx(find(fx<1)) = 1;fy(find(fy<1)) = 1; 
            fx(find(fx>ImgSz)) = ImgSz;fy(find(fy>ImgSz)) = ImgSz; 
            fix = fx + (fy-1)*ImgSz;
            
            for f = 1:length(fix)-1
                string1 = ['gray' sprintf('%03d',i) '.jpg'];
                fprintf(fileIDImg, '%s\n', string1);
                string1 = [sprintf('%d ', fix(1:f))];
                string1 = string1(1:end-1);
                fprintf(fileIDPath, '%s\n', string1);
                string1 = [num2str(fix(f+1))];
                fprintf(fileIDGT, '%s\n', string1);

            end
        end
    end

end

for S = 1:length(TestSet)
    
    %fileIDGT = fopen(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/datalist/trainsetGT_' type '_' num2str(S) '.txt'],'w');
    fileIDImg = fopen(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/datalist/testsetImg_' type '_' num2str(S) '.txt'],'w');
    %fileIDPath = fopen(['/media/mengmi/TOSHIBABlue1/Proj_memory/pytorch/datalist/trainsetPath_' type '_' num2str(S) '.txt'],'w');
    for i = TestSet{S}

        string1 = ['gray' sprintf('%03d',i) '.jpg'];
        fprintf(fileIDImg, '%s\n', string1);

    end
    

end