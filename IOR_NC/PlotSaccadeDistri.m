clear all; close all; clc;
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
linewidth = 2;

TYPELIST = {'array','naturaldesign','waldo','naturalsaliency','wmonkey','cmonkey','egteaplus','os'};

binranges = [0:1:20];
MaxPlotFix = 20;
xtickrange = [0:5:20];

for t = 1:length(TYPELIST)
    
    hb = figure; hold on;
    
    type = TYPELIST{t};  
    if strcmp(type, 'array')
        binranges = [0:0.5:20];
        MaxPlotFix = 20;
        xtickrange = [0:5:20];
    elseif strcmp(type, 'naturaldesign')
        binranges = [0:0.5:30];
        MaxPlotFix = 30;
        xtickrange = [0:10:30];
    elseif strcmp(type, 'waldo')
        binranges = [0:0.5:30];
        xtickrange = [0:10:30];
        MaxPlotFix = 30;
    elseif strcmp(type, 'naturalsaliency')
        binranges = [0:0.5:30];
        xtickrange = [0:10:30];
        MaxPlotFix = 30;
    elseif strcmp(type, 'wmonkey')
        binranges = [0:0.5:30];
        xtickrange = [0:10:30];
        MaxPlotFix = 30;
    elseif strcmp(type, 'cmonkey')
        binranges = [0:0.5:30];
        xtickrange = [0:10:30];
        MaxPlotFix = 30;
    elseif strcmp(type, 'egteaplus')
        binranges = [0:0.5:30];
        xtickrange = [0:10:30];
        MaxPlotFix = 30;
    else
        binranges = [0:0.5:30];
        xtickrange = [0:10:30];
        MaxPlotFix = 30;
    end
    
    load(['Mat/saccade_' type  '.mat']);
    all = [SIMRETURN_Radius,SIMRETURN2_Radius,SIMNONRETURN_Radius];    
    if t<=4
        all = all*(1024/38)/(1024/32); %consistent with NC paper
    end
    
    bincounts = histc(all,binranges);
    bincounts = bincounts/sum(bincounts);
    binc = bincounts*100;
    plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','-');
    
    if t<=6
        load(['Mat/saccade_' type  '_conv_only.mat']);
        all = [SIMRETURN_Radius,SIMRETURN2_Radius,SIMNONRETURN_Radius];
        if t<=4
            all = all*(1024/38)/(1024/32); %consistent with NC paper
        end
        bincounts = histc(all,binranges);
        bincounts = bincounts/sum(bincounts);
        binc = bincounts*100;
        plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');
    end
    
    xlim([0 MaxPlotFix]);
    set(gca,'XTick',xtickrange,'FontSize',11);
    
    if strcmp(type,'array')
        ylim([0 1]*90);
        set(gca,'YTick',[0:30:90],'FontSize',11);
    else
        ylim([0 1]*25);
        set(gca,'YTick',[0:5:25],'FontSize',11);
    end
    
    xlabel('Saccade Size (degrees)','FontSize',14);
    ylabel('Distribution (%)','FontSize',14);
    set(gca,'linewidth',2);
    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');
    set(hb, 'Position',[675   891   256   198]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    %set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[8.5 11]);
    print(hb,['Figures/SacDistri_' type  printpostfix],printmode,printoption);
    
end

    