clear all; clc; close all;

type = 'naturaldesign'; %waldo, naturaldesign, array

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
   %subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr'}; %array
   MaxPlotFix = 6; 
   xtickrange = [1:MaxPlotFix];
   SimilarityName = 'Mat_FixationPatchArray_224';
   load(['Mat/GTRatioList_' type '.mat']);
   ImagePatchName = 'FixationPatchArray_224/';
   TargetDir =  '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli/target_';
   NsampleList = [1:3:77];
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    %subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi'}; %natural design
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    SimilarityName = 'Mat_FixationPatchNaturalDesign_224';
    ImagePatchName = 'FixationPatchNaturalDesign_224/';
    TargetDir = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/targetgray';
    NsampleList = [1:4:122];
end

load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);


[B,seqInd] = sort(seq);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;
LayerSelected = 2;

LimitPatchNum = 400;
Selected = [];

for s = 1: length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    
    if ~strcmp(type,'array')
        Found = FixData.TargetFound;
        Found = Found(seqInd,:);
        Found = Found(1:NumStimuli/2,:);    
    end
    
    PosX = PosX(seqInd);
    PosY = PosY(seqInd);
        
    %all trials
    Firstx = PosX(1:NumStimuli/2);
    Firsty = PosY(1:NumStimuli/2);
    
    for i = 1:NumStimuli/2
        
       display(['processing ... subj: ' num2str(s) '; img: ' num2str(i) ]);
       num = size(Selected,1);
       if num > LimitPatchNum
           break;
       end
       
       fx = double(Firstx{i});
       fy = double(Firsty{i});
       
       if ~strcmp(type,'array')
            found = Found(i,:);
            if length(find(found == 1)) > 0
                found = 1;
            else
                found = 0;
            end
       else
           if length(find(fx == centerR(1,i) & fy == centerR(2,i))) > 0
               found = 1;
           else
               found = 0;
           end
       end
       
       % remove those trials with only one fixation
        if length(fx)== 1
            continue;            
        end
        
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
        if ~isempty(overlappairsnt)
            if length(fx) ~= overlappairsnt(1,3)            
                overlappairsnt = overlappairsnt +1;
                %overlappairst = overlappairst +1;
            end
        
            overlappairsnt = overlappairsnt(:,1:2);
            %overlappairsnt = overlappairsnt + 1;
            overlappairsnt = overlappairsnt(:);
        else
            continue;
        end
        if ~isempty(overlappairst)            
            if length(fx) ~= overlappairst(1,3)            
                %overlapnt = overlapnt +1;
                overlappairst = overlappairst +1;
            end
            
            overlappairst = overlappairst(:,1:2);
            %overlappairst = overlappairst + 1;
            overlappairst = overlappairst(:);
        end
        
        %overlap = [overlappairst; overlappairsnt];
        %overlap = unique(overlap);
        overlapnt = [overlappairsnt];
        overlapt = [overlappairst];
        overlapnt = unique(overlapnt);
        overlapt = unique(overlapt);
        
        
        allind = [1:length(fx)];
        allind([overlapnt; overlapt]) = [];
        
        if length(allind)>2
            allind(end) = [];
            allind(1) = [];
        else
            continue;
        end
        if strcmp(type, 'array')
            RL = randperm(length(overlapnt), 1);
            eg = [s i overlapnt(RL)-1 ];
            RL = randperm(length(allind), 1);
            eg = [eg allind(RL)-1];
            Selected = [Selected; eg];
            %filename = [SimilarityName '/' subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.mat'];
                
        else
            
            %filename = [SimilarityName '/' subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.mat'];
            RL = randperm(length(overlapnt), 1);
            eg = [s i overlapnt(RL) ];
            RL = randperm(length(allind), 1);
            eg = [eg allind(RL) ];
            Selected = [Selected; eg];
        end   
        
    end
    
end
num = size(Selected,1);
% num = randperm(num, num);
% Selected = Selected(num,:);
% firstS = Selected(:,2);
% [a b] = unique(firstS);
SelectedT = Selected(1:LimitPatchNum,:);
save(['Mat/' type '_selectedClassi.mat'],'SelectedT');

load(['Mat/' type '_selectedClassi.mat']);

WriteDir = ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '/'];
mkdir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '/']);
mkdir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '/return/']);
mkdir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '/nonreturn/']);

for x = [1:LimitPatchNum]
    
    s = SelectedT(x,1);
    i = SelectedT(x,2);
    j = SelectedT(x,3);    
    filename = [ImagePatchName subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
	img = imread(filename);
    img = imresize(img, [224 224]);
    imwrite(img, [WriteDir 'return/stimuli_' num2str(s) '_' num2str(i) '_' num2str(j) '_Return.jpg']);
    
    s = SelectedT(x,1);
    i = SelectedT(x,2);
    j = SelectedT(x,4);
    filename = [ImagePatchName  subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
	img = imread(filename);
    img = imresize(img, [224 224]);
    imwrite(img, [WriteDir 'nonreturn/stimuli_' num2str(s) '_' num2str(i) '_' num2str(j) '_nonReturn.jpg']);
    
%     if strcmp(type, 'array')
%         target = [TargetDir num2str(i) '.jpg'];
%     else
%         target = [TargetDir sprintf( '%03d', i ) '.jpg'];
%     end
%     imgT = imread(target);
%     imgT = imresize(imgT, [224 224]);
%     imwrite(imgT, [WriteDir 'stimuli_' num2str(i) '_target.jpg']);
    
end

NumCrossval = 5;
PerTest = size(SelectedT,1)/NumCrossval;

for c = 1:NumCrossval
    
    load(['Mat/' type '_selectedClassi.mat']);
    
    mkdir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '_crossval_' num2str(c) '/']);
    mkdir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '_crossval_' num2str(c) '_test/']);
    mkdir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '_crossval_' num2str(c) '/return/']);
    mkdir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type  '_crossval_' num2str(c) '/nonreturn/']);
    ori = [1:LimitPatchNum];
    ori([PerTest*(c-1)+1:PerTest*c]) = [];
    testori = [PerTest*(c-1)+1:PerTest*c];
    
    for x = ori

        s = SelectedT(x,1);
        i = SelectedT(x,2);
        j = SelectedT(x,3);    
        filename = [ImagePatchName subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
        img = imread(filename);
        img = imresize(img, [224 224]);
        if length(size(img)) == 2
            img = cat(3, img, img, img);
        end
        imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '_crossval_' num2str(c) '/return/stimuli_' num2str(s) '_' num2str(i) '_' num2str(j) '_Return.jpg']);

        s = SelectedT(x,1);
        i = SelectedT(x,2);
        j = SelectedT(x,4);
        filename = [ImagePatchName  subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
        img = imread(filename);
        img = imresize(img, [224 224]);
        if length(size(img)) == 2
            img = cat(3, img, img, img);
        end
        imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type  '_crossval_' num2str(c) '/nonreturn/stimuli_' num2str(s) '_' num2str(i) '_' num2str(j) '_nonReturn.jpg']);

    end
    
    for x = testori

        s = SelectedT(x,1);
        i = SelectedT(x,2);
        j = SelectedT(x,3);    
        filename = [ImagePatchName subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
        img = imread(filename);
        img = imresize(img, [224 224]);
        if length(size(img)) == 2
            img = cat(3, img, img, img);
        end
        imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '_crossval_' num2str(c) '_test/stimuli_' num2str(s) '_' num2str(i) '_' num2str(j) '_Return.jpg']);

        s = SelectedT(x,1);
        i = SelectedT(x,2);
        j = SelectedT(x,4);
        filename = [ImagePatchName  subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
        img = imread(filename);
        img = imresize(img, [224 224]);
        if length(size(img)) == 2
            img = cat(3, img, img, img);
        end
        imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '_crossval_' num2str(c) '_test/stimuli_' num2str(s) '_' num2str(i) '_' num2str(j) '_nonReturn.jpg']);

    end
    
end


