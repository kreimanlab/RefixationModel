clear all; close all; clc;

type = 'naturalsaliency'; %waldo, naturaldesign, array, naturalsaliency

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
   MaxPlotFix = 6; 
   xtickrange = [1:MaxPlotFix];
   
   
    %remap to real display in klab
    fix1 = [490 772];
    fix2 = [340 512];
    fix3 = [490 252];
    fix4 = [790 252];
    fix5 = [940 512];
    fix6 = [790 772];
    fixC = [fix1; fix2; fix3; fix4; fix5; fix6];

    %scanpath processed coordinates
    fix1 = [365 988 0 ];
    fix2 = [90 512 0];
    fix3 = [365 36 0];
    fix4 = [915 36 0];
    fix5 = [1190 512 0];
    fix6 = [915 988 0];
    fixO = [fix1; fix2; fix3; fix4; fix5; fix6];
   
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
    subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
        'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'}; %natural design
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

marksizedva = 31/2; %degree of visual angles to pixels
Gsize = 130; Gvar = 25; %gaussian filter specs

if strcmp(type, 'naturalsaliency')
    centerR = ones(2, NumStimuli/2)*5000;    
else
    load(['Mat/GTRatioList_' type '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
end

[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

%hb = figure;
radiuscircle = 10; %
sidesquare = 35;

RefixMaps = [];

for imgID = 1:NumStimuli/2
    imgID
    
    %binarymask = zeros(Imgw, Imgh);
    %binarymaskT = zeros(Imgw, Imgh);
    %binarymaskNT = zeros(Imgw, Imgh);
    binaryw = [];binaryh = [];
    binarywNT = []; binaryhNT=[];
    binarywT = []; binaryhT=[];
    
    subjects = [];
    
    trialid = imgID;

    for SubjID = 1:length(subjlist)

        %% pre-filter whether it satisfies 
        ImgSelected = imgID;
        subjectid = subjlist{SubjID};

        load(['Mat_IOR_' type '/' subjectid '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

        if strcmp(type, 'naturalsaliency')
            if isempty(overlappairsnt)
                continue;
            end
        else
            if isempty(overlappairst) && isempty(overlappairsnt)
                continue;
            end
        end

        subjects = [subjects SubjID];
        
        filename = ['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type '/' subjectid '.mat'];
        load(filename);
        PosX = FixData.Fix_posx;
        PosY = FixData.Fix_posy;
        PosX = PosX(seqInd);
        PosY = PosY(seqInd);

        posx = PosX{ImgSelected};
        posy = PosY{ImgSelected};
        NumFix1 = length(posx);
        posx = posx(1:end); %do not remove first fixation at center
        posy = posy(1:end); %always start the first fixation in the center

        % if length(posx) > 10 %prefer examples with <= 10 fixations
        %     continue;
        % end

        if strcmp(type, 'array')
            posxcopy = posx;
            posycopy = posy;

            for ctype = 1:size(fixC,1)
                posx(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,1);
                posy(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,2);
            end
        end



        if ~isempty(overlappairst)
          for zz = 1:size(overlappairst,1)
            if length(posx) == overlappairst(zz,3)
                qq1 = overlappairst(zz,1);
                qq2 = overlappairst(zz,2);
            else
                qq1 = overlappairst(zz,1)+1;
                qq2 = overlappairst(zz,2)+1;
            end

            if int32(posx(qq1)) > 0 && int32(posx(qq1))<=Imgh && int32(posy(qq1)) > 0 && int32(posy(qq1))<=Imgw 
%                 binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%                 binarymaskT(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
                binaryw = [binaryw int32(posy(qq1))];
                binaryh = [binaryh int32(posx(qq1))];
                binarywT = [binarywT int32(posy(qq1))];
                binaryhT = [binaryhT int32(posx(qq1))];
            end
            if int32(posx(qq2)) > 0 && int32(posx(qq2))<=Imgh && int32(posy(qq2)) > 0 && int32(posy(qq2))<=Imgw
                %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
                %binarymaskT(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
            end
          end
        end

        overlappairst = overlappairsnt;
        if ~isempty(overlappairst)
          for zz = 1:size(overlappairst,1)
            if length(posx) == overlappairst(zz,3)
                qq1 = overlappairst(zz,1);
                qq2 = overlappairst(zz,2);
            else
                qq1 = overlappairst(zz,1)+1;
                qq2 = overlappairst(zz,2)+1;
            end

            if int32(posx(qq1)) > 0 && int32(posx(qq1))<=Imgh && int32(posy(qq1)) > 0 && int32(posy(qq1))<=Imgw 
%                 binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%                 binarymaskNT(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
                binaryw = [binaryw int32(posy(qq1))];
                binaryh = [binaryh int32(posx(qq1))];
                binarywNT = [binarywNT int32(posy(qq1))];
                binaryhNT = [binaryhNT int32(posx(qq1))];
            end
            if int32(posx(qq2)) > 0 && int32(posx(qq2))<=Imgh && int32(posy(qq2)) > 0 && int32(posy(qq2))<=Imgw
                %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
                %binarymaskNT(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
            end
          end
        end
    end
    
    if length(subjects) >= 2
        trial.subjects = subjects;
        trial.imgID = trialid;
        trial.binaryw = binaryw; trial.binaryh = binaryh;
        trial.binarywT = binarywT; trial.binaryhT = binaryhT;
        trial.binarywNT = binarywNT; trial.binaryhNT = binaryhNT;

        RefixMaps = [RefixMaps trial];
    end
    
end

save(['Mat/refixmap_consistency_' type '.mat'],'RefixMaps','-v7.3');
