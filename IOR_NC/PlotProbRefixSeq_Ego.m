clear all; close all; clc;

type = 'os'; %os, egteaplus

load(['Mat/' type '_Fix.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

imgsize0 = 1024;
imgsize1 = 1280;

probrefix = [];

if strcmp(type, 'egteaplus')
    
    MaxPlotFix = 20;
    xtickrange = [1:4:MaxPlotFix];
else
    
    MaxPlotFix = 20;
    xtickrange = [1:4:MaxPlotFix];
end

for imgID = 1:length(Fix_posx)

    %% pre-filter whether it satisfies 
    ImgSelected = imgID;

    display(['imgID: ' num2str(imgID) ]);

    load(['Mat_IOR_' type '/' type '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

    if isempty(overlappairsnt)
        continue;
    end

    if ~isempty(overlappairsnt)
        qq1 = overlappairsnt(:,1);
        qq2 = overlappairsnt(:,2);

        %remove those triple pairs (A,B) and (B,C); then we only take C
        qq2(ismember(qq2,qq1)) = [];  

        probrefix = [probrefix; qq2];
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


