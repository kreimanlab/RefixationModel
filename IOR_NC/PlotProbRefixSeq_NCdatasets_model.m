clear all; close all; clc;


type = 'naturalsaliency_conv_only'; %naturalsaliency_scanpathpred, naturalsaliency_scanpathpred_infor
%naturalsaliency_classi, naturaldesign_classi, waldo_classi

subtype = strsplit(type,'_');
subtype = subtype{1};
%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(subtype, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {type}; %array
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
    
elseif strcmp(subtype, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {type}; %array
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    
elseif strcmp(subtype, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {type}; %array
    MaxPlotFix = 15;
    xtickrange = [1 5:5:MaxPlotFix];
    
else
    HumanNumFix = 30;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {type}; %array
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
end

if strcmp(subtype, 'naturalsaliency')
    centerR = ones(2, NumStimuli/2)*5000;    
else
    load(['Mat/GTRatioList_' subtype '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
end

Imgw = 1024;
Imgh = 1280;
binaryw = [];binaryh = [];

marksizedva = 31/2; %degree of visual angles to pixels

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

probrefix = [];

for SubjID = 1:length(subjlist)
    for imgID = 1:NumStimuli/2

%display(['subjid: ' num2str(SubjID) '; imgID: ' num2str(imgID) ]);

        %% pre-filter whether it satisfies 
        ImgSelected = imgID;
        subjectid = subjlist{SubjID};

        load(['Mat_IOR_' type '/' subjectid '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

        if strcmp(subtype, 'naturalsaliency')
            if isempty(overlappairsnt)
                continue;
            end
        else
            if isempty(overlappairst) && isempty(overlappairsnt)
                continue;
            end
        end

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

load(['Mat/' subtype '_chanceoffsetnt.mat']);
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
print(hb,['Figures/ProbRefixSeq_' subtype '_models' printpostfix],printmode,printoption);
