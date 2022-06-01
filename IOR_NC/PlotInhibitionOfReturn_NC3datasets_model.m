clear all; close all; clc;

these_Degs = [1];

for this_Deg = these_Degs
    
    save_Mat_IOR = 1;
    save_Mat_bar_IOR = 1;
    
    TYPELIST = {'array_conv_only','naturaldesign_conv_only','waldo_conv_only','naturalsaliency_conv_only'};
    
    fig3_fix_dva = {}; 
    
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
            xtickrange = [1 10:10:MaxPlotFix];
        elseif strcmp(subtype, 'naturalsaliency')
            HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
            NumStimuli = 480;
            subjlist = {type}; %natural design
            MaxPlotFix = 30;
            xtickrange = [1 10:10:MaxPlotFix];
            
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
            load(['Mat/GTRatioList_' subtype '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
        end
        
        
        Imgw = 1024;
        Imgh = 1280;
        
        linewidth  =2;
        binranges = [1:1:MaxPlotFix+1];
        
        %fair to model; subsampled from 38 x 50 grids wrt 1024 x 1280 grids
        rgin 1280/50 = 25.6 gap min
        % Deg = this_Deg; %[0.25 0.5 1 2 4]
        % IORthres = 43*Deg; %threshold as repeated fixations
        % IORthresT = 133/2; %threshold as within target
        
        
        %% ------------------------------------------------- 
        Deg = this_Deg; %[0.25 0.5 1 2 4]
        IORthres = 43*Deg; %threshold as repeated fixations
        IORthresT = 133/2; %threshold as within target
        
        printpostfix = '.eps'; %1
        printmode = '-depsc'; %-depsc
        printoption = '-r200'; %'-fillpage'
        printpostfix2 = '.png'; %0
        printmode2 = '-dpng'; %-depsc
        printoption2 = '-r200'; %'-fillpage'
        
        deg_str = ['deg'  num2str(Deg*100)];
        fig3_fix_dva.deg_str = deg_str;
        fig3_fix_dva.deg = Deg;
        fig3_fix_dva.(type).(deg_str) = {};
        %% -------------------------------------------------
        
        
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
            
            if save_Mat_IOR
                
                [propnt1, offsetnt1, propt1, offsett1, countpropntD, countpropntN, countproptD, countproptN ] = fcn_MMevalInhibitionOfReturn(Firstx, Firsty, centerRx, centerRy, IORthres, IORthresT, subjlist{s}, imgvalid, 1, type);
                if save_Mat_bar_IOR
                    save(['IOR_NC/Mat/IOR_' type '_' subjlist{s} '.mat'],...
                        'propnt1', 'offsetnt1', 'propt1', 'offsett1','countpropntD', 'countpropntN', 'countproptD', 'countproptN');
                    %propnt1
                    %propt1
                end
            end
        end
        % display('IOR computation done');
        % [h p] = ttest2(propnt1, propt1);
        
        overallMeanS1 = []; overallStdS1 = [];
        prop1t_mean = []; prop1nt_mean = [];
        offsettotalT = []; offsettotalNT = [];
        all_countpropntD = []; all_countpropntN = []; all_countproptD = []; all_countproptN = []; 
        for s = 1:length(subjlist)
            load(['Mat/IOR_' type '_' subjlist{s} '.mat']);
            offsett1(find(offsett1>MaxPlotFix)) = [];
            offsetnt1(find(offsetnt1>MaxPlotFix)) = [];
            
            offsettotalT = [offsettotalT offsett1];
            offsettotalNT = [offsettotalNT offsetnt1];
            
            all_countpropntD = [all_countpropntD countpropntD]; 
            all_countpropntN = [all_countpropntN countpropntN];
            all_countproptD  = [all_countproptD countproptD];
            all_countproptN  = [all_countproptN countproptN];
            
            [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
            prop1t_mean = [prop1t_mean (propt)];
            prop1nt_mean = [prop1nt_mean (propnt)];
        end
        
        
        %% ------------------------------------------------- 
        fig3_fix_dva.(type).(deg_str).fixations.countpropntD = all_countpropntD;
        fig3_fix_dva.(type).(deg_str).fixations.countpropntN = all_countpropntN;
        fig3_fix_dva.(type).(deg_str).fixations.countproptD  = all_countproptD;
        fig3_fix_dva.(type).(deg_str).fixations.countproptN  = all_countproptN;
        %% -------------------------------------------------
        
        %% plot
        if strcmp(subtype, 'naturalsaliency')
            overallMeanS1 = [nanmean(prop1nt_mean)] * 100;
            overallStdS1 = [nanstd(prop1nt_mean)/sqrt(length(prop1nt_mean))]*100;
            display([type '; mean=' num2str(overallMeanS1) '; std=' num2str(overallStdS1)]);
        else
            overallMeanS1 = [nanmean(prop1t_mean) nanmean(prop1nt_mean)] * 100;
            overallStdS1 = [nanstd(prop1t_mean)/sqrt(length(prop1t_mean)) nanstd(prop1nt_mean)/sqrt(length(prop1nt_mean))]*100;
        end
        
        load(['Mat/' subtype '_chanceoffsetnt.mat']);
        %load(['Mat/' deg_str '_' type '_chanceoffsetnt'  '_s' num2str(1,'%02d') '.mat']);
        
        [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
        [h pnt ci stats] = ttest2(propnt,prop1nt_mean);
        display([type '; pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);
        
        
        all_countpropntD = []; all_countpropntN = []; all_countproptD = []; all_countproptN = []; 
        all_countpropntD = [all_countpropntD countpropntD]; 
        all_countpropntN = [all_countpropntN countpropntN];
        all_countproptD  = [all_countproptD countproptD];
        all_countproptN  = [all_countproptN countproptN];
        %% ------------------------------------------------- 
        fig3_fix_dva.(type).(deg_str).fixations_chance.countpropntD = all_countpropntD;
        fig3_fix_dva.(type).(deg_str).fixations_chance.countpropntN = all_countpropntN;
        fig3_fix_dva.(type).(deg_str).fixations_chance.countproptD  = all_countproptD;
        fig3_fix_dva.(type).(deg_str).fixations_chance.countproptN  = all_countproptN;
        %% -------------------------------------------------
        
        if ~strcmp(subtype, 'naturalsaliency')
            [h pt] = ttest2(propt,prop1t_mean);
            [h pb] = ttest2(prop1nt_mean,prop1t_mean);
        end
        
        chanceval = nanmean(propnt);
        chancevalT = nanmean(propt);
        %load(['Mat/saccade_' type  '.mat']);
        %chanceval = length(find(SIMNONRETURN_Radius<=Deg))/length(SIMNONRETURN_Radius);
        
        %% show IOR prop (overall)
        if strcmp(subtype,'naturalsaliency')
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
                hb = figure('Position',[293   212   158+15   258]); hold on;
            else
                hb = figure('Position',[293   212   158   258]); hold on;
            end
            
            if pt <= 0.05
                text(1,30, '*', 'Fontsize', 12, 'Fontweight', 'bold');
                % elseif pvalue <= 0.01
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
                % elseif pvalue <= 0.001
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
            else
                text(1,30, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
            end
            
            if pnt <= 0.05
                text(2,30, '*', 'Fontsize', 12, 'Fontweight', 'bold');
                % elseif pvalue <= 0.01
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
                % elseif pvalue <= 0.001
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
            else
                text(2,30, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
            end
            
            if pb <= 0.05
                text(1.5,35, '*', 'Fontsize', 12, 'Fontweight', 'bold');
                %plot([1 2],[29 29],'k','LineWidth',2.5);
                fcn_sigstar(1,2,33,0.03);
                % elseif pvalue <= 0.01
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
                % elseif pvalue <= 0.001
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
            else
                text(1.5,35, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
                %plot([1 2],[29 29],'k','LineWidth',2.5);
                fcn_sigstar(1,2,33,0.03);
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
        
        if strcmp(subtype, 'naturalsaliency')
            bar([1],overallMeanS1,'FaceColor',[0 0 0],'LineWidth',1.5);
            errorbar([1], overallMeanS1, overallStdS1,'k.');
        else
            bar([1 2],overallMeanS1,'FaceColor',[0 0 0],'LineWidth',1.5);
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
        
        
        if strcmp(subtype, 'naturalsaliency')
            set(gca,'XTick',[1],'FontSize',14);
            xlim([0.5 1.5]);
            set(gca,'XTickLabel',{''},'FontSize',12);
            titlename = [type ';pnt=' num2str(pnt)];
            set(gca,'YTick',[0:0.1:0.4]*100,'FontSize',11);
            ylim([0 50]);
            %title(titlename,'FontSize',14);
        else
            set(gca,'YTick',[0:0.1:0.3]*100,'FontSize',11);
            set(gca,'XTick',[1 2],'FontSize',11);
            xlim([0.5 2.5]);
            ylim([0 50]);
            set(gca,'XTickLabel',{'Target','Non-Target'},'FontSize',12);
            titlename = [type ';pt=' num2str(pt) '; pnt=' num2str(pnt) '; pb=' num2str(pb)];
            %title(titlename,'FontSize',14);
        end
        
        
        set(gca, 'TickDir', 'out');
        set(gca, 'Box','off');
        %xlabel('Inter Trial Interval','FontSize',14');
        if strcmp(type, 'array')
            ylabel('Proportion (%)','FontSize',12);
        else
            %     set(gca,'YTickLabel',{},'FontSize',12);
        end
        
        set(gca,'XTickLabelRotation',45);
        %legend({'Chance'},'FontSize',14);legend boxoff ;
        % titlename = [type ': 1st exposure'];
        % title(titlename,'FontSize',14);
        set(hb,'Units','Inches');
        pos = get(hb,'Position');
        set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(hb,['Figures/Figs_IOR_first_overall_' type '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);
        print(hb,['Figures/Figs_IOR_first_overall_' type '_Deg_' num2str(Deg*100) printpostfix2],printmode2,printoption2);
        
        
        %% ------------------------------------------------- 
        fig3_fix_dva.(type).(deg_str).bar.overallMeanS1 = overallMeanS1;
        fig3_fix_dva.(type).(deg_str).bar.overallStdS1 = overallStdS1;
        fig3_fix_dva.(type).(deg_str).bar.chancevalT = chancevalT*100;
        fig3_fix_dva.(type).(deg_str).bar.chanceval = chanceval*100;
        %% -------------------------------------------------
        
        
        
        %% show IOR offset (overall)
        hb = figure; hold on;set(hb,'Position',[313   248   293   242]);
        set(gca,'linewidth',2);
        if strcmp(subtype,'array')
            set(hb,'Position',[313   248   293+30   242+35]);
        else
            set(hb,'Position',[313   248   293   242]);
        end
        
        if isempty(offsettotalT)
            bincounts = zeros(size(binranges));
        else
            bincounts = histc(offsettotalT,binranges);
            bincounts = bincounts/sum(bincounts);
        end
        
        if ~strcmp(subtype, 'naturalsaliency')
            if ~isempty(offsettotalT)
                [h po] = ttest2(offsettotalT, offsettotalNT);
            end
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
        
        if ~strcmp(subtype,'array')
            load(['Mat/' subtype '_chanceoffsetnt.mat']);
            %load(['Mat/' deg_str '_' type '_chanceoffsetnt'  '_s' num2str(1,'%02d') '.mat']);
            bincounts = histc(chanceoffsetnt,binranges);
            bincounts = bincounts/sum(bincounts);
            %plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle',':');
        else
            %plot(binranges-1,ones(size(binranges-1))* 1/MaxPlotFix*100,'k:','LineWidth',linewidth);
        end
        if ~strcmp(subtype, 'naturalsaliency')
            %title([type '; po=' num2str(po)],'FontSize', 14);
            %legend({'Target','Non-target'},'Location','northeast','FontSize',12);
        else
            %title([type],'FontSize', 14);
            %legend({''},'Location','northeast','FontSize',12);
        end
        %legend boxoff ;
        xlim([1 MaxPlotFix]);
        set(gca,'XTick',xtickrange);
        ylim([0 1]*90);
        set(gca,'YTick',[0:30:90],'FontSize',11);
        if strcmp(subtype,'array')
            %set(gca,'YTickLabel',{},'FontSize',12);
            xlabel({'Returning Offset';'(Fixations)'},'FontSize',12);
            ylabel('Distribution (%)','FontSize',12);
        else
            %     set(gca,'YTickLabel',{},'FontSize',12);
        end
        
        set(gca, 'TickDir', 'out');
        set(gca, 'Box','off');
        set(hb,'Units','Inches');
        pos = get(hb,'Position');
        set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(hb,['Figures/Figs_IORoffsetFirstOnly_' type '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);
        print(hb,['Figures/Figs_IORoffsetFirstOnly_' type '_Deg_' num2str(Deg*100) printpostfix2],printmode2,printoption2);
        
        
        %% ------------------------------------------------- 
        fig3_fix_dva.(type).(deg_str).plot.offsettotalT = offsettotalT;
        fig3_fix_dva.(type).(deg_str).plot.offsettotalNT = offsettotalNT;
        fig3_fix_dva.(type).(deg_str).plot.binranges = binranges;
        %% -------------------------------------------------
        
        close all
        
    end
    
    save(['Figures/fig3_fix_dva_model_' deg_str '.mat'],'fig3_fix_dva'); 
    
end