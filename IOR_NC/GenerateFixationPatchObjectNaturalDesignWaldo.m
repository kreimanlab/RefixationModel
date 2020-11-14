clear all; close all; clc;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

type = 'naturaldesign';

if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design
%     subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
%         'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
%         'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end

prefix = '/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/';
load([prefix 'SubjectArray/' type '.mat']);
load([prefix 'SubjectArray/' type '_seq.mat']);
[B,seqInd] = sort(seq);

%load(['../Mat/datasetloc_' type '.mat']);

subjstore = [];
stimulistore = [];
patchstore = [];
%PrevError = {};
%locxstore = [];
%locystore = [];

receptiveSize = 156;
w = 1024;
h = 1280;

for i = 1: length(subjlist)
    load([prefix 'Code/ProcessScanpath_' type  '/' subjlist{i} '.mat']);
    if ~strcmp( 'array', type)
        TargetFound = FixData.TargetFound(:,:);
        TargetFound = TargetFound(seqInd,:);
    else
        TargetFound = scoremat;
    end
      
    PosX = FixData.Fix_posx; %horizontal
    PosY = FixData.Fix_posy; %vertical
    PosX = PosX(seqInd);
    PosY = PosY(seqInd);
    
    for j = 1: NumStimuli/2
              
        trialfixseqx = PosX{j};
        trialfixseqy = PosY{j};
        trialfixseqx(find(isnan(trialfixseqx))) = [];
        trialfixseqy(find(isnan(trialfixseqy))) = [];
        if isempty(trialfixseqx)
            %invalid human trial
            continue;
        end
        selectind = length(trialfixseqx);
        
%         gtind = find(TargetFound(j,:) == 1);
%         
%         if isempty(gtind)
%             %human cant find target
%             selectind = length(trialfixseqx);
%         else
%             if gtind == 1
%                 continue;
%             else
%                 selectind = gtind - 1;
%             end
%         end
        
        preverrorx = [];
        preverrory = [];
                
        if strcmp(type,'waldo')
            imgpath =['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean/img_id_' sprintf('%03d',j) '.jpg'];
            path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean_gt/gt_' sprintf('%03d',j) '.jpg'];
        else
            imgpath = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gray' sprintf('%03d',j) '.jpg'];
            path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(j) '.jpg' ];
        end
        
        img = imread(imgpath);
        
%         if strcmp(type,'naturaldesign')
%             img = rgb2gray(img);
%         end
        img = imresize(img, [w h]);
        
%         gt = double(imread(path));
%         gt = imresize(gt,[w,h]);
%         gt = mat2gray(gt);
%         gt = im2bw(gt,0.5);
%         gt = double(gt);
%         loc = datasetloc{j};
%         locx = loc{1};
%         locy = loc{2};

%         accumMap = zeros(w, h);
%         binaryMap = zeros(w, h);
%         stripMap = zeros(w, h);
        
        for k = 1:selectind
            
            x = trialfixseqx(k);
            y = trialfixseqy(k);
            
            if x<1
                warning('prob');
                x = 1;
            end
            if x>h
                warning('prob');
                x = h;
            end
            if y<1
                warning('prob');
                y = 1;
            end
            if y>w
                warning('prob');
                y = w;
            end
            
            fixatedPlace_leftx = x - receptiveSize/2 + 1;
            fixatedPlace_rightx = x + receptiveSize/2;
            fixatedPlace_lefty = y - receptiveSize/2 + 1;
            fixatedPlace_righty = y + receptiveSize/2;
        
            if fixatedPlace_leftx < 1
                fixatedPlace_leftx = 1;
            end
            if fixatedPlace_lefty < 1
                fixatedPlace_lefty = 1;
            end
            if fixatedPlace_rightx > h
                fixatedPlace_rightx = h;
            end
            if fixatedPlace_righty > w
                fixatedPlace_righty = w;
            end
%             fixatedPlace = gt(fixatedPlace_lefty:fixatedPlace_righty, fixatedPlace_leftx:fixatedPlace_rightx);
%         
%             if sum(sum(fixatedPlace)) > 0                 
%                 break;
%             end
            
            fixatedPlace = img(fixatedPlace_lefty:fixatedPlace_righty, fixatedPlace_leftx:fixatedPlace_rightx,:);
            %binaryMap( y, x ) = 1;
            %G = fspecial('gaussian',[500 500],100);            
            %Ig = imfilter(binaryMap,G,'same');
            %Ig = mat2gray(Ig);
%             imshow(imresize(Ig,[224 224]));
%             pause;
            %imwrite(Ig,['/media/mengmi/TOSHIBA2/Proj_IT/Datasets/ErrorFixationMap_' type '/subj_' num2str(i) '_stimuli_' num2str(j) '_patch_' num2str(k) '.jpg']);
        
            %accumMap = accumMap + Ig;
            %imwrite(mat2gray(accumMap),['/media/mengmi/TOSHIBA2/Proj_IT/Datasets/DurationErrorFixationMap_' type '/subj_' num2str(i) '_stimuli_' num2str(j) '_patch_' num2str(k) '.jpg']);
        
            %stripMap (y,:) = 1;
            %G = fspecial('gaussian',[500 500],100);            
            %Ig = imfilter(stripMap,G,'same');
            %Ig = mat2gray(Ig);
%             imshow(Ig);
%             pause;
            %imwrite(Ig,['/media/mengmi/TOSHIBA2/Proj_IT/Datasets/FixationStripPrior_' type '/subj_' num2str(i) '_stimuli_' num2str(j) '_patch_' num2str(k) '.jpg']);
        
            %preverrorx = [preverrorx trialfixseqx(k)];
            %preverrory = [preverrory trialfixseqy(k)];
            
            Rsize = 224; %toggle betwene 224 and 28
            imgf = imresize(fixatedPlace,[Rsize Rsize]);
%             imshow(imgf);
%             pause;
            imgf = cat(3, imgf,imgf,imgf);
            if strcmp(type, 'naturaldesign')
                imwrite(imgf,['FixationPatchNaturalDesign_' num2str(Rsize) '/' subjlist{i} '_stimuli_' num2str(j) '_patch_' num2str(k) '.jpg']);
            else
                imwrite(imgf,['FixationPatchWaldo_' num2str(Rsize) '/' subjlist{i} '_stimuli_' num2str(j) '_patch_' num2str(k) '.jpg']);           
            end
            
%             for l = 1:1%length(locx)            
%                 subjstore = [subjstore i];
%                 stimulistore = [stimulistore j];
%                 patchstore = [patchstore k];
%                 preverror = [preverrorx; preverrory];
%                 PrevError = [PrevError preverror];
%                 %locxstore = [locxstore locx(l)];
%                 %locystore = [locystore locy(l)];
%             end
            display(['subj_' num2str(i) '_stimuli_' num2str(j) '_patch_' num2str(k) '.jpg']);
        end
        
    end
end
    
%save(['../Mat/FixationPatchStore_' type '.mat'],'subjstore','stimulistore','patchstore','PrevError');
%save(['../Mat/FixationPatchStore_' type '.mat'],'subjstore','stimulistore','patchstore','PrevError','locxstore','locystore');

display('done');


















