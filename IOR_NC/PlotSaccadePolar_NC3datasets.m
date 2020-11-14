clear all; close all; clc;
addpath('polarPcolor');

TYPELIST = {'array','naturaldesign','waldo','naturalsaliency'};

for T = 1:length(TYPELIST)

type = TYPELIST{T}; 
%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
   MaxPlotFix = 6; 
   xtickrange = [1:MaxPlotFix];
   SimilarityName = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliency/';
   
    %remap to real display in klab
    fix1 = [490 772];
    fix2 = [340 512];
    fix3 = [490 252];
    fix4 = [790 252];
    fix5 = [940 512];
    fix6 = [790 772];
    fixC = [fix1; fix2; fix3; fix4; fix5; fix6];

    %scanpath processed coordinates
    fix1 = [365 988 0 ];
    fix2 = [90 512 0];
    fix3 = [365 36 0];
    fix4 = [915 36 0];
    fix5 = [1190 512 0];
    fix6 = [915 988 0];
    fixO = [fix1; fix2; fix3; fix4; fix5; fix6];
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    SimilarityName = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliency_naturaldesign/';
    
elseif strcmp(type, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
        'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    SimilarityName = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliency_naturaldesign/';
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 80;
    xtickrange = [1 10:10:MaxPlotFix];
    SimilarityName = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliency_croppedWaldo/';
    
end
    
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);


[B,seqInd] = sort(seq);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
w = Imgw;
Imgh  = 1280;
h = Imgh;
receptiveSize = 45;
RadiusDegConvert = 43;

linewidth  =2;

% %% comment out 
SIMRETURN_Radius = []; SIMNONRETURN_Radius = []; SIMRETURN2_Radius = [];
SIMRETURN_Angle = []; SIMNONRETURN_Angle = []; SIMRETURN2_Angle = [];

SIMRETURN_subj = []; SIMNONRETURN_subj = [];  SIMRETURN2_subj = [];

for s = 1: length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    PosX = PosX(seqInd);
    PosY = PosY(seqInd);
    
    %all trials
    Firstx = PosX(1:NumStimuli/2);
    Firsty = PosY(1:NumStimuli/2);
    
    for i = 1:NumStimuli/2
        
       display(['processing ... subj: ' num2str(s) '; img: ' num2str(i) ]);
       fx = double(Firstx{i});
       fy = double(Firsty{i});
       
       % remove those trials with only one fixation
        if length(fx)== 1
            continue;            
        end
        
        if strcmp(type, 'array')
            %conver to actual coordinates in saliency maps
            posxcopy = fx;
            posycopy = fy;

            for ctype = 1:size(fixC,1)
                fx(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,1);
                fy(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,2);
            end
        end
        
        fx = fx(2:end);
        fy = fy(2:end);
        fx(find(isnan(fx))) = [];
        fy(find(isnan(fy))) = [];
        if isempty(fx)
            %invalid human trial
            continue;
        end
        
        
        
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
%         overlappairsnt
%         overlappairst
        
        sim_R_radius = [];  
        sim_R_angle = []; 
        sim_R_radius2 = [];  
        sim_R_angle2 = [];
        sim_NR_radius = [];  
        sim_NR_angle = []; 
        
        %% saccade at to-be-revisted fixations
        if ~isempty(overlappairsnt)
            overlappairsnt = overlappairsnt(:,2);
            %overlappairsnt = overlappairsnt + 1;
            %overlappairsnt = overlappairsnt(:);
            
            for ss = 1:size(overlappairsnt)
                
                if overlappairsnt(ss,1) >= 2
                
                    sim_R_radius = [sim_R_radius norm([fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)])]; 

                    if overlappairsnt(ss,1) <= 2
                        u = [[fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] 0];
                        v = [[fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] - [w/2 h/2] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                    else
                        u = [[fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] 0];
                        v = [[fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] - [fx(overlappairsnt(ss,1)-2) fy(overlappairsnt(ss,1)-2)] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                    end
                    sim_R_angle =[sim_R_angle ThetaInDegrees];
                end
            end
            
        end
        if ~isempty(overlappairst)
            overlappairst = overlappairst(:,2);
            %overlappairst = overlappairst + 1;
            %overlappairst = overlappairst(:);
            
            for ss = 1:size(overlappairst)
                
                if overlappairst(ss,1)>=2
                
                    sim_R_radius = [sim_R_radius norm([fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)])]; 
                    if overlappairst(ss,1) <= 2
                        u = [[fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] 0];
                        v = [[fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] - [w/2 h/2] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v));
                    else
                        u = [[fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] 0];
                        v = [[fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] - [fx(overlappairst(ss,1)-2) fy(overlappairst(ss,1)-2)] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                    end                
                    sim_R_angle =[sim_R_angle ThetaInDegrees];
                end
            end
        end
        
        %% saccade at return fixations
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
        if ~isempty(overlappairsnt)
            overlappairsnt = overlappairsnt(:,1);
            %overlappairsnt = overlappairsnt + 1;
            %overlappairsnt = overlappairsnt(:);
            
            for ss = 1:size(overlappairsnt)
                
                if overlappairsnt(ss,1) >= 2
                
                    sim_R_radius2 = [sim_R_radius2 norm([fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)])]; 
                    if overlappairsnt(ss,1) <= 2
                        u = [[fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] 0];
                        v = [[fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] - [w/2 h/2] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                    else
                        u = [[fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] 0];
                        v = [[fx(overlappairsnt(ss,1)-1) fy(overlappairsnt(ss,1)-1)] - [fx(overlappairsnt(ss,1)-2) fy(overlappairsnt(ss,1)-2)] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                    end 
                    sim_R_angle2 =[sim_R_angle2 ThetaInDegrees];
                end
            end
            
        end
        if ~isempty(overlappairst)
            overlappairst = overlappairst(:,1);
            %overlappairst = overlappairst + 1;
            %overlappairst = overlappairst(:);
            
            for ss = 1:size(overlappairst)
                
                if overlappairst(ss,1) >= 2
                
                    sim_R_radius2 = [sim_R_radius2 norm([fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)])]; 
                    if overlappairst(ss,1) <= 2
                        u = [[fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] 0];
                        v = [[fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] - [w/2 h/2] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v));
                    else
                        u = [[fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] 0];
                        v = [[fx(overlappairst(ss,1)-1) fy(overlappairst(ss,1)-1)] - [fx(overlappairst(ss,1)-2) fy(overlappairst(ss,1)-2)] 0];
                        ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                    end
                    sim_R_angle2 =[sim_R_angle2 ThetaInDegrees];
                end
            end
        end       
        
        %% saccade at non-return
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
        
        overlap = [];
        if ~isempty(overlappairst)
            overlap = [overlap overlappairst(:,1:2)];            
        end
        if ~isempty(overlappairsnt)
            overlap = [overlap; overlappairsnt(:,1:2)];
        end
        overlap = unique(overlap);
        
        for ss = 2:length(fx)
            
            if length(find(overlap == ss)) >= 1
                continue;
            end
            
            sim_NR_radius = [sim_NR_radius norm([fx(ss) fy(ss)] - [fx(ss-1) fy(ss-1)])]; 
            
            if ss > 2
                u = [[fx(ss) fy(ss)] - [fx(ss-1) fy(ss-1)] 0];
                v = [[fx(ss-1) fy(ss-1)] - [fx(ss-2) fy(ss-2)] 0];
                ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                sim_NR_angle =[sim_NR_angle ThetaInDegrees];
            else
                u = [[fx(ss) fy(ss)] - [fx(ss-1) fy(ss-1)] 0];
                v = [[fx(ss-1) fy(ss-1)] - [w/2 h/2] 0];
                ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                sim_NR_angle =[sim_NR_angle ThetaInDegrees];
            end
        end
        
        SIMRETURN_Radius = [SIMRETURN_Radius sim_R_radius];
        SIMRETURN_Angle = [SIMRETURN_Angle sim_R_angle];
        SIMRETURN_subj = [SIMRETURN_subj s*ones(1, length(sim_R_radius) ) ];
        
        SIMRETURN2_Radius = [SIMRETURN2_Radius sim_R_radius2];
        SIMRETURN2_Angle = [SIMRETURN2_Angle sim_R_angle2];
        SIMRETURN2_subj = [SIMRETURN2_subj s*ones(1, length(sim_R_radius2) ) ];
        
        SIMNONRETURN_Angle = [SIMNONRETURN_Angle sim_NR_angle];
        SIMNONRETURN_Radius = [SIMNONRETURN_Radius sim_NR_radius];   
        SIMNONRETURN_subj = [SIMNONRETURN_subj s*ones(1, length(sim_NR_radius) ) ];
        
    end
    
end
SIMRETURN_Radius = SIMRETURN_Radius/RadiusDegConvert;
SIMRETURN2_Radius = SIMRETURN2_Radius/RadiusDegConvert;
SIMNONRETURN_Radius= SIMNONRETURN_Radius/RadiusDegConvert;

IORthresT = 0.5;

SIMRETURN_subj(find(SIMRETURN_Radius < IORthresT)) = [];
SIMRETURN_Angle(find(SIMRETURN_Radius < IORthresT)) = [];
SIMRETURN_Radius(find(SIMRETURN_Radius < IORthresT)) = [];

SIMRETURN2_subj(find(SIMRETURN2_Radius < IORthresT)) = [];
SIMRETURN2_Angle(find(SIMRETURN2_Radius < IORthresT)) = [];
SIMRETURN2_Radius(find(SIMRETURN2_Radius < IORthresT)) = [];

SIMNONRETURN_subj(find(SIMNONRETURN_Radius < IORthresT)) = [];
SIMNONRETURN_Angle(find(SIMNONRETURN_Radius < IORthresT)) = [];
SIMNONRETURN_Radius(find(SIMNONRETURN_Radius < IORthresT)) = [];

save(['Mat/saccade_' type  '.mat'],'SIMRETURN_Radius','SIMRETURN_Angle',...
    'SIMRETURN2_Radius','SIMRETURN2_Angle','SIMNONRETURN_Angle','SIMNONRETURN_Radius',...
    'SIMRETURN_subj','SIMRETURN2_subj','SIMNONRETURN_subj');


%hb = figure; hold on;
load(['Mat/saccade_' type '.mat']);

% %% return saccade (polar plot)
% R = linspace(0,40,5);
% theta = linspace(0,180,60);
% Z = hist3([SIMRETURN_Radius' SIMRETURN_Angle'],'Ctrs',{R theta});
% Z = Z/sum(sum(Z));
% hb = figure;
% polarPcolor(R,theta,Z,'Ncircles',10)
% title('Polar for Return Fixations');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% %print(hb,['Figures/Saccade_RF_' type printpostfix],printmode,printoption);
% 
% %hb = figure; hold on;
% load(['Mat/saccade_' type '.mat']);
% 
% %% overall saccade (polar plot)
% R = linspace(0,40,5);
% theta = linspace(0,180,60);
% Z = hist3([SIMNONRETURN_Radius' SIMNONRETURN_Angle'],'Ctrs',{R theta});
% Z = Z/sum(sum(Z));
% hb = figure;
% polarPcolor(R,theta,Z,'Ncircles',10)
% title('Polar for All Fixations');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% %print(hb,['Figures/Saccade_NRF_' type printpostfix],printmode,printoption);
% 
% %% draw amplitude distribution (histogram)
% hb = figure; hold on;
% binranges = [0:2:40];
% bincounts = histc(SIMRETURN_Radius,binranges);
% bincounts = bincounts/sum(bincounts);    
% plot(binranges, bincounts*100,'Color','r','LineWidth',linewidth,'LineStyle','--');
% bincounts = histc(SIMNONRETURN_Radius,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth,'LineStyle','--');
% legend({'Return fixations','Non-return fixations'},'Location','northeast','FontSize',14);
% legend boxoff ;
% xlim([0 40]);
% xtickrange = [0:5:40];
% set(gca,'XTick',xtickrange);
% yaxislim = [0 80];
% ylim(yaxislim);
% xlabel('Saccade size (deg)','FontSize',14);
% ylabel('Distribution (%)','FontSize',14);
% [h pval] = ttest2(SIMRETURN_Radius, SIMNONRETURN_Radius);
% title([type '; p = ' num2str(pval)],'FontSize', 14);
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% %print(hb,['Figures/Saccade_NR_R_saccade_' type  printpostfix],printmode,printoption);

%% draw amplitude distribution (bar plots)
hb = figure; hold on;
set(gca,'linewidth',2);
M = [mean(SIMRETURN_Radius) mean(SIMRETURN2_Radius) mean(SIMNONRETURN_Radius)];
Mstd = [std(SIMRETURN_Radius)/sqrt(length(SIMRETURN_Radius)) std(SIMRETURN2_Radius)/sqrt(length(SIMRETURN2_Radius)) std(SIMNONRETURN_Radius)/sqrt(length(SIMNONRETURN_Radius))];
bar([1],M(1),'FaceColor',[0.8020    0.8020    0.8020],'LineStyle','--','LineWidth',1.5);
errorbar([1], M(1), Mstd(1),'k.');
bar([2],M(2),'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
errorbar([2], M(2), Mstd(2),'k.');
bar([3],M(3),'FaceColor',[0.8020    0.8020    0.8020],'LineWidth',1.5);
errorbar([3], M(3), Mstd(3),'k.');

xlim([0.5 3.5]);
xtickrange = [1:3];
set(gca,'XTick',xtickrange,'FontSize',11);
if strcmp(type,'array')
    ylabel({'Saccade';'Size (dva)'},'FontSize',10);
    set(gca,'XTickLabel',{'To-be-revisited','Return','Non-Return'},'FontSize',10);
    set(gca,'XTickLabelRotation',45);
else
    set(gca,'XTickLabel',{},'FontSize',12);
    set(gca,'YTickLabel',{},'FontSize',12);
end
yaxislim = [0 15.5];
ytickrange = [0:5:15];
set(gca,'YTick',ytickrange,'FontSize',11);
ylim(yaxislim);

[a p1] = ttest2(SIMRETURN_Radius, SIMNONRETURN_Radius);
[a p2] = ttest2(SIMRETURN2_Radius, SIMNONRETURN_Radius);
[a p3] = ttest2(SIMRETURN2_Radius, SIMRETURN_Radius);
%title([type '; p = ' num2str(pval)],'FontSize', 14);


if p3 <= 0.05
    text(1.35,13.6, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([1 1.7],[14.4 14.4],'k','LineWidth',2.5);
    fcn_sigstar(1,1.7,13.0,0.03);
else
%     text(1.2,430, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
%     plot([1 1.7],[420 420],'k','LineWidth',2.5);
end

if p2 <= 0.05
    text(2.65,13.6, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([2.3 3],[14.4 14.4],'k','LineWidth',2.5);
    fcn_sigstar(2.3,3,13.0,0.03);
else
    %text(2.5,430, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([2.3 3],[420 420],'k','LineWidth',2.5);
end

if p1 <= 0.05
    text(2,15.6, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([1 3],[15.2 15.2],'k','LineWidth',2.5);
    fcn_sigstar(1,3,15.2,0.03);
else
    %text(1.8,455, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
    %plot([1 3],[445 445],'k','LineWidth',2.5);
end


set(gca, 'TickDir', 'out');
set(gca, 'Box','off');

if strcmp(type,'array')
    set(hb,'Position',[303   268   177   212]);
else
    set(hb,'Position',[303   363   122   117]);
end
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/Saccade_NR_R_saccade_barplot_' type  printpostfix],printmode,printoption);

end














