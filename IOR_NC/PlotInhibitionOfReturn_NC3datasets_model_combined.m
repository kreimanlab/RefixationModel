clear all; close all; clc;


TYPELIST = {'array_conv_only','naturaldesign_conv_only','waldo_conv_only'};

for T = 1:length(TYPELIST)

type = TYPELIST{T}; 

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
   
elseif strcmp(subtype, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {type}; %natural design
    MaxPlotFix = 20;
    xtickrange = [1 5:5:MaxPlotFix];
elseif strcmp(subtype, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {type}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {type}; %natural design
    MaxPlotFix = 20;
    xtickrange = [1 10:10:MaxPlotFix];
end
    
if strcmp(subtype, 'naturalsaliency')
    centerR = ones(2, NumStimuli/2)*5000;    
else
    %load(['Mat/GTRatioList_' subtype '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
    centerR = ones(2, NumStimuli/2)*5000;
end


printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
Imgw = 1024;
Imgh = 1280;

linewidth  =2;
binranges = [1:1:MaxPlotFix+1];

%fair to model; subsampled from 38 x 50 grids wrt 1024 x 1280 grids
%margin 1280/50 = 25.6 gap min
Deg = 1; %[0.25 0.5 1 2 4]
IORthres = 43*Deg; %threshold as repeated fixations
IORthresT = 133/2; %threshold as within target

for s = 1: length(subjlist)
    load(['Mat/' type '_Fix.mat']);
    
    imgvalid = [1:NumStimuli/2];
%     imgvalid = find(sum(scoremat,2)>0);
    
    %load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    PosX = Fix_posx;
    PosY = Fix_posy;    
    
    %all trials
    Firstx = PosX(imgvalid);
    Firsty = PosY(imgvalid);
    
    centerRx = centerR(1, imgvalid);
    centerRy = centerR(2, imgvalid);
    
%     [propnt1, offsetnt1, propt1, offsett1, countpropntD, countpropntN, countproptD, countproptN ] = fcn_MMevalInhibitionOfReturn(Firstx, Firsty, centerRx, centerRy, IORthres, IORthresT, subjlist{s}, imgvalid, 1, [type '_comb']);
%     save(['Mat/IOR_' type '_' subjlist{s} '_comb.mat'],...
%             'propnt1', 'offsetnt1', 'propt1', 'offsett1','countpropntD', 'countpropntN', 'countproptD', 'countproptN');         
%     propnt1
%     propt1
end
% display('IOR computation done');
% [h p] = ttest2(propnt1, propt1);

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

overallMeanS1 = [nanmean(prop1nt_mean)] * 100;
overallStdS1 = [nanstd(prop1nt_mean)/sqrt(length(prop1nt_mean))]*100;
display([type '; mean=' num2str(overallMeanS1) '; std=' num2str(overallStdS1)]);

load(['Mat/' subtype '_chanceoffsetnt.mat']);
[propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
[h pnt ci stats] = ttest2(propnt,prop1nt_mean);
display([type '; pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);

chanceval = nanmean(propnt); 
chancevalT = nanmean(propt);
%load(['Mat/saccade_' type  '.mat']);
%chanceval = length(find(SIMNONRETURN_Radius<=Deg))/length(SIMNONRETURN_Radius);

%% show IOR prop (overall)
if strcmp(type, 'array')
    hb = figure('Position',[288   207   100   258]); hold on;
else
    hb = figure('Position',[288   207   85   258]); hold on;
end

if pnt <= 0.05
    text(1,40, '*', 'Fontsize', 12, 'Fontweight', 'bold');
% elseif pvalue <= 0.01
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
% elseif pvalue <= 0.001
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
else
    text(1,40, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
end


plot([0:0.5:1.5],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2.5);
bar([1],overallMeanS1,'FaceColor',[ 0 0 0],'LineWidth',1.5);
errorbar([1], overallMeanS1, overallStdS1,'k.');    
plot([0:0.5:1.5],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2.5);

set(gca,'YTick',[0:0.1:0.4]*100,'FontSize',11);
set(gca,'YTickLabel',{},'FontSize',12);
set(gca,'XTick',[1],'FontSize',12);
xlim([0.5 1.5]);
set(gca,'XTickLabel',{''},'FontSize',12);
titlename = [type ';pnt=' num2str(pnt)];
    %title(titlename,'FontSize',14);
 

ylim([0 40]);
set(gca,'linewidth',2);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
%xlabel('Inter Trial Interval','FontSize',14');
if strcmp(type, 'array')
    ylabel('Proportion (%)','FontSize',12);
end
%legend({'Chance (target)', 'Chance (non-target)'},'FontSize',14);legend boxoff;
%legend({'Chance'},'FontSize',14);legend boxoff;
%set(hb,'Position',[288   207   120   258]);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/IOR_first_overall_comb_' type '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);

% %% show IOR offset (overall)
% hb = figure; hold on;set(hb,'Position',[313   248   293   242]);
% set(gca,'linewidth',2);
% if isempty(offsettotalT)
%     bincounts = zeros(size(binranges));
% else
%     bincounts = histc(offsettotalT,binranges);
%     bincounts = bincounts/sum(bincounts);
% end  
% 
% if ~strcmp(subtype, 'naturalsaliency')
%     [h po] = ttest2(offsettotalT, offsettotalNT);    
%     plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth);
% end
% 
% if isempty(offsettotalNT)
%     bincounts = zeros(size(binranges));
% else
%     bincounts = histc(offsettotalNT,binranges);
%     bincounts = bincounts/sum(bincounts);
% end    
% %plot(binranges, bincounts,'Color',ColorList(3,:),'LineWidth',linewidth);
% plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');
% 
% if ~strcmp(subtype,'array')
%     load(['Mat/' subtype '_chanceoffsetnt.mat']);
%     bincounts = histc(chanceoffsetnt,binranges);
%     bincounts = bincounts/sum(bincounts);
%     %plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle',':');
% else
%     %plot(binranges-1,ones(size(binranges-1))* 1/MaxPlotFix*100,'k:','LineWidth',linewidth);
% end
% if ~strcmp(subtype, 'naturalsaliency')
%     %title([type '; po=' num2str(po)],'FontSize', 14);
%     %legend({'Target','Non-target'},'Location','northeast','FontSize',12);
% else
%     %title([type],'FontSize', 14);
%     %legend({''},'Location','northeast','FontSize',12);
% end
% %legend boxoff ;
% xlim([1 MaxPlotFix]);
% set(gca,'XTick',xtickrange);
% ylim([0 1]*90);
% set(gca,'YTick',[0:30:90],'FontSize',11);
% xlabel('Returning Offset (Fixations)','FontSize',12);
% ylabel('Distribution (%)','FontSize',12);
% 
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['Figures/IORoffsetFirstOnly_' type '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);

end

