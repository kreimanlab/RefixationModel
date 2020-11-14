clear all; close all; clc;
addpath('polarPcolor');

type = 'array'; %waldo, naturalsaliency, naturaldesign, array

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
    
    yaxislim = [0 60];
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    SimilarityName = '/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliency_naturaldesign/';
    
    yaxislim = [0 20];
    
elseif strcmp(type, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc'}; %natural design
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
    
    yaxislim = [0 20];
end
    
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);
load(['Mat/GTRatioList_' type '.mat'],'centerR'); %centerR(1,:) horizontal 1280; centerR size: 2 by 300,240,67

if strcmp(type, 'array')
    %conver to actual coordinates in saliency maps
    posxcopy = centerR(1,:);
    posycopy = centerR(2,:);
    fx = centerR(1,:);
    fy = centerR(2,:);
    
    for ctype = 1:size(fixC,1)
        fx(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,1);
        fy(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,2);
    end
    
    centerR(1,:) = fx;
    centerR(2,:) = fy;
end

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
RadiusDegConvert = 156/5;

linewidth  =2;

%% comment out 
SIMRETURN_Radius = []; SIMNONRETURN_Radius = [];
SIMRETURN_Angle = []; SIMNONRETURN_Angle = [];

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
       
       ctrx = centerR(1,i);
       ctry = centerR(2,i);
       
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
        
        sim_R_radius = [];  
        sim_R_angle = [];  
        sim_NR_radius = [];  
        sim_NR_angle = []; 
        
        if ~isempty(overlappairsnt)
            overlappairsnt = overlappairsnt(:,1:2);
            %overlappairsnt = overlappairsnt + 1;
            %overlappairsnt = overlappairsnt(:);
            
            for ss = 1:size(overlappairsnt)
                sim_R_radius = [sim_R_radius norm([fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [ctrx ctry])]; 
                u = [[fx(overlappairsnt(ss,1)) fy(overlappairsnt(ss,1))] - [ctrx ctry] 0];
                v = [1 0 0];%angle wrt the horizontal x-aixs
                ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
                sim_R_angle =[sim_R_angle ThetaInDegrees];
            end
            
        end
%         if ~isempty(overlappairst)
%             overlappairst = overlappairst(:,1:2);
%             %overlappairst = overlappairst + 1;
%             %overlappairst = overlappairst(:);
%             
%             for ss = 1:size(overlappairst)
%                 sim_R_radius = [sim_R_radius norm([fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [ctrx ctry])]; 
%                 u = [[fx(overlappairst(ss,1)) fy(overlappairst(ss,1))] - [ctrx ctry] 0];
%                 v = [1 0 0];%angle wrt the horizontal x-aixs
%                 ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
%                 sim_R_angle =[sim_R_angle ThetaInDegrees];
%             end
%         end
        
        %overlap = [overlappairst; overlappairsnt];
        %overlap = unique(overlap);
        
        for ss = 1:length(fx)
            sim_NR_radius = [sim_NR_radius norm([fx(ss) fy(ss)] - [ctrx ctry])]; 
            u = [[fx(ss) fy(ss)] - [ctrx ctry] 0];
            v = [1 0 0];%angle wrt the horizontal x-aixs
            ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v)); 
            sim_NR_angle =[sim_NR_angle ThetaInDegrees];            
        end
        
        SIMRETURN_Radius = [SIMRETURN_Radius sim_R_radius];
        SIMRETURN_Angle = [SIMRETURN_Angle sim_R_angle];
        
        SIMNONRETURN_Angle = [SIMNONRETURN_Angle sim_NR_angle];
        SIMNONRETURN_Radius = [SIMNONRETURN_Radius sim_NR_radius];            
        
    end
    
end
SIMRETURN_Radius = SIMRETURN_Radius/RadiusDegConvert;
SIMNONRETURN_Radius= SIMNONRETURN_Radius/RadiusDegConvert;

IORthresT = 133/2/(156/5);
SIMRETURN_Angle(find(SIMRETURN_Radius < IORthresT)) = [];
SIMRETURN_Radius(find(SIMRETURN_Radius < IORthresT)) = [];
SIMNONRETURN_Angle(find(SIMNONRETURN_Radius < IORthresT)) = [];
SIMNONRETURN_Radius(find(SIMNONRETURN_Radius < IORthresT)) = [];
save(['Mat/saccade_withTarget_' type  '.mat'],'SIMRETURN_Radius','SIMRETURN_Angle','SIMNONRETURN_Angle','SIMNONRETURN_Radius');


load(['Mat/saccade_withTarget_' type '.mat']);

%% return saccade
R = linspace(0,40,5);
theta = linspace(0,180,60);
Z = hist3([SIMRETURN_Radius' SIMRETURN_Angle'],'Ctrs',{R theta});
Z = Z/sum(sum(Z));
hb = figure;
polarPcolor(R,theta,Z,'Ncircles',10)
title('Polar for RF (wrt Targets)');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/Saccade_RF_WithTarget_' type printpostfix],printmode,printoption);

%hb = figure; hold on;
load(['Mat/saccade_withTarget_' type '.mat']);

%% overall saccade
R = linspace(0,40,5);
theta = linspace(0,180,60);
Z = hist3([SIMNONRETURN_Radius' SIMNONRETURN_Angle'],'Ctrs',{R theta});
Z = Z/sum(sum(Z));
hb = figure;
polarPcolor(R,theta,Z,'Ncircles',10)
title('Polar for NT-AllFix (wrt Targets)');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/Saccade_NRF_WithTarget_' type printpostfix],printmode,printoption);

%% draw amplitude distribution
hb = figure; hold on;
binranges = [0:2:40];
bincounts = histc(SIMRETURN_Radius,binranges);
bincounts = bincounts/sum(bincounts);    
plot(binranges, bincounts*100,'Color','r','LineWidth',linewidth,'LineStyle','--');
bincounts = histc(SIMNONRETURN_Radius,binranges);
bincounts = bincounts/sum(bincounts);
plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth,'LineStyle','--');
legend({'Return fixations','All non-target fixations'},'Location','northeast','FontSize',14);
legend boxoff ;
xlim([0 40]);
xtickrange = [0:5:40];
set(gca,'XTick',xtickrange);
ylim(yaxislim);
xlabel('Dist WRT targets (deg)','FontSize',14);
ylabel('Distribution (%)','FontSize',14);
[h pval] = ttest2(SIMRETURN_Radius, SIMNONRETURN_Radius);
title([type '; p = ' num2str(pval)],'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/RF_wrt_Targets_' type  printpostfix],printmode,printoption);



