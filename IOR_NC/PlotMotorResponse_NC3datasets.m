clear all; close all; clc;

type = 'array'; %waldo, naturaldesign, array, naturalsaliency

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
   FIXLIM = 24;
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    FIXLIM = 30;
elseif strcmp(type, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 240;
    subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    FIXLIM = 30;
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    MaxPlotFix = 80;
    xtickrange = [1 10:10:MaxPlotFix];
    FIXLIM = 30;
end
    
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/' type '_seq.mat']);

%% extract motor response durations and fixation durations from EDF files
% ST = [];
% FT = [];
% FTrest = [];
% FTlast = [];
% 
% if ~strcmp(type, 'array')
%     for s = 1:length(subjlist)
%         %Matlist = dir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/EDFMat/' type '/' subjlist{s} '/*.mat']);    
%         %for m = 1:length(Matlist)
%             %load(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/EDFMat/' type '/' subjlist{s} '/' Matlist(m).name]);        
%         %end
% 
%         load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type '/' subjlist{s} '.mat']);
%         for i = 1:NumStimuli
%             j = 1;
%             ft = FixData.Fix_time{i}(j) - FixData.Fix_starttime{i}(j);        
%             FT = [FT ft];
% 
%             if length(FixData.Fix_starttime{i}) == 1
%                 FTlast = [FTlast ft];
%             else
%                 FTrest = [FTrest ft];
%             end
% 
%             for j = 2:length(FixData.Fix_starttime{i})            
%                 st = FixData.Fix_starttime{i}(j) - FixData.Fix_time{i}(j-1); 
%                 ft = FixData.Fix_time{i}(j) - FixData.Fix_starttime{i}(j);
% 
%                 if j == length(FixData.Fix_starttime{i})
%                     FTlast = [FTlast ft];
%                 else
%                     FTrest = [FTrest ft];
%                 end
% 
%                 ST = [ST st];
%                 FT = [FT ft];
%             end
%         end
%     end
%     save(['Mat/MotorResponse_' type '.mat'], 'ST','FT','FTrest','FTlast');
% else
%     for s = 1:length(subjlist)
%         %Matlist = dir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/EDFMat/' type '/' subjlist{s} '/*.mat']);    
%         %for m = 1:length(Matlist)
%             %load(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/EDFMat/' type '/' subjlist{s} '/' Matlist(m).name]);        
%         %end
% 
%         load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type '/' subjlist{s} '.mat']);
%         for i = 1:NumStimuli
%             ftime = FixData.Fix_time{i};           
%             ftime(isnan(ftime)) = [];
%             if length(ftime) == 0
%                 continue;
%             end
%             ftime = [ftime(1) diff(ftime)];
%             for j = 1:length(ftime)            
%                 %st = FixData.Fix_starttime{i}(j) - FixData.Fix_time{i}(j-1); 
%                 ft = ftime(j);
% 
%                 if j == length(ftime)
%                     FTlast = [FTlast ft];
%                 else
%                     FTrest = [FTrest ft];
%                 end
% 
%                 %ST = [ST st];
%                 FT = [FT ft];
%             end
%         end
%     end
%     save(['Mat/MotorResponse_' type '.mat'], 'FT','FTrest','FTlast');
% end
% 
% 
% load(['Mat/MotorResponse_' type '.mat']);
% hb = figure; hold on;
% printpostfix = '.eps';
% printmode = '-depsc'; %-depsc
% printoption = '-r200'; %'-fillpage'
% 
% linewidth = 3;
% MAX = max(FT);
% BINNUM = 100;
% binranges = [0:MAX/BINNUM:MAX];
% bincounts = histc(FT,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);
% 
% bincounts = histc(FTrest,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','r','LineWidth',linewidth);
% 
% bincounts = histc(FTlast,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','c','LineWidth',linewidth,'LineStyle','--');
% 
% legend({'Fixation(all)','Fixation(rest)','Fixation(last)'},'Location','northeast','FontSize',14);
% legend boxoff ;
% xlim([0 800]);
% %set(gca,'XTick',xtickrange);
% %ylim([0 1]*80);
% xlabel(['Time Duration (ms)'],'FontSize',14);
% ylabel('Distribution (%)','FontSize',14);
% title([type '; m(FA)=' num2str(median(FT)) '; m(FR)=' num2str(median(FTrest)) '; m(FL)=' num2str(median(FTlast)) ],'FontSize', 14);
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['Figures/TFixationDistri_' type printpostfix],printmode,printoption);
% 
% if ~strcmp(type, 'array')
% 
%     %% saccade distribution
%     hb = figure; hold on;
%     printpostfix = '.eps';
%     printmode = '-depsc'; %-depsc
%     printoption = '-r200'; %'-fillpage'
% 
%     linewidth = 3;
%     MAX = 80;
%     BINNUM = 200;
%     binranges = [0:MAX/BINNUM:MAX];
%     bincounts = histc(ST,binranges);
%     bincounts = bincounts/sum(bincounts);
%     plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);
% 
%     legend({'Saccade'},'Location','northeast','FontSize',14);
%     legend boxoff ;
%     xlim([0 80]);
%     %set(gca,'XTick',xtickrange);
%     %ylim([0 1]*80);
%     xlabel(['Time Duration (ms)'],'FontSize',14);
%     ylabel('Distribution (%)','FontSize',14);
%     title([type '; m(ST)=' num2str(median(ST))],'FontSize', 14);
%     set(gca, 'TickDir', 'out');
%     set(gca, 'Box','off');
%     set(hb,'Units','Inches');
%     pos = get(hb,'Position');
%     set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%     print(hb,['Figures/TSaccadeDistri_' type printpostfix],printmode,printoption);
% 
% end


% 
% subjMRT = {}; %motor response time
% 
% for s = 1:length(subjlist)
%     Matlist = dir(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/EDFMat/' type '/' subjlist{s} '/*.mat']);   
%     trial = 1;
%     mrt = [];
%     s
%     
%     for m = 1:length(Matlist)
%         load(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/EDFMat/' type '/' subjlist{s} '/' Matlist(m).name]);
%         if ~isstruct(edfcopy)
%             continue;
%         end
%         
%         eventlist = edfcopy.RawEdf.FEVENT;
%         Time = edfcopy.Samples.time;
%         ToSearchString = ['ENDFIX'];
%         fixindex=structfind(eventlist,'codestring',ToSearchString);
%         
%         while trial<= NumStimuli
%             ToSearchString = ['TRIAL_ON: ' num2str(trial) ];
%             index=structfind(eventlist,'message',ToSearchString);
% 
%             if isempty(index)
%                 break;
%             end
%             Sindex = index;
%             
%             startIdxx = eventlist(index).sttime;
%             startIdx = find(Time == startIdxx);
%             while isempty(startIdx)
%                 startIdxx = startIdxx + 1;
%                 startIdx = find(Time == startIdxx);
%             end
% 
%             ToSearchString = ['TRIAL_OFF: ' num2str(trial)];
%             index=structfind(eventlist,'message',ToSearchString);
%             Eindex = index;
%             
%             endIdxx = eventlist(index).sttime;
%             endIdx = find(Time == endIdxx);
%             while isempty(endIdx)
%                 endIdxx = endIdxx + 1;
%                 endIdx = find(Time == endIdxx);
%             end
% 
%             PosTIME = Time(startIdx:endIdx);
%             PosTIME = PosTIME - PosTIME(1);
%             
%             filteredfixindex = fixindex(find(fixindex >= Sindex & fixindex <= Eindex)); %include the last fixation just before trial ends
%             mrt = [mrt; s trial length(filteredfixindex) PosTIME(end)];
%             trial = trial + 1;
%             
%             %% visualization only (comment out)
%             if length(filteredfixindex)>15
%                 imgID = seq(trial);
%                 img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli_array_screen_inference/array_' num2str(imgID) '.jpg']);
% 
%                 fixx = [];
%                 fixy = [];
%                 for j = 1: length(filteredfixindex)
%                     fixx = [fixx eventlist(filteredfixindex(j)).gavx];
%                     fixy = [fixy eventlist(filteredfixindex(j)).gavy];
%                 end
%                 figure;
%                 imshow(img); hold on;
%                 plot(fixx, fixy, 'r*-');
%                 xlim([0 1280]);
%                 ylim([0 1024]);
%             end
%             
%             
%         end
%     end
%     subjMRT = [subjMRT mrt];
% end
% save(['Mat/MotorResponse_' type '.mat'],'subjMRT');

load(['Mat/MotorResponse_' type '.mat']);

X = [];
y = [];
for s = 1:length(subjMRT)
    rec = subjMRT{s};
    
    %pre-filtering conditions
    filterind = [];
    for f = 1:FIXLIM
        [bind a] = find(rec(:,3) == f);
        mu = mean(rec(bind,4));
        sg = std(rec(bind,4));
        %display(['fix']);
        upper = mu + sg;
        lower = mu - sg;
        [bind1 a] = find( (rec(:,3) == f & rec(:,4) < mu- sg) );
        
        [bind2 a] = find( (rec(:,3) == f & rec(:,4) > mu +sg) );
        bind = [bind1; bind2];
%         size(bind1)
%         size(bind2)
%         size(filterind)
%         size(bind)
        filterind = [filterind; bind];
        length(filterind);
    end
    rec(filterind, :) = [];
    
    subjid = rec(1,1);
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type '/' subjlist{subjid} '.mat']);
    
    trialtotal = size(rec,1);
    for t = 1:trialtotal
        trialid = rec(t,2);
        %NumFix = length(FixData.Fix_posx{trialid});
        NumFix = rec(t,3);
        
        if NumFix > FIXLIM
            continue;
        end
        
        X = [X; 1 NumFix];
        y = [y; rec(t,4)];
    end
end

b = X\y;
yCalc2 = X*b;
hb = figure; hold on;
plot(X(:,2), y,'bo');
plot(X(:,2),yCalc2,'r--');
xlabel('Num Fixs');
ylabel('Reaction Time (ms)');
legend('Data','Slope & Intercept','Location','best');
title(['intercept = ' num2str(b(1)) '; slope=' num2str(b(2)) ]);
xlim([1,FIXLIM]);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/Motorresponse_' type printpostfix],printmode,printoption);



























