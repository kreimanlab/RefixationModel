clear all; clc; close all;

addpath('polarPcolor');

TYPELIST = {'wmonkey','cmonkey'};

for T = 1:length(TYPELIST)
    
    type = TYPELIST{T}; %egteaplus, os
    
    %note: three datasets have not re-sequentalized; reorder first!
    % the first fixation is always the center; remove the first fix!
    % the reaction time lasts from the first fix to the trial start!
    if strcmp(type, 'cmonkey')
        imgsize = 596;
        ImgFolder = '/home/mengmi/Desktop/saliency/monkey_eyetracking/AllStimuli/';
        visualdeg=39.7;
    else
        imgsize = 596;
        ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli/';
        visualdeg=39.7*imgsize/635;
    end
    
    load(['Mat/' type '_Fix.mat']);
    printpostfix = '.eps';
    printmode = '-depsc'; %-depsc
    printoption = '-r200'; %'-fillpage'
    
    if 1
        
        Imgw = imgsize;
        Imgh = imgsize;
        
        linewidth  =2;
        
        %% comment out
        SIMRETURN_subj = []; SIMNONRETURN_subj = [];  SIMRETURN2_subj = [];
        SIMRETURN = []; SIMNONRETURN = []; SIMRETURN2 = [];
        PosX = Fix_posx;
        PosY = Fix_posy;
        Time = Fix_time;
        
        
        %all trials
        Firstx = PosX;
        Firsty = PosY;
        FirstTime = Time;
        
        for i = 1:length(Firstx)
            
            display(['processing ... ; img: ' num2str(i) ]);
            fx = double(Firstx{i});
            fy = double(Firsty{i});
            ft = double(FirstTime{i});
            
            % remove those trials with only one fixation
            if length(fx)== 1
                continue;
            end
            
            load(['Mat_IOR_' type '/' type '_stimuli_' num2str(i) '.mat']);
            if ~isempty(overlappairsnt)
                if length(fx) ~= overlappairsnt(1,3)
                    overlappairsnt = overlappairsnt +1;
                    %overlappairst = overlappairst +1;
                end
                overlappairsnt = overlappairsnt(:,2);
                %overlappairsnt = overlappairsnt + 1;
                overlappairsnt = overlappairsnt(:);
            end
            if ~isempty(overlappairst)
                if length(fx) ~= overlappairst(1,3)
                    %overlapnt = overlapnt +1;
                    overlappairst = overlappairst +1;
                end
                overlappairst = overlappairst(:,2);
                %overlappairst = overlappairst + 1;
                overlappairst = overlappairst(:);
            end
            
            overlap = [overlappairst; overlappairsnt];
            overlap = unique(overlap);
            
            load(['Mat_IOR_' type '/' type '_stimuli_' num2str(i) '.mat']);
            if ~isempty(overlappairsnt)
                if length(fx) ~= overlappairsnt(1,3)
                    overlappairsnt = overlappairsnt +1;
                    %overlappairst = overlappairst +1;
                end
                overlappairsnt = overlappairsnt(:,1);
                %overlappairsnt = overlappairsnt + 1;
                overlappairsnt = overlappairsnt(:);
            end
            if ~isempty(overlappairst)
                if length(fx) ~= overlappairst(1,3)
                    %overlapnt = overlapnt +1;
                    overlappairst = overlappairst +1;
                end
                overlappairst = overlappairst(:,1);
                %overlappairst = overlappairst + 1;
                overlappairst = overlappairst(:);
            end
            
            overlap2 = [overlappairst; overlappairsnt];
            overlap2 = unique(overlap2);
            
            sim = [];
            %ftdiff = diff(ft);
            %ftdiff = [ft(1) ftdiff];
            %sim = ftdiff;
            sim = ft;
            if strcmp(type, 'wmonkey')
                sim(1) = nan;
                %         sim(2) = nan;
                %         sim(end) = nan;
            end
            
            if strcmp(type, 'wmonkey')
                overlap(find(overlap == 1)) = [];
                overlap2(find(overlap2 == 1)) = [];
            end
            
            if ~isempty(sim)
                s = Fix_subj{i};
                SIMRETURN = [SIMRETURN sim(overlap)];
                SIMRETURN_subj = [SIMRETURN_subj  s*ones(1, length(sim(overlap)) ) ];
                SIMRETURN2 = [SIMRETURN2 sim(overlap2)];
                SIMRETURN2_subj = [SIMRETURN2_subj s*ones(1, length(sim(overlap2)) ) ];
                
                if strcmp(type, 'wmonkey')
                    overlap3 = unique([overlap; overlap2; 1]);
                else
                    overlap3 = unique([overlap; overlap2]);
                end
                sim(overlap3) = [];
                SIMNONRETURN = [SIMNONRETURN sim];
                SIMNONRETURN_subj = [SIMNONRETURN_subj s*ones(1, length(sim) ) ];
            end
            
        end
        
        SIMRETURN_subj(isnan(SIMRETURN)) = [];
        SIMRETURN2_subj(isnan(SIMRETURN2)) = [];
        SIMNONRETURN_subj(isnan(SIMNONRETURN)) = [];
        
        SIMRETURN(isnan(SIMRETURN)) = [];
        SIMRETURN2(isnan(SIMRETURN2)) = [];
        SIMNONRETURN(isnan(SIMNONRETURN)) = [];
        
        save(['IOR_NC/Mat/ReturnFixDuration_' type  '.mat'],'SIMRETURN', 'SIMRETURN2','SIMNONRETURN','SIMRETURN_subj','SIMRETURN2_subj','SIMNONRETURN_subj');
        save(['Figures/data_fixduration_' type  '.mat']     ,'SIMRETURN', 'SIMRETURN2','SIMNONRETURN','SIMRETURN_subj','SIMRETURN2_subj','SIMNONRETURN_subj');

    
    end

    
    %% bar plot and report stats
    hb = figure; hold on;
    set(gca,'linewidth',2);
    
    load(['Mat/ReturnFixDuration_' type  '.mat']);
    bar([1],nanmean(SIMRETURN),'FaceColor',[0.8020    0.8020    0.8020],'LineStyle','--','LineWidth',1.5);
    errorbar([1], nanmean(SIMRETURN), nanstd(SIMRETURN)/sqrt(length(SIMRETURN)),'k.');
    bar([2],nanmean(SIMRETURN2),'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
    errorbar([2], nanmean(SIMRETURN2), nanstd(SIMRETURN2)/sqrt(length(SIMRETURN2)),'k.');
    bar([3],nanmean(SIMNONRETURN),'FaceColor',[0.8020    0.8020    0.8020],'LineWidth',1.5);
    errorbar([3], nanmean(SIMNONRETURN), nanstd(SIMNONRETURN)/sqrt(length(SIMNONRETURN)),'k.');
    set(gca,'XTick',[1 2 3],'FontSize',11);
    xlim([0.5 3.5]);
    %set(gca,'XTickLabel',{'To-be-revisited','Return','Non-Return'},'FontSize',12);
    set(gca,'XTickLabel',{},'FontSize',12);
    set(gca,'YTickLabel',{},'FontSize',12);
    
    set(gca,'XTickLabelRotation',45);
    set(gca,'YTick',[0:100:450],'FontSize',11);
    ylim([0 450]);
    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');
    %xlabel('Inter Trial Interval','FontSize',14');
    %ylabel('Fixation Duration (ms)','FontSize',12);
    %legend({'Chance'},'FontSize',14);legend boxoff ;
    [a p1] = ttest2(SIMRETURN, SIMNONRETURN);
    [a p2] = ttest2(SIMRETURN2, SIMNONRETURN);
    [a p3] = ttest2(SIMRETURN2, SIMRETURN);
    
    if p3 <= 0.05
        text(1.25,395, '*', 'Fontsize', 11, 'Fontweight', 'bold');
        %plot([1 1.7],[425 425],'k','LineWidth',2.5);
        fcn_sigstar(1,1.7,380,0.03);
    else
        %     text(1.2,430, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
        %     plot([1 1.7],[420 420],'k','LineWidth',2.5);
    end
    
    if p2 <= 0.05
        text(2.6,395, '*', 'Fontsize', 11, 'Fontweight', 'bold');
        %plot([2.3 3],[425 425],'k','LineWidth',2.5);
        fcn_sigstar(2.3,3,380,0.03);
    else
        %     text(2.5,430, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
        %     plot([2.3 3],[420 420],'k','LineWidth',2.5);
    end
    
    if p1 <= 0.05
        text(2,450, '*', 'Fontsize', 11, 'Fontweight', 'bold');
        %plot([1 3],[445 445],'k','LineWidth',2.5);
        fcn_sigstar(1,3,435,0.03);
    else
        %     text(1.8,455, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
        %     plot([1 3],[445 445],'k','LineWidth',2.5);
    end
    
    titlename = [type ': stats p(1,2)=' num2str(p3) '; stats p(1,3)=' num2str(p1) '; stats p(2,3)=' num2str(p2)];
    %title(titlename,'FontSize',14);
    set(hb,'Position',[303   363   122   117]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['Figures/ReturnFixationDurationBarPlot_' type printpostfix],printmode,printoption);
    
end
