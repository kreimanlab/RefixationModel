clear all; close all; clc;

type = 'array'; %waldo, naturaldesign, array, naturalsaliency

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
   
    xtickrange = [1:5];
    
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
    MaxPlotFix = 15;
    xtickrange = [1 5:5:MaxPlotFix];
    
else
    HumanNumFix = 30;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
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

probrefix = [];

for imgID = 1:NumStimuli/2
    imgID
    

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
        
        %include center fixation as the first fixation
%         qq1 = overlappairst(:,1)+1;
%         qq2 = overlappairst(:,2)+1;
        
        %exclude center fixations as the first fixation
        
        if ~isempty(overlappairst)
            qq1 = overlappairst(:,1);
            qq2 = overlappairst(:,2);

            %remove those triple pairs (A,B) and (B,C); then we only take C
            qq2(ismember(qq2,qq1)) = [];  

            probrefix = [probrefix; qq2];
        end
        
        if ~isempty(overlappairsnt)
            qq1 = overlappairsnt(:,1);
            qq2 = overlappairsnt(:,2);

            %remove those triple pairs (A,B) and (B,C); then we only take C
            qq2(ismember(qq2,qq1)) = [];  

            probrefix = [probrefix; qq2];
        end
        
    end  
    
end

hb = figure; hold on; set(hb,'Position',[313   248   293   242]);
linewidth = 2;
set(gca,'linewidth',2);
binranges = xtickrange;
bincounts = histc(probrefix,binranges);
bincounts = bincounts/sum(bincounts);
  
plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');

load(['Mat/' type '_chanceoffsetnt.mat']);
bincounts = histc(probrefix,binranges);
bincounts = bincounts/sum(bincounts);
plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle',':');

xlim([1 MaxPlotFix]);
set(gca,'XTick',xtickrange,'FontSize',11);
set(gca,'YTick',[0:30:90],'FontSize',11);
ylim([0 1]*90);
xlabel('Fixation Number','FontSize',12);
ylabel('Distribution (%)','FontSize',12);
%title(type,'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/ProbRefixSeq_' type '_humans' printpostfix],printmode,printoption);



