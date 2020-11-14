clear all; close all; clc;

typedataset = 'naturaldesign'; %array, naturaldesign
load(['mturk/Mat/mturk_' typedataset '.mat']);

NumTrials = 100; 
NumType = 4;
subjperfm = nan(NumType, length(mturkData));

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

for s = 1:length(mturkData)
    
    subj = mturkData(s);
    if length(subj.answer) < NumTrials
        continue;
    end
    
    typelist = extractfield(subj.answer,'type');
    responselist = extractfield(subj.answer,'response');
    gtlabellist = extractfield(subj.answer,'gtlabel');
    
    for t = 1:NumType
        TR = responselist(find(typelist == t));
        GT = gtlabellist(find(typelist == t));
        
        subjperfm(t,s) = mean(TR == GT);
    end
end

% prefiltering criteria
% for s = 1:length(mturkData)
% %     subjperfm(2,s)
% %     subjperfm(3,s)
%     if subjperfm(2,s) ~= 1 || subjperfm(3,s) ~= 1
%         subjperfm(:,s) = nan;
%     end
% end

hb = figure; hold on;
set(gca,'linewidth',2);
NumType = 3; %only plot the first three conditions

t=1;
m = subjperfm(t,:);
bar(t,nanmean(m)*100,'FaceColor',[1 1 1],'LineWidth',1.5,'LineStyle','-');
errorbar(t, nanmean(m)*100, nanstd(m)/sqrt(length(m))*100,'k.');

display(['mean = ' num2str(nanmean(m)) '; std=' num2str(nanstd(m)/sqrt(length(m))*100) ]);


t=2;
m = subjperfm(t,:);
bar(t,nanmean(m)*100,'FaceColor',[1 1 1],'LineWidth',1.5,'LineStyle','--');
errorbar(t, nanmean(m)*100, nanstd(m)/sqrt(length(m))*100,'k.');

t=3;
m = subjperfm(t,:);
bar(t,nanmean(m)*100,'FaceColor',[1 1 1],'LineWidth',1.5,'LineStyle',':');
errorbar(t, nanmean(m)*100, nanstd(m)/sqrt(length(m))*100,'k.');

hold on;
plot([0:NumType+1],50*ones(1,length([0:NumType+1])),'k:','LineWidth',2.5);
set(gca,'XTick',[1:NumType],'FontSize',11);
xlim([0.5 NumType+0.5]);
%set(gca,'XTickLabel',{'R-NR','ST-NR','DT-NR','Rand-NR'},'FontSize',12);
set(gca,'XTickLabel',{'Test','Control 1','Control 2'},'FontSize',12);
set(gca,'XTickLabelRotation',45)
ylim([0 100]);
set(gca,'YTick',[0:20:100],'FontSize',11);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
%xlabel('Inter Trial Interval','FontSize',14');
ylabel('Accuracy (%)','FontSize',12);

[h,p, ci, stats] = ttest(subjperfm(1,:)-0.5);
display([typedataset '; p=' num2str(p) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);

if p <= 0.05
    text(1,103, '*', 'Fontsize', 11, 'Fontweight', 'bold');
else
    text(1,103, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
end

[h,p] = ttest(subjperfm(2,:)-0.5);
if p <= 0.05
    text(2,103, '*', 'Fontsize', 11, 'Fontweight', 'bold');
else
    text(2,103, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
end

[h,p] = ttest(subjperfm(3,:)-0.5);
if p <= 0.05
    text(3,103, '*', 'Fontsize', 11, 'Fontweight', 'bold');
else
    text(3,103, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
end

%title([ typedataset '; mean = ' num2str(nanmean(subjperfm(1,:))) '; p = ' num2str(p)]);
set(hb,'Position',[293   212   158+45   358]);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/MturkSimilarityPlot_' typedataset printpostfix],printmode,printoption);






