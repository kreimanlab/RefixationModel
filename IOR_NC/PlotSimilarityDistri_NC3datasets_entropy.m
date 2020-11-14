clear all; clc; close all;

type = 'naturaldesign'; %waldo, naturaldesign, array

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
   SimilarityName = 'Mat_FixationPatchArray_224';
   load(['Mat/GTRatioList_' type '.mat']);
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design
%     subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
%         'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
%         'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    SimilarityName = 'Mat_FixationPatchNaturalDesign_224';
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 80;
    xtickrange = [1 10:10:MaxPlotFix];
    SimilarityName = 'Mat_FixationPatchWaldo_224';
    
end
    
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);


[B,seqInd] = sort(seq);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;

linewidth  =2;
LayerSelected = 32; % 2 or 34

% %% comment out 
SIMRETURN = []; %target (R)
SIMNONRETURN = []; %target (NR)
SIMRATIO = [];%non-target (R vs NR)

for s = 1: length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    
    if ~strcmp(type,'array')
        Found = FixData.TargetFound;
        Found = Found(seqInd,:);
        Found = Found(1:NumStimuli/2,:);    
    end
    
    PosX = PosX(seqInd);
    PosY = PosY(seqInd);
        
    %all trials
    Firstx = PosX(1:NumStimuli/2);
    Firsty = PosY(1:NumStimuli/2);
    
    for i = 1:NumStimuli/2
        
       display(['processing ... subj: ' num2str(s) '; img: ' num2str(i) ]);
       fx = double(Firstx{i});
       fy = double(Firsty{i});
       
       if ~strcmp(type,'array')
            found = Found(i,:);
            if length(find(found == 1)) > 0
                found = 1;
            else
                found = 0;
            end
       else
           if length(find(fx == centerR(1,i) & fy == centerR(2,i))) > 0
               found = 1;
           else
               found = 0;
           end
       end
       
       
       
       % remove those trials with only one fixation
        if length(fx)== 1
            continue;            
        end
        
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
        if ~isempty(overlappairsnt)
            if length(fx) ~= overlappairsnt(1,3)            
                overlappairsnt = overlappairsnt +1;
                %overlappairst = overlappairst +1;
            end
        
            overlappairsnt = overlappairsnt(:,1:2);
            %overlappairsnt = overlappairsnt + 1;
            overlappairsnt = overlappairsnt(:);
        end
        if ~isempty(overlappairst)            
            if length(fx) ~= overlappairst(1,3)            
                %overlapnt = overlapnt +1;
                overlappairst = overlappairst +1;
            end
            
            overlappairst = overlappairst(:,1:2);
            %overlappairst = overlappairst + 1;
            overlappairst = overlappairst(:);
        end
        
        %overlap = [overlappairst; overlappairsnt];
        %overlap = unique(overlap);
        overlapnt = [overlappairsnt];
        overlapt = [overlappairst];
        overlapnt = unique(overlapnt);
        overlapt = unique(overlapt);
        
        
        
        if strcmp(type, 'array')
            sim = [];
            for j = 1:length(fx)-1
                filename = [SimilarityName '/' subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '_entropy.mat'];
                if exist(filename, 'file') ~= 2
                    sim = [];
                    break;
                end
                siml = load(filename);
                entropy = double(siml.x);
                entropy = -sum(log2(entropy).*entropy);
                sim = [sim double(entropy)];
            end
            sim = [nan sim];
            if ~isempty(sim)
                sim = sim(1:end);
                %sim = softmax(sim')';
            end
        else
            sim = [];
            for j = 1:length(fx)
                filename = [SimilarityName '/' subjlist{s} '_stimuli_' num2str(i) '_patch_' num2str(j) '_entropy.mat'];
                if exist(filename, 'file') ~= 2
                    sim = [];
                    break;
                end
                siml = load(filename);
                entropy = double(siml.ps);
                entropy = -sum(log2(entropy).*entropy);
                sim = [sim double(entropy)];
            end
            
%             if ~isempty(sim)
%                 sim = sim(2:end);
%                 %sim = softmax(sim')';
%             end
        end
        
        if ~isempty(sim)
            
            if found == 1
                
                if isempty(overlapt)     
                    SIMNONRETURN = [SIMNONRETURN sim(end)];                    
                    temp1 = nanmean(sim(overlapnt));
                    sim(overlapnt) = [];
                    sim(end) = [];
                    temp2 = nanmean(sim);
                    if ~isnan(temp1) && ~isnan(temp2) && temp2~=0                        
                        SIMRATIO = [SIMRATIO temp1/temp2];
                    end
                else
                    SIMRETURN = [SIMRETURN mean(sim(overlapt))];
                    temp1 = nanmean(sim(overlapnt));
                    sim(unique([overlapnt;overlapt])) = [];
                    temp2 = nanmean(sim);
                    if ~isnan(temp1) && ~isnan(temp2) && temp2~=0                        
                        SIMRATIO = [SIMRATIO temp1/temp2];
                    end
                end              
                
            else
                temp1 = nanmean(sim(overlapnt));
                sim(overlapnt) = [];
                temp2 = nanmean(sim);               
                SIMRATIO = [SIMRATIO temp1/temp2];
            end
        end
        
    end
    
end
SIMRETURN(isnan(SIMRETURN)) = []; 
SIMNONRETURN(isnan(SIMNONRETURN)) = [];
SIMRATIO(isnan(SIMRATIO)) = [];
save(['Mat/entropy_' type '.mat'],'SIMRETURN','SIMNONRETURN','SIMRATIO');
%%

hb = figure; hold on;
load(['Mat/entropy_' type '.mat']);
MAX = max([max(SIMRETURN) max(SIMNONRETURN)]);
mean(SIMRETURN)
mean(SIMNONRETURN)
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
xlabel(['Similarity (Layer = ' num2str(LayerSelected) ')'],'FontSize',14);
ylabel('Distribution (%)','FontSize',14);
title([type '; m(R)=' num2str(mean(SIMRETURN)) '; m(NR)=' num2str(mean(SIMNONRETURN))],'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/Entropy_' type  printpostfix],printmode,printoption);

%% ratio plot
hb = figure; hold on;
load(['Mat/entropy_' type '.mat']);
SIMRATIO(isnan(SIMRATIO)) = [];
MAX = 2;%max(SIMRATIO);
BINNUM = 100;
binranges = [0:MAX/BINNUM:MAX];
bincounts = histc(SIMRATIO,binranges);
bincounts = bincounts/sum(bincounts);
plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);

plot(ones(1,16), [0:15],'k--','LineWidth',linewidth);
legend({'Ratio (R vs NR)','Chance'},'Location','northeast','FontSize',14);
legend boxoff ;
xlim([0 2]);
%set(gca,'XTick',xtickrange);
%ylim([0 1]*80);
xlabel(['Similarity (Layer = ' num2str(LayerSelected) ')'],'FontSize',14);
ylabel('Distribution (%)','FontSize',14);
title([type '; Ratio(<1) =' num2str(length(find(SIMRATIO<1))) '; Ratio(>1) = ' num2str(length(find(SIMRATIO>1)))],'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/EntropyRatio_' type printpostfix],printmode,printoption);









