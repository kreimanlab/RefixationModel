clear all; close all; clc;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

TYPELIST = {'naturaldesign','waldo','array','naturalsaliency','wmonkey','cmonkey'};

for T = 1:4 %length(TYPELIST)
    
    type = TYPELIST{T};
    
    if strcmp(type,'wmonkey') || strcmp(type,'cmonkey')
        Imgw = 596; Imgh = 596;
        load(['Mat/RefixMatConsistency_chance_monkeys.mat']);
        Wbinranges = [0:18.625:Imgw];
        Hbinranges = [0:14.9:Imgh];
    else
        Imgw = 1024;Imgh = 1280;
        load(['Mat/RefixMatConsistency_chance_NC3datasets.mat']);
        Wbinranges = [0:32:1024];
        Hbinranges = [0:32:1280];
    end

    Gsize = 130; Gvar = 25; %gaussian filter specs
    G = fspecial('gaussian',[Gsize Gsize], Gvar); 

    %% comment out

    load(['Mat/refixmap_consistency_' type '.mat']);
    
    entropylist = [];
    chanceentropy = [];

    for i = 1:length(RefixMaps)
        i
        x = RefixMaps(i).binaryw;
        y = RefixMaps(i).binaryh;
        totalFix = length(x);
               
        chanceentropy = [chanceentropy ChanceResults{totalFix}];
        
%         saliency = imfilter(map,G,'same');
%         saliency = mat2gray(saliency);
%         saliency = reshape(saliency,[Imgw*Imgh 1]);
        %prob = saliency/sum(saliency);
        [prob,Xedges,Yedges] = histcounts2(x,y,Wbinranges,Hbinranges,'Normalization','probability');
        prob(find(prob<=0)) = 0.00000000001;
        %prob = softmax(saliency(:));
        %prob = softmax(saliency);
        prob=prob(:);
        H=-sum(prob.*log2(prob));
        entropylist = [entropylist H];

    end
    save(['Mat/RefixMapConsistency_entropy_' type '.mat'],'chanceentropy','entropylist');

    %%

    load(['Mat/RefixMapConsistency_entropy_' type '.mat']);

    %% draw amplitude distribution (histogram)
%     hb = figure; hold on;
%     set(gca,'linewidth',2); set(hb,'Position',[313   248   293   242]);
%     linewidth = 2;
%     a = cellfun(@mean, ChanceResults);
%     binranges = [min(a): (max(a)-min(a))/20: max(a)];
%     bincounts = histc(entropylist,binranges);
%     bincounts = bincounts/sum(bincounts);    
%     plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','-');
%     bincounts = histc(chanceentropy,binranges);
%     bincounts = bincounts/sum(bincounts);
%     plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');
    %legend({'Humans','Chance'},'Location','northeast','FontSize',14);
    %legend boxoff ;
%     xlim([20.3 20.35]);
%     xtickrange = [20.3:0.01:20.35];
%     set(gca,'XTick',xtickrange,'FontSize',11);
%     set(gca,'YTick',[0:0.2:1]*100,'FontSize',11);
%     yaxislim = [0 100];
%     ylim(yaxislim);
%     xlabel('Entropy','FontSize',14);
%     ylabel('Distribution (%)','FontSize',14);
%     [h pval] = ttest2(entropylist, chanceentropy);
%     %title([type '; p = ' num2str(pval)],'FontSize', 14);
%     set(gca, 'TickDir', 'out');
%     set(gca, 'Box','off');
%     set(hb,'Units','Inches');
%     pos = get(hb,'Position');
%     set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%     print(hb,['Figures/RefixMapConsistencyDistri_' type  printpostfix],printmode,printoption);

    %% draw amplitude distribution (bar plots)
    hb = figure('Position',[288   207   120   258]); hold on;
    set(gca,'linewidth',2);

    M = [mean(entropylist)];
    Mstd = [std(entropylist)/sqrt(length(entropylist))];
    bar([1],M(1),'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
    errorbar([1], M(1), Mstd(1),'k.');
    plot([0:0.5:1.5],ones(size([0:3]))* mean(chanceentropy),'k:','LineWidth',2.5);
    [h pval] = ttest2(entropylist, chanceentropy);
    if pval <= 0.05
        text(1,7, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    else
        %text(1,7, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
    end

    xlim([0.5 1.5]);
    xtickrange = [1:1];
    set(gca,'XTick',xtickrange,'FontSize',11);
    set(gca,'XTickLabel',{''},'FontSize',12);
    %set(gca,'XTickLabelRotation',45);
    yaxislim = [0 7];
    ytickrange = [0:1:7];
    set(gca,'YTick',ytickrange,'FontSize',11);
    ylim(yaxislim);
    ylabel('Entropy','FontSize',12);

    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');

    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['Figures/RefixMapConsistency_barplot_' type  printpostfix],printmode,printoption);
    
end
