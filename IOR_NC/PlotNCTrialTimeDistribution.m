clear all; close all; clc;

type = 'naturaldesign'; %waldo, wizzard, naturaldesign, array

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
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 80;
    xtickrange = [1 10:10:MaxPlotFix];
end
    
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);
load(['Mat/GTRatioList_' type '.mat'],'centerR'); %centerR(1,:) horizontal 1280;

[B,seqInd] = sort(seq);

TFtimedistri = [];
binranges = [0:0.05:8];
for s = 1: length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '_oracle.mat']);
    RTmat = FixData.Fix_time;
    for i = 1:NumStimuli
        TFtimedistri = [TFtimedistri RTmat{i}(end)];
    end
end
RTstore = double(TFtimedistri);
firstRT = RTstore/1000; %convert to seconds from ms
[sortfirstRT ind] = sort(firstRT);
display(['first 90% trials use: ' num2str( sortfirstRT(length(firstRT)*0.9) )]);
linewidth = 2;
bincounts = histc(firstRT,binranges);
hb = figure; hold on;
plot(binranges, bincounts/sum(bincounts),'k-','LineWidth',linewidth);
%ydivision = [0:0.01:0.4];
plot(ones(1,length(binranges))*sortfirstRT(length(firstRT)*0.9), binranges,'k--','LineWidth',linewidth);
%title('ReactionTimeFirstFix');
xlabel('Time (s)','FontSize', 11);
ylabel('Proportion','FontSize', 11);
xlim([0 8]);
ylim([0 0.05]);