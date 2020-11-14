clear all; close all; clc;

TYPELIST = {'naturaldesign','waldo'};
IORthresT = 133/2; %threshold as within target

for T = 1:length(TYPELIST)

    type = TYPELIST{T}; 

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
       %SimilarityName = 'Mat_FixationPatchArray_224';

    elseif strcmp(type, 'naturaldesign')
        HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
        NumStimuli = 480;
        subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
            'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
            'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
        MaxPlotFix = 30;
        xtickrange = [1 5:5:MaxPlotFix];
        %SimilarityName = 'Mat_FixationPatchNaturalDesign_224';

    elseif strcmp(type, 'naturalsaliency')
        HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
        NumStimuli = 480;
        subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
        'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'}; %natural design
        MaxPlotFix = 30;
        xtickrange = [1 5:5:MaxPlotFix];
        %SimilarityName = 'Mat_FixationPatchNaturalDesign_224';

    else
        HumanNumFix = 80;
        NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
        subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
            'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
            'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
        MaxPlotFix = 80;
        xtickrange = [1 10:10:MaxPlotFix];
        %SimilarityName = 'Mat_FixationPatchWaldo_224';

    end

    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);

    load(['Mat/GTRatioList_' type '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
    centerR = [centerR centerR];
    
    [B,seqInd] = sort(seq);
    printpostfix = '.eps';
    printmode = '-depsc'; %-depsc
    printoption = '-r200'; %'-fillpage'
    Imgw = 1024;
    Imgh = 1280;

    linewidth  =2;

    percentageClick = 0;
    totalRefix = 0;

    for s = 1: length(subjlist)
        
        load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
        PosX = FixData.Fix_posx;
        PosY = FixData.Fix_posy;
        TargetFound = FixData.TargetFound;

        PosX = PosX(seqInd);
        PosY = PosY(seqInd);        
        TargetFound = TargetFound(seqInd,:);
        [foundelement,foundflag]=max(TargetFound,[],2);
        foundflag(find(foundelement == 0)) = nan;
        
        %all trials
        Firstx = PosX(1:NumStimuli/2);
        Firsty = PosY(1:NumStimuli/2);    

        for i = 1:NumStimuli/2

           %display(['processing ... subj: ' num2str(s) '; img: ' num2str(i) ]);
           fx = double(Firstx{i});
           fy = double(Firsty{i});
           
           % remove those trials with only one fixation
            if length(fx)== 1
                continue;            
            end

            load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
            if ~isempty(overlappairsnt)
                if length(fx) ~= overlappairsnt(1,3) && ~strcmp(type, 'array')          
                    overlappairsnt = overlappairsnt +1;                    
                end
                overlappairsnt = overlappairsnt(:,1);                
                overlappairsnt = overlappairsnt(:);
            end
            if ~isempty(overlappairst)
                if length(fx) ~= overlappairst(1,3) && ~strcmp(type, 'array')       
                    overlappairst = overlappairst +1;
                end
                overlappairst = overlappairst(:,1);
                overlappairst = overlappairst(:);
            end

            overlap = [overlappairst; overlappairsnt];
            overlap = unique(overlap);
            
            ind = find(seq == i);
            prevtrialid = ind-1;
            
            while prevtrialid >= 1 && isnan(foundflag( seq(prevtrialid) )) 
                prevtrialid = prevtrialid -1;                         
            end
            
            if prevtrialid < 1
                continue;
            end 
            
            centerRx = centerR(1,seq(prevtrialid));
            centerRy = centerR(2,seq(prevtrialid));       
                
            refixx = fx(overlap);
            refixy = fy(overlap);
            
            distc = sqrt( (refixx - centerRx).^2 + (refixy - centerRy).^2 );
            all = length(find(distc <= IORthresT));
            
            percentageClick = percentageClick + all;
            totalRefix = totalRefix + length(refixx);
        end

    end

    display(['dataset: ' type '; percentageclick: ' num2str(percentageClick/totalRefix)]);
    
end









