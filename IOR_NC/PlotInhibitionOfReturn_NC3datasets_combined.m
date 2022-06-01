clear all; close all; clc;

these_Degs = [1];

for this_Deg = these_Degs
    
    save_Mat_IOR = 1;
    save_Mat_bar_IOR = 1;
    
    TYPELIST = {'array','naturaldesign','waldo','naturalsaliency'};
    
    fig3_fix_dva = {}; 
    
    for T = 1:length(TYPELIST)
        
        type = TYPELIST{T};
        %note: three datasets have not re-sequentalized; reorder first!
        % the first fixation is always the center; remove the first fix!
        % the reaction time lasts from the first fix to the trial start!
        if strcmp(type, 'array')
            HumanNumFix = 6;
            NumStimuli = 600;
            all_subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
                'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
                'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
            MaxPlotFix = 6;
            xtickrange = [1:MaxPlotFix];
            
        elseif strcmp(type, 'naturaldesign')
            HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
            NumStimuli = 480;
            all_subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
                'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
                'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
            MaxPlotFix = 30;
            xtickrange = [1 5:5:MaxPlotFix];
        elseif strcmp(type, 'naturalsaliency')
            HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
            NumStimuli = 480;
            all_subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
                'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'}; %natural design
            MaxPlotFix = 30;
            xtickrange = [1 5:5:MaxPlotFix];
            
        else
            HumanNumFix = 80;
            NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
            all_subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
                'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
                'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
            MaxPlotFix = 80;
            xtickrange = [1 10:10:MaxPlotFix];
        end
        
        for su = 1:numel(all_subjlist)
            
            subjlist{1} = all_subjlist{su};
            
            fig3_fix_dva{su}.subject = subjlist{1};
            
            load(['Datasets/SubjectArray/' type '.mat']);
            load(['Datasets/SubjectArray/' type '_seq.mat']);
            
            if strcmp(type, 'naturalsaliency')
                centerR = ones(2, NumStimuli/2)*5000;
            else
                %load(['Mat/GTRatioList_' type '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
                centerR = ones(2, NumStimuli/2)*5000;
            end
            
            [B,seqInd] = sort(seq);
            
            [B,seqInd] = sort(seq);
            Imgw = 1024;
            Imgh = 1280;
            
            linewidth  =2;
            binranges = [1:1:MaxPlotFix+1];
            
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
            fig3_fix_dva{su}.deg_str = deg_str;
            fig3_fix_dva{su}.deg = Deg;
            fig3_fix_dva{su}.(type).(deg_str) = {};
            %% -------------------------------------------------
            
            
            
            imgvalid = [1:NumStimuli/2];
            
            for s = 1: length(subjlist)
                load(['Datasets/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
                PosX = FixData.Fix_posx;
                PosY = FixData.Fix_posy;
                PosX = PosX(seqInd);
                PosY = PosY(seqInd);
                
                %all trials
                Firstx = PosX(1:NumStimuli/2);
                Firsty = PosY(1:NumStimuli/2);
                
                centerRx = centerR(1, imgvalid);
                centerRy = centerR(2, imgvalid);
                
                if save_Mat_IOR
                    [propnt1, offsetnt1, propt1, offsett1,countpropntD, countpropntN, countproptD, countproptN ] = fcn_MMevalInhibitionOfReturn(Firstx, Firsty, centerRx, centerRy, IORthres, IORthresT, subjlist{s}, imgvalid, 1, [type '_comb']);
                    if save_Mat_bar_IOR
                        save(['IOR_NC/Mat/IOR_' type '_' subjlist{s} '_comb.mat'],...
                            'propnt1', 'offsetnt1', 'propt1', 'offsett1','countpropntD', 'countpropntN', 'countproptD', 'countproptN');
                    end
                end
            end
            display('IOR computation done');
            
            overallMeanS1 = []; overallStdS1 = [];
            prop1t_mean = []; prop1nt_mean = [];
            offsettotalT = []; offsettotalNT = [];
                        all_countpropntD = []; all_countpropntN = []; all_countproptD = []; all_countproptN = []; 
            for s = 1:length(subjlist)
                load(['Mat/IOR_' type '_' subjlist{s} '_comb.mat']);
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
            fig3_fix_dva{su}.(type).(deg_str).fixations.countpropntD = all_countpropntD;
            fig3_fix_dva{su}.(type).(deg_str).fixations.countpropntN = all_countpropntN;
            fig3_fix_dva{su}.(type).(deg_str).fixations.countproptD  = all_countproptD;
            fig3_fix_dva{su}.(type).(deg_str).fixations.countproptN  = all_countproptN;            
            %% -------------------------------------------------
            
            %% plot
            
            overallMeanS1 = [nanmean(prop1nt_mean)] * 100;
            overallStdS1 = [nanstd(prop1nt_mean)/sqrt(length(prop1nt_mean))]*100;
            
            
            load(['Mat/' type '_chanceoffsetnt.mat']);
            %load(['Mat/' deg_str '_' type '_chanceoffsetnt'  '_s' num2str(su,'%02d') '.mat']);
            [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
            [h pnt ci stats] = ttest2(propnt,prop1nt_mean);
            display([type '; pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);
            
            
            all_countpropntD = []; all_countpropntN = []; all_countproptD = []; all_countproptN = []; 
            all_countpropntD = [all_countpropntD countpropntD]; 
            all_countpropntN = [all_countpropntN countpropntN];
            all_countproptD  = [all_countproptD countproptD];
            all_countproptN  = [all_countproptN countproptN];
            %% ------------------------------------------------- 
            fig3_fix_dva{su}.(type).(deg_str).fixations_chance.countpropntD = all_countpropntD;
            fig3_fix_dva{su}.(type).(deg_str).fixations_chance.countpropntN = all_countpropntN;
            fig3_fix_dva{su}.(type).(deg_str).fixations_chance.countproptD  = all_countproptD;
            fig3_fix_dva{su}.(type).(deg_str).fixations_chance.countproptN  = all_countproptN;
            %% -------------------------------------------------
            
            
            chanceval = nanmean(propnt);
            chancevalT = nanmean(propt);
            %load(['Mat/saccade_' type  '.mat']);
            %chanceval = length(find(SIMNONRETURN_Radius<=Deg))/length(SIMNONRETURN_Radius);
            %% show IOR prop (overall)
            if strcmp(type, 'array')
                hb = figure('Visible','off','Position',[288   207   130   258]); hold on;
            else
                hb = figure('Visible','off','Position',[288   207   85   258]); hold on;
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
            bar([1],overallMeanS1,'FaceColor',[0 0 0],'LineWidth',1.5);
            errorbar([1], overallMeanS1, overallStdS1,'k.');
            plot([0:0.5:1.5],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2.5);
            display([type '; mean=' num2str(overallMeanS1) '; std=' num2str(overallStdS1)]);
            
            set(gca,'YTick',[0:0.1:0.4]*100,'FontSize',11);
            
            if ~strcmp(type, 'array')
                set(gca,'YTickLabel',{},'FontSize',12);
            end
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
            %set(hb,'Position',[318   253   131   242]);
            set(hb,'Units','Inches');
            pos = get(hb,'Position');
            set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            print(hb,['Figures/Fig_IOR_first_overall_' type '_s' num2str(su,'%02d') '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);
            print(hb,['Figures/Fig_IOR_first_overall_' type '_s' num2str(su,'%02d') '_Deg_' num2str(Deg*100) printpostfix2],printmode2,printoption2); 
            
            
            %% ------------------------------------------------- 
            fig3_fix_dva{su}.(type).(deg_str).bar.overallMeanS1 = overallMeanS1;
            fig3_fix_dva{su}.(type).(deg_str).bar.overallStdS1 = overallStdS1;
            fig3_fix_dva{su}.(type).(deg_str).bar.chancevalT = chancevalT*100;
            fig3_fix_dva{su}.(type).(deg_str).bar.chanceval = chanceval*100;
            %% -------------------------------------------------
            
            
            
            %% ------------------------------------------------- 
            fig3_fix_dva{su}.(type).(deg_str).plot.offsettotalT = offsettotalT;
            fig3_fix_dva{su}.(type).(deg_str).plot.offsettotalNT = offsettotalNT;
            fig3_fix_dva{su}.(type).(deg_str).plot.binranges = binranges;
            %% -------------------------------------------------
            
            close all
        end
    end
    
    save(['Figures/fig3_fix_dva_human_comb_' deg_str '.mat'],'fig3_fix_dva'); 
    
end