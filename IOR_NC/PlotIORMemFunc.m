clear all; close all; clc;

type = 'naturaldesign';
analysis = 'similarity'; %'similarity','recog'
baselist = [0.92];
NumFS = 40; %total number of fixation steps

red = [1, 0, 0];
pink = [0 0 0];
lengthC = length(baselist);
colors_p = [linspace(red(1),pink(1),lengthC)', linspace(red(2),pink(2),lengthC)', linspace(red(3),pink(3),lengthC)'];

hb = figure; hold on;
set(gca,'linewidth',2); set(hb,'Position',[333   289   217   186]);

c = 1
legendlist = {};
for base = baselist
    x = [0:NumFS];
    fcn = base.^x;
    fcn(find(fcn<0.47)) = 0.47;
    plot(x, fcn, 'Color',colors_p(c,:),'LineWidth',2);
    ll = ['a= ' num2str(base)];
    legendlist = [legendlist, ll];
    c = c+1;
end
    
xlim([0 15]);
ylim([0 1]);
set(gca,'XTick',[0:3:15],'FontSize',11);
set(gca,'YTick',[0:0.2:1],'FontSize',11);
%legend(legendlist);
xlabel('Fixation Offset from Current Fixation','FontSize',12);
ylabel('Memory Decay','FontSize',12);

set(hb,'Units','Inches');
pos = get(hb,'Position');
%set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[8.5 11]);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
print(hb,['Figures/memfunction' printpostfix],printmode,printoption);
printpostfix = '.png';
printmode = '-dpng'; %-depsc
printoption = '-r200'; %'-fillpage'
print(hb,['Figures/memfunction' printpostfix],printmode,printoption);
% %% distribution of recog map
% linewidth = 2;
% printpostfix = '.eps';
% printmode = '-depsc'; %-depsc
% printoption = '-r200'; %'-fillpage'
% 
% hb = figure; hold on;
% load(['Mat/distri_' analysis '_' type '.mat']);
% %load(['Mat/distri_similarity_' type '.mat']);
% MAX = max([max(distriT) max(distriF)]);
% BINNUM = 100;
% binranges = [0:MAX/BINNUM:MAX];
% bincounts = histc(distriT,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);
% 
% bincounts = histc(distriF,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','r','LineWidth',linewidth);
% 
% legend({'Target','Non-target'},'Location','northeast','FontSize',14);
% legend boxoff ;
% xlim([0 MAX]);
% %set(gca,'XTick',xtickrange);
% %ylim([0 1]*80);
% xlabel(['Map Value'],'FontSize',14);
% ylabel('Distribution (%)','FontSize',14);
% title([type '; m(T)=' num2str(median(distriT)) '; m(NT)=' num2str(median(distriF))],'FontSize', 14);
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['Figures/VisualDistri_' analysis '_' type printpostfix],printmode,printoption);