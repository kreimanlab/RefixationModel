clear all; close all; clc;

%TYPELIST = {'waldo'};
TYPELIST = {'array','naturaldesign','waldo','naturalsaliency'};

for T = [1:3] %1:length(TYPELIST)

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
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 20;
    xtickrange = [1 10:10:MaxPlotFix];
elseif strcmp(type, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
        'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 10:10:MaxPlotFix];
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 20;
    xtickrange = [1 10:10:MaxPlotFix];
end
    
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);

if strcmp(type, 'naturalsaliency')
    centerR = ones(2, NumStimuli/2)*5000;    
else
    load(['Mat/GTRatioList_' type '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
end

[B,seqInd] = sort(seq);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;

linewidth  =2;
binranges = [1:1:MaxPlotFix+1];
Deg = 1; %[0.25 0.5 1 2 4]
IORthres = 43*Deg; %threshold as repeated fixations
IORthresT = 133/2; %threshold as within target

imgvalid = [1:NumStimuli/2];

for s = 1: length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    PosX = PosX(seqInd);
    PosY = PosY(seqInd);
    
    %all trials
    Firstx = PosX(1:NumStimuli/2);
    Firsty = PosY(1:NumStimuli/2);
    
    centerRx = centerR(1, imgvalid);
    centerRy = centerR(2, imgvalid);
    
%     [propnt1, offsetnt1, propt1, offsett1,countpropntD, countpropntN, countproptD, countproptN ] = fcn_MMevalInhibitionOfReturn(Firstx, Firsty, centerRx, centerRy, IORthres, IORthresT, subjlist{s}, imgvalid, 1, type);
%     save(['Mat/IOR_' type '_' subjlist{s} '.mat'],...
%             'propnt1', 'offsetnt1', 'propt1', 'offsett1','countpropntD', 'countpropntN', 'countproptD', 'countproptN');         
    
end
display('IOR computation done');

overallMeanS1 = []; overallStdS1 = [];
prop1t_mean = []; prop1nt_mean = [];  
offsettotalT = []; offsettotalNT = [];
for s = 1:length(subjlist)
    load(['Mat/IOR_' type '_' subjlist{s} '.mat']);
    offsett1(find(offsett1>MaxPlotFix)) = [];
    offsetnt1(find(offsetnt1>MaxPlotFix)) = [];
    
    offsettotalT = [offsettotalT offsett1];
    offsettotalNT = [offsettotalNT offsetnt1];
    
    [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
    prop1t_mean = [prop1t_mean (propt)];
    prop1nt_mean = [prop1nt_mean (propnt)];
end

%% plot 
if strcmp(type, 'naturalsaliency')
   overallMeanS1 = [nanmean(prop1nt_mean)] * 100;
   overallStdS1 = [nanstd(prop1nt_mean)/sqrt(length(prop1nt_mean))]*100;
   display([type '; mean=' num2str(overallMeanS1) '; std=' num2str(overallStdS1)]);
else
    overallMeanS1 = [nanmean(prop1t_mean) nanmean(prop1nt_mean)] * 100;
    overallStdS1 = [nanstd(prop1t_mean)/sqrt(length(prop1t_mean)) nanstd(prop1nt_mean)/sqrt(length(prop1nt_mean))]*100;
end

load(['Mat/' type '_chanceoffsetnt.mat']);
[propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
[h pnt ci stats] = ttest2(propnt,prop1nt_mean);
display([type '; pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);


if ~strcmp(type, 'naturalsaliency')
    [h pt] = ttest2(propt,prop1t_mean);
    [h pb] = ttest2(prop1nt_mean,prop1t_mean);
end

chanceval = nanmean(propnt); 
chancevalT = nanmean(propt);
%load(['Mat/saccade_' type  '.mat']);
%chanceval = length(find(SIMNONRETURN_Radius<=Deg))/length(SIMNONRETURN_Radius);
%% show IOR prop (overall)
if strcmp(type,'naturalsaliency')
    hb = figure('Position',[288   207   85   258]); hold on;
    
    if pnt <= 0.05
        text(1,40, '*', 'Fontsize', 12, 'Fontweight', 'bold');
    % elseif pvalue <= 0.01
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
    % elseif pvalue <= 0.001
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
    else
        text(1,40, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
    end


else
    if strcmp(type, 'array')
        hb = figure('Position',[303   294   125+20   186+20]); hold on;
    else
        hb = figure('Position',[303   294   125   186]); hold on;
    end
    
    if pt <= 0.05
        text(1,23, '*', 'Fontsize', 12, 'Fontweight', 'bold');
    % elseif pvalue <= 0.01
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
    % elseif pvalue <= 0.001
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
    else
        text(1,23, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
    end
    
    if pnt <= 0.05
        text(2,23, '*', 'Fontsize', 12, 'Fontweight', 'bold');
    % elseif pvalue <= 0.01
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
    % elseif pvalue <= 0.001
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
    else
        text(2,23, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
    end
    
    if pb <= 0.05
        text(1.5,25, '*', 'Fontsize', 12, 'Fontweight', 'bold');
        fcn_sigstar(1,2,25,0.03);
        %sigstar({[1,2]},[0.05]);
    % elseif pvalue <= 0.01
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
    % elseif pvalue <= 0.001
    %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
    else
        text(1.5,25, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
        fcn_sigstar(1,2,25,0.03);
        %sigstar({[1,2]},[0.05]);
    end
    
end
set(gca,'linewidth',2);

if strcmp(type, 'array')
    %plot([0:3],ones(size([0:3]))* 1/6*100,'k:','LineWidth',2.5);
    plot([1.5:0.5:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
    plot([0:0.5:1.5],ones(size([0:3]))* chancevalT*100,'w:','LineWidth',2);
elseif strcmp(type, 'naturalsaliency')
    %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(1024*1280)*100,'k:','LineWidth',2.5);
    plot([0:0.5:1.5],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
    %plot([0:0.5:1.5],ones(size([0:3]))* chancevalT*100,'k:','LineWidth',2.5);
else
    plot([1.5:0.5:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
    plot([0:0.5:1.5],ones(size([0:3]))* chancevalT*100,'w:','LineWidth',2);
end

if strcmp(type, 'naturalsaliency')
    bar([1],overallMeanS1,'FaceColor',[0 0 0 ],'LineWidth',1.5);
    errorbar([1], overallMeanS1, overallStdS1,'k.');    
else
    bar([1 2],overallMeanS1,'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
    errorbar([1 2], overallMeanS1, overallStdS1,'k.');
end
if strcmp(type, 'array')
    %plot([0:3],ones(size([0:3]))* 1/6*100,'k:','LineWidth',2.5);
    plot([1.5:0.5:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
    plot([0:0.5:1.5],ones(size([0:3]))* chancevalT*100,'w:','LineWidth',2);
elseif strcmp(type, 'naturalsaliency')
    %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(1024*1280)*100,'k:','LineWidth',2.5);
    plot([0:0.5:1.5],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
    %plot([0:0.5:1.5],ones(size([0:3]))* chancevalT*100,'k:','LineWidth',2.5);
else
    plot([1.5:0.5:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
    plot([0:0.5:1.5],ones(size([0:3]))* chancevalT*100,'w:','LineWidth',2);
end
set(gca,'YTick',[0:0.1:0.4]*100,'FontSize',11);

if strcmp(type, 'naturalsaliency')
    set(gca,'XTick',[1],'FontSize',12);
    xlim([0.5 1.5]);
    set(gca,'XTickLabel',{''},'FontSize',12);
    titlename = [type ';pnt=' num2str(pnt)];
    %title(titlename,'FontSize',14);
    ylim([0 40]);
else
    set(gca,'XTick',[1 2],'FontSize',12);
    xlim([0.5 2.5]);
    set(gca,'XTickLabelRotation',45);
    set(gca,'XTickLabel',{'Target','Non-Target'},'FontSize',12);
    titlename = [type ';pt=' num2str(pt) '; pnt=' num2str(pnt) '; pb=' num2str(pb)];
    %title(titlename,'FontSize',14);  
    ylim([0 25]);
end


set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
%xlabel('Inter Trial Interval','FontSize',14');
if strcmp(type, 'array')
    ylabel('Proportion (%)','FontSize',12);
else
    set(gca,'YTickLabel',{},'FontSize',12);
end

%legend({'Chance (target)', 'Chance (non-target)'},'FontSize',14);legend boxoff;
%legend({'Chance'},'FontSize',14);legend boxoff;

set(hb,'Units','Inches');
pos = get(hb,'Position');
%set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[8.5 11]);
print(hb,['Figures/IOR_first_overall_' type '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);

%% show IOR offset (overall)
hb = figure; hold on;
set(gca,'linewidth',2); 
if strcmp(type,'array')
    set(hb,'Position',[308   368   127+35   117+40]);
else
    set(hb,'Position',[308   368   127   117]);
end
if isempty(offsettotalT)
    bincounts = zeros(size(binranges));
else
    bincounts = histc(offsettotalT,binranges);
    bincounts = bincounts/sum(bincounts);
    binc = bincounts*100;
    display([type '-T; 1st: ' num2str(binc(2)) ';first 3: ' num2str(sum(binc(2:4)))]);
end    
%plot(binranges, bincounts,'Color',ColorList(3,:),'LineWidth',linewidth);
if ~strcmp(type, 'naturalsaliency')
    [h po] = ttest2(offsettotalT, offsettotalNT);
    plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth);
end
if isempty(offsettotalNT)
    bincounts = zeros(size(binranges));
else
    bincounts = histc(offsettotalNT,binranges);
    bincounts = bincounts/sum(bincounts);
end    
%plot(binranges, bincounts,'Color',ColorList(3,:),'LineWidth',linewidth);
plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');
binc = bincounts*100;
display([type '-NT; 1st: ' num2str(binc(2)) ';first 3: ' num2str(sum(binc(2:4)))]);

if ~strcmp(type,'array')
    load(['Mat/' type '_chanceoffsetnt.mat']);
    bincounts = histc(chanceoffsetnt,binranges);
    bincounts = bincounts/sum(bincounts);
    %plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle',':');
else
    %plot(binranges-1,ones(size(binranges-1))* 1/MaxPlotFix*100,'k:','LineWidth',linewidth);
end
if ~strcmp(type, 'naturalsaliency')
    %legend({'Target','Non-target','Chance'},'Location','northeast','FontSize',14);
    %title([type '; po=' num2str(po)],'FontSize', 14);
else
    %legend({'Non-target','Chance'},'Location','northeast','FontSize',14);
    %title([type],'FontSize', 14);
end
%legend boxoff ;
xlim([1 MaxPlotFix]);

set(gca,'XTick',xtickrange,'FontSize',11);
ylim([0 1]*90);
set(gca,'YTick',[0:30:90],'FontSize',11);
if strcmp(type,'array')
    %set(gca,'YTickLabel',{},'FontSize',12);
    xlabel({'Returning Offset';'(Fixations)'},'FontSize',10);
    ylabel('Distribution (%)','FontSize',10);
else
    set(gca,'YTickLabel',{},'FontSize',12);
end


set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
%set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[8.5 11]);
print(hb,['Figures/IORoffsetFirstOnly_' type '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);

end
