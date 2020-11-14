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
%    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr'}; %array
   MaxPlotFix = 6; 
   xtickrange = [1:MaxPlotFix];
   SimilarityName = 'Mat_FixationPatchArray_224';
   load(['Mat/GTRatioList_' type '.mat']);
   ImagePatchName = 'FixationPatchArray_224/';
   TargetDir =  '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli/target_';
   SegTargetDir = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/FinalSelected/cate'];
   NsampleList = [1:3:77];
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
%     subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi'}; %natural design
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    SimilarityName = 'Mat_FixationPatchNaturalDesign_224';
    ImagePatchName = 'FixationPatchNaturalDesign_224/';
    TargetDir = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/targetgray';
    SegTargetDir = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/segmentedTarget/st';
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

Selected = [];

for s = 1: length(subjlist)
    load(['Datasets/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
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

SelectedT = Selected;
save(['Mat/' type '_selected_mturk.mat'],'SelectedT');

load(['Mat/' type '_selected_mturk.mat']);

WriteDir = ['mturk/stimuli/' type '/'];
mkdir(WriteDir);
mkdir([WriteDir 'random']);
mkdir([WriteDir 'RNR']);
mkdir([WriteDir 'targetS']);
mkdir([WriteDir 'targetT']);


for x = 1:size(SelectedT,1)
    s = SelectedT(x,1);
    i = SelectedT(x,2);
    j = SelectedT(x,3);
        
    filename = [ImagePatchName subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
	img = imread(filename);
    img = imresize(img, [224 224]);
    imwrite(img, [WriteDir 'RNR/stimuli_' num2str(i) '_subj_' num2str(s) '_Return.jpg']);
    
    s = SelectedT(x,1);
    i = SelectedT(x,2);
    j = SelectedT(x,4);
    filename = [ImagePatchName '/' subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '.jpg'];
	img = imread(filename);
    img = imresize(img, [224 224]);
    imwrite(img, [WriteDir 'RNR/stimuli_' num2str(i) '_subj_' num2str(s) '_nonReturn.jpg']);
    
    if strcmp(type, 'array')
        target = [TargetDir num2str(i) '.jpg'];
    else
        target = [TargetDir sprintf( '%03d', i ) '.jpg'];
    end
    imgT = imread(target);
    imgT = imresize(imgT, [224 224]);
    imwrite(imgT, [WriteDir 'targetT/stimuli_' num2str(i) '_targetT.jpg']);
    
    % segmented target
    if strcmp(type, 'array')
        trial = MyData(i);
        ind = trial.arrayimgnum( find(trial.targetcate == trial.arraycate));
        target = [SegTargetDir num2str(trial.targetcate) '/img' num2str(ind) '.jpg'];
    else
        target = [SegTargetDir num2str(i) '.jpg'];
    end
    imgT = imread(target);
    %imshow(imgT);pause;
    imgT = imresize(imgT, [224 224]);
    imwrite(imgT, [WriteDir 'targetS/stimuli_' num2str(i) '_targetS.jpg']);
    
end

display(['writing images']);

RandNum = 10;
ImgDir = 'mturk/RandomPics/bg';
WriteDir = ['mturk/stimuli/' type '/random/img_id_']; 
for r = 1:RandNum
    img = imread([ImgDir num2str(r) '.jpg']);
    img = imresize(img, [1028 1240]);
    fun = @(block_struct) imwrite(rgb2gray(block_struct.data),[WriteDir sprintf('%03d',r) '_' num2str(block_struct.location(1)) '_' num2str(block_struct.location(2)) '.jpg']);    
    blockproc(img,[257 311],fun);

end

display(['writing random images']);

fileID = fopen(['mturk/RNR_' type '.txt'],'w');
for x = 1:size(SelectedT,1)
    s = SelectedT(x,1);
    i = SelectedT(x,2);   

    string1 = ['stimuli_' num2str(i) '_subj_' num2str(s)];
    fprintf(fileID, '%s\n', string1);
end
fclose(fileID);

display(['writing directory text for RNR']);

fileID = fopen(['mturk/random_' type '.txt'],'w');
Rimglist = [WriteDir '*.jpg'];
imglist = dir(Rimglist);
for x = 1:length(imglist)
    
    string1 = [imglist(x).name];
    fprintf(fileID, '%s\n', string1);
end
fclose(fileID);

display(['writing directory text for random']);