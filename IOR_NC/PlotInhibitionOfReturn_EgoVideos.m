clear all; close all; clc;

these_Degs = [1] + 0.5;

for this_Deg = these_Degs
    
    save_Mat_IOR = 1;
    save_Mat_bar_IOR = 1;
    
    fig3_fix_dva = {}; 
    
    TYPELIST = {'egteaplus','os'};
    %TYPELIST = {'egteaplus'};
    
    for T = 1:length(TYPELIST)
        
        type = TYPELIST{T}; %egteaplus, os
        
        preprocess = 0; %toggle between 1 and 0
        
        if strcmp(type, 'os')
            imgsizeO = 1280;
            visualdeg=60;
            
            if preprocess == 1
                
                load(['Mat/FrameDistL2_' type '.mat']); %pre-filtered based on euclid dist
                %load(['Mat/CE_' type '.mat']);
                %convert everything to cells
                Fix_posx = {}; Fix_posy = {}; Fix_time = {}; Fix_pic = {}; Fix_endIndex = {}; Fix_microsad={};
                Fix_subj={};
                namelist = extractfield(CE, 'videoname');
                
                for i = 1:length(CE)
                    for j = 1:1%length(CE(i).fixations)
                        fixx = CE(i).fixations(:,1);
                        fixx = [imgsizeO/2; fixx]; %pending dummy center fixation; dim by 1
                        fixy = CE(i).fixations(:,2);
                        fixy = [imgsizeO/2; fixy]; %pending dummy center fixation; dim by 1
                        %CE(i).fixations_time
                        fixtime = (CE(i).fixations_time(2,:) - CE(i).fixations_time(1,:)+1)*1000/24;
                        
                        %% pre-filter anomaly fixation durations
                        %fixtime(find(fixtime <= 0 )) = nan;
                        %fixtime(find(fixtime >500 )) = nan;
                        
                        fixtime = [200 fixtime]; %pending dummy center duration; dim by 1
                        
                        Fix_endIndex = [Fix_endIndex; CE(i).endframe];
                        Fix_pic = [Fix_pic; CE(i).videoname];
                        Fix_posx = [Fix_posx; fixx'];
                        Fix_posy = [Fix_posy; fixy'];
                        Fix_time = [Fix_time; fixtime];
                        
                        subjid = strsplit(CE(i).videoname,'/');
                        subjid = subjid{2};
                        Fix_subj = [Fix_subj; subjid];
                        
                        freq_microsac = [0 CE(i).freq_microsac]; %add dummy microsaccade for dummy center fixation
                        Fix_microsad = [Fix_microsad; freq_microsac];
                    end
                end
                
                uniquename = unique(Fix_subj);
                recordname = nan(length(Fix_subj),1);
                for u = 1:length(uniquename)
                    ind = cellfun(@(string) strcmp(string, uniquename{u}), Fix_subj);
                    recordname(ind) = u;
                end
                Fix_subj = num2cell(recordname);
                
                save(['Mat/' type '_Fix.mat'],'Fix_subj','Fix_posx','Fix_posy','Fix_time','Fix_pic','Fix_endIndex','Fix_microsad');
                
            end
        elseif strcmp(type, 'egteaplus')
            imgsizeO = 1280;
            visualdeg=60;
            
            if preprocess == 1
                
                load(['Mat/FrameDistL2_' type '.mat']); %pre-filtered based on euclid dist
                %load(['Mat/CE_' type '.mat']);
                %convert everything to cells
                Fix_posx = {}; Fix_posy = {}; Fix_time = {}; Fix_pic = {}; Fix_endIndex = {};Fix_microsad={};
                Fix_subj={};
                namelist = extractfield(CE, 'videoname');
                
                for i = 1:length(CE)
                    fixx = CE(i).fixations(:,1);
                    fixx = [imgsizeO/2; fixx]; %pending dummy center fixation; dim by 1
                    fixy = CE(i).fixations(:,2);
                    fixy = [imgsizeO/2; fixy]; %pending dummy center fixation; dim by 1
                    fixtime = (CE(i).fixations_time(2,:) - CE(i).fixations_time(1,:)+1)*1000/24;
                    %% pre-filter anomaly fixation durations
                    %fixtime(find(fixtime <= 0 )) = nan;
                    
                    fixtime = [200 fixtime]; %pending dummy center duration; dim by 1
                    
                    Fix_endIndex = [Fix_endIndex; CE(i).endframe];
                    Fix_pic = [Fix_pic; CE(i).videoname];
                    Fix_posx = [Fix_posx; fixx'];
                    Fix_posy = [Fix_posy; fixy'];
                    Fix_time = [Fix_time; fixtime];
                    
                    subjid = strsplit(CE(i).videoname,'-');
                    subjid = strsplit(subjid{1},'/');
                    subjid = subjid{end};
                    Fix_subj = [Fix_subj; subjid];
                    
                    freq_microsac = [0 CE(i).freq_microsac]; %add dummy microsaccade for dummy center fixation
                    Fix_microsad = [Fix_microsad; freq_microsac];
                end
                uniquename = unique(Fix_subj);
                recordname = nan(length(Fix_subj),1);
                for u = 1:length(uniquename)
                    ind = cellfun(@(string) strcmp(string, uniquename{u}), Fix_subj);
                    recordname(ind) = u;
                end
                Fix_subj = num2cell(recordname);
                save(['Mat/' type '_Fix.mat'],'Fix_posx','Fix_posy','Fix_time','Fix_pic',...
                    'Fix_subj','Fix_endIndex','Fix_microsad');
                
            end
        else
            
            error(['this is pranav; we do NOT use this dataset any more']);
            imgsizeO = 1280;
            visualdeg=130; %gopro hero 4 silver; wide angle: 130 deg
            
            if preprocess == 1
                
                load(['Mat/CE_' type '.mat']);
                %convert everything to cells
                Fix_posx = {}; Fix_posy = {}; Fix_time = {};
                for i = 1:length(CE)
                    fixx = CE(i).fixations(:,1);
                    fixx = [imgsizeO/2; fixx]; %pending dummy center fixation; dim by 1
                    fixy = CE(i).fixations(:,2);
                    fixy = [imgsizeO/2; fixy]; %pending dummy center fixation; dim by 1
                    fixtime = (CE(i).fixations_time(2,:) - CE(i).fixations_time(1,:))*1000/30;
                    fixtime = [200 fixtime]; %pending dummy center duration; dim by 1
                    
                    Fix_posx = [Fix_posx; fixx'];
                    Fix_posy = [Fix_posy; fixy'];
                    Fix_time = [Fix_time; fixtime];
                end
                save(['Mat/' type '_Fix.mat'],'Fix_posx','Fix_posy','Fix_time');
                
            end
        end
        
        %create dummy
        load(['Mat/' type '_Fix.mat']);
        
        
        all_subjlist = 1;           
        if strcmp(type, 'egteaplus') || strcmp(type, 'os'); all_subjlist = unique(cell2mat(Fix_subj))'; end
        
        for su = all_subjlist
            
            if strcmp(type, 'egteaplus') || strcmp(type, 'os') 
                subids = cell2mat(Fix_subj);
                Firstx = Fix_posx(subids == su);
                Firsty = Fix_posy(subids == su);
            else
                Firstx = Fix_posx; Firsty = Fix_posy;
            end
            
            centerR = ones(2, length(Fix_posx))*2000;
            centerRx = centerR(1,:); centerRy = centerR(2,:);
            imgvalid = [1:length(Firstx)];
            
            % load(['Mat_' type '/TrackRecord.mat']);
            % vx = Record(:,3:4); vy = Record(:,5:6);
            % dist = sqrt(sum((vx -vy).^2,2));
            % dist = mean(dist);
            %Deg = visualdeg*dist/imgsize(2); %[0.25 0.5 1 2 4]
            %     Deg = this_Deg; %[0.25 0.5 1 2 4]
            %     %Deg = 4;
            %     IORthres = imgsizeO/visualdeg*Deg; %threshold as repeated fixations
            %     IORthresT = 133/2; %threshold as within target
            MaxPlotFix = 8;
            binranges = [0:MaxPlotFix+1];
            xtickrange = [1:MaxPlotFix];
            linewidth = 2;
            
            %% ------------------------------------------------- 
            Deg = this_Deg; %[0.25 0.5 1 2 4]
            IORthres = imgsizeO/visualdeg*Deg; %threshold as repeated fixations
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
            
            if save_Mat_IOR
                [propnt1, offsetnt1, propt1, offsett1, countpropntD, countpropntN, countproptD, countproptN] = fcn_MMevalInhibitionOfReturn(Firstx, Firsty, centerRx, centerRy, IORthres, IORthresT, type, imgvalid, 1, type);
                if save_Mat_bar_IOR
                    save(['IOR_NC/Mat/IOR_' type '.mat'],'propnt1', 'offsetnt1', 'propt1', 'offsett1','countpropntD', 'countpropntN', 'countproptD', 'countproptN');
                end
            end
            overallMeanS1 = []; overallStdS1 = [];
            offsettotalNT = [];
            all_countpropntD = []; all_countpropntN = []; all_countproptD = []; all_countproptN = []; 
            
            load(['Mat/IOR_' type '.mat']);
            offsetnt1(find(offsetnt1>MaxPlotFix)) = [];
            offsettotalNT = [offsettotalNT offsetnt1];
            
            
                all_countpropntD = [all_countpropntD countpropntD]; 
                all_countpropntN = [all_countpropntN countpropntN];
                all_countproptD  = [all_countproptD countproptD];
                all_countproptN  = [all_countproptN countproptN];
                
                
            [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
            Mpropnt1 = propnt;
            
            propnt1 = propnt;
            overallMeanS1 = [nanmean(propnt1)] * 100;
            overallStdS1 = [nanstd(propnt1)/sqrt(length(propnt1))]*100;
            display([type '; mean=' num2str(overallMeanS1) '; std=' num2str(overallStdS1)]);
            
            
            %% ------------------------------------------------- 
            fig3_fix_dva{su}.(type).(deg_str).fixations.countpropntD = all_countpropntD;
            fig3_fix_dva{su}.(type).(deg_str).fixations.countpropntN = all_countpropntN;
            fig3_fix_dva{su}.(type).(deg_str).fixations.countproptD  = all_countproptD;
            fig3_fix_dva{su}.(type).(deg_str).fixations.countproptN  = all_countproptN;            
            %% -------------------------------------------------
            
            %% show IOR prop (overall)
            hb = figure('Visible','off','Position',[288   207   85   258]); hold on;
            
            set(gca,'linewidth',2);
            load(['Mat/saccade_' type  '.mat']);
            chanceval = length(find(SIMNONRETURN_Radius<=Deg))/length(SIMNONRETURN_Radius);
            load(['Mat/' type '_chanceoffsetnt.mat']);
            %load(['Mat/' deg_str '_' type '_chanceoffsetnt'  '_s' num2str(su,'%02d') '.mat']);
            [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
            [h pnt ci stats] = ttest2(propnt,Mpropnt1);
            chanceval = mean(propnt);
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
            
            
            if pnt <= 0.05
                text(1,40, '*', 'Fontsize', 12, 'Fontweight', 'bold');
                % elseif pvalue <= 0.01
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
                % elseif pvalue <= 0.001
                %     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
            else
                text(1,40, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
            end
            
            
            %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(imgsizeO*imgsizeO)*100,'k:','LineWidth',2.5);
            plot([0:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2.5);
            
            bar([1],overallMeanS1,'FaceColor',[0    0    0],'LineWidth',1.5);
            %errorbar([1], overallMeanS1, overallStdS1,'k.');
            %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(imgsize*imgsize)*100,'k:','LineWidth',2.5);
            
            %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(imgsizeO*imgsizeO)*100,'k:','LineWidth',2.5);
            plot([0:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2.5);
            
            set(gca,'YTick',[0:0.1:0.4]*100,'FontSize',11);
            set(gca,'YTickLabel',{},'FontSize',12);
            set(gca,'XTick',[1],'FontSize',12);
            xlim([0.5 1.5]);
            ylim([0 40]);
            set(gca, 'TickDir', 'out');
            set(gca, 'Box','off');
            set(gca,'XTickLabelRotation',45);
            set(gca,'XTickLabel',{''},'FontSize',12);
            %xlabel('Inter Trial Interval','FontSize',14');
            %ylabel('Proportion (%)','FontSize',12);
            %legend({'Chance'},'FontSize',14);legend boxoff ;
            titlename = [type ';pnt=' num2str(pnt)];
            %title(titlename,'FontSize',14)
            set(hb,'Units','Inches');
            pos = get(hb,'Position');
            set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            print(hb,['Figures/Fig_IOR_first_overall_' type '_s' num2str(su,'%02d') '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);
            print(hb,['Figures/Fig_IOR_first_overall_' type '_s' num2str(su,'%02d') '_Deg_' num2str(Deg*100) printpostfix2],printmode2,printoption2); 
            
            
            %% ------------------------------------------------- 
            fig3_fix_dva{su}.(type).(deg_str).bar.overallMeanS1 = overallMeanS1;
            fig3_fix_dva{su}.(type).(deg_str).bar.overallStdS1 = overallStdS1;
            %     fig3_fix_dva.(type).(deg_str).bar.chancevalT = chancevalT*100;
            fig3_fix_dva{su}.(type).(deg_str).bar.chanceval = chanceval*100;
            %% -------------------------------------------------
            
            
            %% show IOR offset (overall)
            hb = figure('Visible','off'); hold on; set(hb,'Position',[308   368   127   117]);
            set(gca,'linewidth',2);
            
            if isempty(offsettotalNT)
                bincounts = zeros(size(binranges));
            else
                bincounts = histc(offsettotalNT,binranges);
                bincounts = bincounts/sum(bincounts);
            end
            %plot(binranges, bincounts,'Color',ColorList(3,:),'LineWidth',linewidth);
            plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');
            
            binc = bincounts*100;
            display([type '; 1st: ' num2str(binc(3)) ';first 3: ' num2str(sum(binc(3:5)))]);
            
            load(['Mat/' type '_chanceoffsetnt.mat']);
            %load(['Mat/' deg_str '_' type '_chanceoffsetnt'  '_s' num2str(su,'%02d') '.mat']);
            bincounts = histc(chanceoffsetnt,binranges);
            bincounts = bincounts/sum(bincounts);
            %plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle',':');
            %plot(binranges-1,ones(size(binranges-1))* 1/MaxPlotFix*100,'k:','LineWidth',linewidth);
            
            %legend({'Free-viewing','Chance'},'Location','northeast','FontSize',14);
            %legend({'Free-viewing'},'Location','northeast','FontSize',14);
            %legend boxoff ;
            xlim([1 MaxPlotFix]);
            set(gca,'XTick',xtickrange,'FontSize',11);
            ylim([0 1]*90);
            set(gca,'YTick',[0:30:90],'FontSize',11);
            set(gca,'YTickLabel',{},'FontSize',12);
            %set(gca,'YTick',[0:30:90],'FontSize',11);
            %xlabel('Returning Offset (Fixations)','FontSize',12);
            %ylabel('Distribution (%)','FontSize',12);
            %title(type,'FontSize', 14);
            set(gca, 'TickDir', 'out');
            set(gca, 'Box','off');
            set(hb,'Units','Inches');
            pos = get(hb,'Position');
            set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            print(hb,['Figures/Fig_IORoffsetFirstOnly_' type '_s' num2str(su,'%02d') '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);
            print(hb,['Figures/Fig_IORoffsetFirstOnly_' type '_s' num2str(su,'%02d') '_Deg_' num2str(Deg*100) printpostfix2],printmode2,printoption2); 
            
            
            %% ------------------------------------------------- 
            %     fig3_fix_dva.(type).(deg_str).plot.offsettotalT = offsettotalT;
            fig3_fix_dva{su}.(type).(deg_str).plot.offsettotalNT = offsettotalNT;
            fig3_fix_dva{su}.(type).(deg_str).plot.binranges = binranges;
            %% -------------------------------------------------
            
            close all
        end
    end
    
    save(['Figures/fig3_fix_dva_ego_' deg_str '.mat'],'fig3_fix_dva'); 
    
end