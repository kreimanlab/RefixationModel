clear all; close all; clc;

type = 'naturalsaliency';
modelnamelist = {'classi','ablated_entro_sal','ablated_entro','ablated_sal'};
%'scanpathpred_infor',
%'scanpathpred','classi','ablated_entro','ablated_entro_sal','ablated_sal'
meansubj = [];
stdsubj = [];

hb = figure; hold on;
for m = 1:length(modelnamelist)
    load(['Mat/ScanScore_' type '_' modelnamelist{m} '.mat']);
    plot([1:size(SStotalTime,2)], nanmean(SStotalTime,1));
    
    meansubj = [meansubj nanmean(SStotal) ];
    stdsubj = [stdsubj nanstd(SStotal)/sqrt(length(SStotal))];
end
legend(modelnamelist);
xlabel('fix num');
ylabel('scanpath score');

hb = figure; hold on;
bar([1:length(meansubj)],meansubj);
errorbar([1:length(meansubj)], meansubj, stdsubj,'k.');
xticks([1:length(meansubj)]);
xticklabels(modelnamelist);
ylabel('scanpath score');