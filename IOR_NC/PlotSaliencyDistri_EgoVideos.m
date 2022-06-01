clear all; clc; close all;

TYPELIST = {'egteaplus','os'};

for T = 1:length(TYPELIST)
    
    type = TYPELIST{T}; %egteaplus, os
    subtype = type;
    
    load(['Mat/SalMat_EgoVideo_' type '.mat']);
    %,'CEsaliency'
    load(['Mat/' type '_Fix.mat']);
    printpostfix = '.eps';
    printmode = '-depsc'; %-depsc
    printoption = '-r200'; %'-fillpage'
    
    linewidth  =2;
    
    if strcmp(type,'egteaplus')
        load(['IOR_NC/Mat/FrameDistL2_' type '.mat']);
    end
    
    if 1
        %% comment out
        SIMRETURN = []; SIMNONRETURN = [];
           SIMRETURN_subjs = [];
        SIMNONRETURN_subjs = [];
        
        PosX = Fix_posx;
        PosY = Fix_posy;
        
        %all trials
        Firstx = PosX;
        Firsty = PosY;
        
        for i = 1:length(CEsaliency)
            
            this_subject = Fix_subj{i};

            display(['processing ... img: ' num2str(i) ]);
            fx = double(Firstx{i});
            fy = double(Firsty{i});
            
            % remove those trials with only one fixation
            if length(fx)== 1
                continue;
            end
            
            load(['Mat_IOR_' type '/' type '_stimuli_' num2str(i) '.mat']);
            if ~isempty(overlappairsnt)
                overlappairsnt = overlappairsnt(:,1:1);
                %overlappairsnt = overlappairsnt + 1;
                overlappairsnt = overlappairsnt(:);
            end
            if ~isempty(overlappairst)
                overlappairst = overlappairst(:,1:1);
                %overlappairst = overlappairst + 1;
                overlappairst = overlappairst(:);
            end
            
            overlap = [overlappairst; overlappairsnt];
            overlap = unique(overlap);
            
            
            
            sim = [];
            sallist = CEsaliency{i};
            sallist = sallist(2:end);
            sim = sallist;
            
            SIMRETURN = [SIMRETURN sim(overlap)];
            sim(overlap) = [];
            SIMNONRETURN = [SIMNONRETURN sim];
            
            n_new_samples_SIMRETURN = numel(SIMRETURN) - numel(SIMRETURN_subjs);
            n_new_samples_SIMNONRETURN = numel(SIMNONRETURN) - numel(SIMNONRETURN_subjs);
            SIMRETURN_subjs = [SIMRETURN_subjs this_subject*ones(1,n_new_samples_SIMRETURN)];
            SIMNONRETURN_subjs = [SIMNONRETURN_subjs this_subject*ones(1,n_new_samples_SIMNONRETURN)];
                        
        end
        
        
        save(['IOR_NC/Mat/saliency_' type  '.mat'],'SIMRETURN','SIMNONRETURN','SIMRETURN_subjs','SIMNONRETURN_subjs');
        save(['Figures/data_saliency_' type  '.mat'],'SIMRETURN','SIMNONRETURN','SIMRETURN_subjs','SIMNONRETURN_subjs');
    end
    
    
    if 1
        hb = figure; hold on;
        set(gca,'linewidth',2);
        
        load(['Mat/saliency_' type '.mat']);
        MAX = max([max(SIMRETURN) max(SIMNONRETURN)]);
        BINNUM = 100;
        binranges = [0:MAX/BINNUM:MAX];
        bincounts = histc(SIMRETURN,binranges);
        bincounts = bincounts/sum(bincounts);
        plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);
        
        bincounts = histc(SIMNONRETURN,binranges);
        bincounts = bincounts/sum(bincounts);
        plot(binranges, bincounts*100,'Color','r','LineWidth',linewidth);
        
        legend({'Return','Non-return','Chance'},'Location','northeast','FontSize',14);
        legend boxoff ;
        xlim([0 MAX]);
        %set(gca,'XTick',xtickrange);
        %ylim([0 1]*80);
        xlabel(['Saliency'],'FontSize',14);
        ylabel('Distribution (%)','FontSize',14);
        title([type '; m(R)=' num2str(mean(SIMRETURN)) '; m(NR)=' num2str(mean(SIMNONRETURN))],'FontSize', 14);
        set(gca, 'TickDir', 'out');
        set(gca, 'Box','off');
        set(hb,'Units','Inches');
        pos = get(hb,'Position');
        set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(hb,['Figures/Saliency_' type printpostfix],printmode,printoption);
        
    end
    
    
    %% bar plot and report stats
    hb = figure; hold on;
    set(gca,'linewidth',2);
    load(['Mat/saliency_' type '.mat']);
    
    bar([1],nanmean(SIMRETURN),'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
    errorbar([1], nanmean(SIMRETURN), nanstd(SIMRETURN)/sqrt(length(SIMRETURN)),'k.');
    bar([2],nanmean(SIMNONRETURN),'FaceColor',[0.8020    0.8020    0.8020],'LineWidth',1.5);
    errorbar([2], nanmean(SIMNONRETURN), nanstd(SIMNONRETURN)/sqrt(length(SIMNONRETURN)),'k.');
    set(gca,'XTick',[1 2],'FontSize',14);
    xlim([0.5 2.5]);
    %set(gca,'XTickLabel',{'Return','Non-Return'},'FontSize',12);
    set(gca,'XTickLabel',{''},'FontSize',12);
    set(gca,'YTickLabel',{''},'FontSize',12);
    set(gca,'XTickLabelRotation',45);
    ylim([0 0.65]);
    set(gca,'YTick',[0:0.2:0.6],'FontSize',11);
    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');
    %xlabel('Inter Trial Interval','FontSize',14');
    %ylabel('Saliency Value','FontSize',12);
    %legend({'Chance'},'FontSize',14);legend boxoff ;
    [a p] = ttest2(SIMRETURN, SIMNONRETURN);
    titlename = [type ': Stats p=' num2str(p)];
    
    if p <= 0.05
        text(1.5,0.67, '*', 'Fontsize', 12, 'Fontweight', 'bold');
        %plot([1 2],[0.65 0.65],'k','LineWidth',2.5);
        fcn_sigstar(1,2,0.63,0.03);
        % elseif pvalue <= 0.01
        %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
        % elseif pvalue <= 0.001
        %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
    else
        %     text(1.5,0.67, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
        %     plot([1 2],[0.65 0.65],'k','LineWidth',2.5);
    end
    
    %title(titlename,'FontSize',14);
    set(hb,'Position',[303   363    71   117]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['Figures/SaliencyBarPlot_' type printpostfix],printmode,printoption);
    
end
