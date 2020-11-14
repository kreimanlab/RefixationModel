clear all; clc; close all;

TYPELIST = {'array','naturaldesign','waldo','naturalsaliency'};

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


[B,seqInd] = sort(seq);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;

linewidth  =2;

%% comment out 
SIMRETURN = []; SIMNONRETURN = [];  SIMRETURN2 = [];
SIMRETURN_subj = []; SIMNONRETURN_subj = [];  SIMRETURN2_subj = [];

for s = 1: length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    Time = FixData.Fix_time;
    
    if ~strcmp(type, 'array')
        startTime = FixData.Fix_starttime;
    end
    
    PosX = PosX(seqInd);
    PosY = PosY(seqInd);
    Time = Time(seqInd);
    if ~strcmp(type, 'array')
        startTime =startTime(seqInd);
    end
    
    %all trials
    Firstx = PosX(1:NumStimuli/2);
    Firsty = PosY(1:NumStimuli/2);
    FirstTime = Time(1:NumStimuli/2);
    
    if ~strcmp(type, 'array')
        startTime = startTime(1:NumStimuli/2);
    end
    
    for i = 1:NumStimuli/2
        
       display(['processing ... subj: ' num2str(s) '; img: ' num2str(i) ]);
       fx = double(Firstx{i});
       fy = double(Firsty{i});
       ft = double(FirstTime{i});
       
       if ~strcmp(type, 'array')
           sft = double(startTime{i});

           %fixduration calculation
           fixdur = ft - sft;
           ft = cumsum(fixdur);
       end
       
       % remove those trials with only one fixation
        if length(fx)== 1
            continue;            
        end
        
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
        if ~isempty(overlappairsnt)
            if length(fx) ~= overlappairsnt(1,3) && ~strcmp(type, 'array')          
                overlappairsnt = overlappairsnt +1;
                %overlappairst = overlappairst +1;
            end
            overlappairsnt = overlappairsnt(:,2);
            %overlappairsnt = overlappairsnt + 1;
            overlappairsnt = overlappairsnt(:);
        end
        if ~isempty(overlappairst)
            if length(fx) ~= overlappairst(1,3) && ~strcmp(type, 'array')          
                %overlapnt = overlapnt +1;
                overlappairst = overlappairst +1;
            end
            overlappairst = overlappairst(:,2);
            %overlappairst = overlappairst + 1;
            overlappairst = overlappairst(:);
        end
        
        overlap = [overlappairst; overlappairsnt];
        overlap = unique(overlap);
        
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
        if ~isempty(overlappairsnt)
            if length(fx) ~= overlappairsnt(1,3) && ~strcmp(type, 'array')            
                overlappairsnt = overlappairsnt +1;
                %overlappairst = overlappairst +1;
            end
            overlappairsnt = overlappairsnt(:,1);
            %overlappairsnt = overlappairsnt + 1;
            overlappairsnt = overlappairsnt(:);
        end
        if ~isempty(overlappairst)
            if length(fx) ~= overlappairst(1,3) && ~strcmp(type, 'array')          
                %overlapnt = overlapnt +1;
                overlappairst = overlappairst +1;
            end
            overlappairst = overlappairst(:,1);
            %overlappairst = overlappairst + 1;
            overlappairst = overlappairst(:);
        end

        overlap2 = [overlappairst; overlappairsnt];
        overlap2 = unique(overlap2);
        
        sim = [];
        ftdiff = diff(ft);
        ftdiff = [ft(1) ftdiff];
        sim = ftdiff;
        
        if ~isempty(sim)
            SIMRETURN = [SIMRETURN sim(overlap)];
            SIMRETURN_subj = [SIMRETURN_subj s*ones(1, length(sim(overlap)) ) ];
            SIMRETURN2 = [SIMRETURN2 sim(overlap2)];
            SIMRETURN2_subj = [SIMRETURN2_subj s*ones(1, length(sim(overlap2)) ) ];
            sim(unique([overlap; overlap2])) = [];
            SIMNONRETURN = [SIMNONRETURN sim];
            SIMNONRETURN_subj = [SIMNONRETURN_subj s*ones(1, length(sim) ) ];
        end
        
    end
    
end
save(['Mat/ReturnFixDuration_' type  '.mat'],'SIMRETURN', 'SIMRETURN2','SIMNONRETURN',...
    'SIMRETURN_subj','SIMRETURN2_subj','SIMNONRETURN_subj');
%

% all = [];
% typelist = {'array','naturaldesign','waldo'} ;
% for T= 1:length(typelist)    
%     load(['Mat/ReturnFixDuration_' typelist{T}  '.mat']);
%     all = [all SIMRETURN];
%     all = [all SIMNONRETURN];
%     all = [all SIMRETURN2];
% end

% 
% hb = figure; hold on;
% load(['Mat/ReturnFixDuration_' type  '.mat']);
% MAX = max([max(SIMRETURN) max(SIMNONRETURN)]);
% BINNUM = 100;
% binranges = [0:MAX/BINNUM:MAX];
% bincounts = histc(SIMRETURN,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);
% 
% bincounts = histc(SIMRETURN2,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth,'LineStyle','--');
% 
% bincounts = histc(SIMNONRETURN,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','r','LineWidth',linewidth);
% 
% legend({'To-Re-Visit','Return','Non-return','Chance'},'Location','northeast','FontSize',14);
% legend boxoff ;
% xlim([0 500]);
% %set(gca,'XTick',xtickrange);
% %ylim([0 1]*80);
% xlabel(['Fix Duration (ms)'],'FontSize',14);
% ylabel('Distribution (%)','FontSize',14);
% %title([type '; m(R1)=' num2str(mean(SIMRETURN)) '; m(R2)=' num2str(mean(SIMRETURN2)) '; m(NR)=' num2str(mean(SIMNONRETURN))],'FontSize', 14);
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['Figures/ReturnFixDuration_' type printpostfix],printmode,printoption);

%% bar plot and report stats
hb = figure; hold on;
set(gca,'linewidth',2);

load(['Mat/ReturnFixDuration_' type  '.mat']);
bar([1],nanmean(SIMRETURN),'FaceColor',[0.8020    0.8020    0.8020],'LineStyle','--','LineWidth',1.5);
errorbar([1], nanmean(SIMRETURN), nanstd(SIMRETURN)/sqrt(length(SIMRETURN)),'k.');
bar([2],nanmean(SIMRETURN2),'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
errorbar([2], nanmean(SIMRETURN2), nanstd(SIMRETURN2)/sqrt(length(SIMRETURN2)),'k.');
bar([3],nanmean(SIMNONRETURN),'FaceColor',[0.8020    0.8020    0.8020],'LineWidth',1.5);
errorbar([3], nanmean(SIMNONRETURN), nanstd(SIMNONRETURN)/sqrt(length(SIMNONRETURN)),'k.');
set(gca,'XTick',[1 2 3],'FontSize',11);
xlim([0.5 3.5]);

if strcmp(type, 'array')
    ylabel({'Fixation';'Duration (ms)'},'FontSize',10);
    set(gca,'XTickLabel',{'To-be-revisited','Return','Non-Return'},'FontSize',10);
    set(gca,'XTickLabelRotation',45);
else
    set(gca,'XTickLabel',{},'FontSize',12);
    set(gca,'YTickLabel',{},'FontSize',12);
end
set(gca,'YTick',[0:100:450],'FontSize',11);
ylim([0 450]);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
%xlabel('Inter Trial Interval','FontSize',14');

%legend({'Chance'},'FontSize',14);legend boxoff ;
[a p1] = ttest2(SIMRETURN, SIMNONRETURN);
[a p2] = ttest2(SIMRETURN2, SIMNONRETURN);
[a p3] = ttest2(SIMRETURN2, SIMRETURN);

if p3 <= 0.05
    text(1.25,395, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([1 1.7],[425 425],'k','LineWidth',2.5);
    fcn_sigstar(1,1.7,380,0.03);
else
%     text(1.2,430, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
%     plot([1 1.7],[420 420],'k','LineWidth',2.5);
end

if p2 <= 0.05
    text(2.6,395, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([2.3 3],[425 425],'k','LineWidth',2.5);
    fcn_sigstar(2.3,3,380,0.03);
else
%     text(2.5,430, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
%     plot([2.3 3],[420 420],'k','LineWidth',2.5);
end

if p1 <= 0.05
    text(2,450, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([1 3],[445 445],'k','LineWidth',2.5);
    fcn_sigstar(1,3,435,0.03);
else
%     text(1.8,455, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
%     plot([1 3],[445 445],'k','LineWidth',2.5);
end

titlename = [type ': stats p(1,2)=' num2str(p3) '; stats p(1,3)=' num2str(p1) '; stats p(2,3)=' num2str(p2)];
%title(titlename,'FontSize',14);
if strcmp(type, 'array')
    set(hb,'Position',[303   268   177   212]);
else
    set(hb,'Position',[303   363   122   117]);
end
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/ReturnFixationDurationBarPlot_' type printpostfix],printmode,printoption);

end
