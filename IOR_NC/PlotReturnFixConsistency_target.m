clear all; clc; close all;

type = 'array'; %waldo, naturaldesign, array

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
   %SimilarityName = 'Mat_FixationPatchArray_224';
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    %SimilarityName = 'Mat_FixationPatchNaturalDesign_224';
        
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 80;
    xtickrange = [1 10:10:MaxPlotFix];
    %SimilarityName = 'Mat_FixationPatchWaldo_224';
    
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

% %% comment out 
% SIMRETURN = [];
% 
% for i = 1:NumStimuli/2
%     i
%     totalcounter = 0;
%     totalvalid = 0;
%     for s = 1: length(subjlist)
%         load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
%         PosX = FixData.Fix_posx;
%         PosY = FixData.Fix_posy;        
% 
%         PosX = PosX(seqInd);
%         PosY = PosY(seqInd);        
%         
%         if length(PosX) ~= NumStimuli
%             continue;
%         else
%             totalvalid = totalvalid + 1;
%         end
%         
%         load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
%         if ~isempty(overlappairst)
%             totalcounter = totalcounter + 1;
%         end
%     end
%     
%     if totalcounter ~= 0 
%         %SIMRETURN = [SIMRETURN; totalcounter/totalvalid];
%         SIMRETURN = [SIMRETURN; totalcounter];
%     end
%     
% end
% 
% save(['Mat/ReturnFixConsistency_target_' type  '.mat'],'SIMRETURN','totalvalid');


load(['Mat/ReturnFixConsistency_target_' type  '.mat']);

%calculate chance probability here
MAX = totalvalid;
p = sum(SIMRETURN)/(MAX*NumStimuli/2); %probability of having return fixations in each trial
chance = binopdf([1:MAX],MAX,p);
chance = chance./sum(chance);

hb = figure;
hold on;
MAX = totalvalid;
BINNUM = 1;
binranges = [1:BINNUM:MAX];
bincounts = histc(SIMRETURN,binranges);
bincounts = bincounts/sum(bincounts);
plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);
plot(binranges, chance*100,'k--','LineWidth',linewidth);
legend({'Target','chance'},'Location','northeast','FontSize',14);
legend boxoff ;
xlim([0 MAX]);
xtickrange = binranges;
set(gca,'XTick',xtickrange);
ylim([0 1]*50);
xlabel(['#subjsReturn'],'FontSize',14);
ylabel('Image Num Proportion (%)','FontSize',14);

%synthesize chance level
numchance = ceil(chance*100);
synchance = [];
for s = 1:MAX
   synchance = [synchance s*ones(1, numchance(s)) ];
end

[h pval] = ttest2(SIMRETURN, synchance);
title([type '; m(R1)=' num2str(mean(SIMRETURN)) '; p = ' num2str(pval)],'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/ReturnFixConsistencyTarget_' type printpostfix],printmode,printoption);
