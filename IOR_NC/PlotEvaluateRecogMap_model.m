%% copy and modify "/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/MMGeneratePprime.m"
clear all; close all; clc;

type = 'naturaldesign_conv_only'; %waldo, naturaldesign, 

subtype = strsplit(type,'_');
subtype = subtype{1};

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(subtype, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(subtype, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
else
    HumanNumFix = 65;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end
    
markerlist = {'r','g','b','c','k','m',     'r*-','g*-','b*-','c*-','k*-','m*-',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

Imgw = 1024;
Imgh = 1280;

load(['Mat/' type '_Fix.mat']);
Pprime = zeros(1, NumStimuli/2);

PosX = Fix_posx;
PosY = Fix_posy; 
counterpp = 0;
counterfix = 0;

%% comment out
% for i = 1:NumStimuli/2
%     i
%     CPosX = PosX{i};
%     CPosY = PosY{i};            
% 
%     if strcmp(type,'waldo')       
%         path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean_gt/gt_' sprintf('%03d', i) '.jpg'];       
%         receptiveSize = 100;
%     else      
%         path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(i) '.jpg' ];        
%         receptiveSize = 200;
%     end        
%     gt = double(imread(path));
%     gt = imresize(gt,[Imgw,Imgh]);
%     gt = mat2gray(gt);
%     gt = im2bw(gt,0.5);           
% 
%     for fn = 1:length(CPosX)
%         x = CPosY(fn);
%         y = CPosX(fn);
%         fixatedPlace_leftx = x - receptiveSize/2 + 1;
%         fixatedPlace_rightx = x + receptiveSize/2;
%         fixatedPlace_lefty = y - receptiveSize/2 + 1;
%         fixatedPlace_righty = y + receptiveSize/2;
% 
%         if fixatedPlace_leftx < 1
%             fixatedPlace_leftx = 1;
%         end
%         if fixatedPlace_lefty < 1
%             fixatedPlace_lefty = 1;
%         end
%         if fixatedPlace_rightx > size(gt,1)
%             fixatedPlace_rightx = size(gt,1);
%         end
%         if fixatedPlace_righty > size(gt,2)
%             fixatedPlace_righty = size(gt,2);
%         end
%         fixatedPlace = gt(fixatedPlace_leftx:fixatedPlace_rightx, fixatedPlace_lefty:fixatedPlace_righty);
% 
%         if sum(sum(fixatedPlace)) > 0 
%             counterpp = counterpp + 1;
%             counterfix = counterfix + 1;
%         else
%             counterfix = counterfix + 1;
%         end
%     end
% 
%     
%     Pprime(i) =  counterpp/counterfix;       
% 
% end
% save(['Mat/' type '_Pprime.mat'],'Pprime');

display(['Dataset (model): ' type]);
display(['p prime mean: ' num2str(mean(Pprime))]);
display(['p prime std: ' num2str(std(Pprime))]);

load(['Mat/' type '_Pprime.mat']);
MPprime = Pprime;

load(['Mat/mouseclick_human_' subtype '.mat']);
load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/DataForPlot/' subtype '_Pprime.mat']); 


bp = [mean(Pprime) mean(MPprime) mean(wrongclick) ...
    mean(modelwrongclick)];
bpstd = [std(Pprime)/sqrt(length(Pprime)) std(MPprime)/sqrt(length(MPprime)) std(wrongclick)/sqrt(length(wrongclick)) ...
    std(modelwrongclick)/sqrt(length(modelwrongclick))];

[h p1] = ttest2(Pprime, MPprime);
[h p2] = ttest2(wrongclick, modelwrongclick);

hb = figure;
hold on;
set(gca,'linewidth',2);

NumSubj = 4;
for s = 1: NumSubj  
    bar(s,bp(s),'FaceColor',[0.5020    0.5020    0.5020], 'EdgeColor','black','LineWidth',1.5);
    errorbar(s, bp(s), bpstd(s), 'k.');
end

set(gca,'XTickLabel',{'FalseNeg-Human','FalseNeg-IVSN2.0','FalsePos-Human','FalsePos-IVSN2.0'},'FontSize',12);
set(gca,'XTickLabelRotation',45)
%xticklabels({'FN-H','FN-M','FP-H','FP-M'}, 'FontSize',14);
xlim([0.5 NumSubj+0.5]);
set(gca,'xtick',[1:NumSubj],'FontSize',11);   
set(gca,'TickDir','out');
set(gca,'Box','Off');
%title(type);
xlabel('');
ylabel('Probability','FontSize',12);

if p1 <= 0.05
    text(1.45,0.2, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    plot([1 2],[0.195 0.195],'k','LineWidth',2.5);
else
    text(1.45,0.2, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
    plot([1 2],[0.195 0.195],'k','LineWidth',2.5);
end

if p2 <= 0.05
    text(3.5,0.2, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    plot([3 4],[0.195 0.195],'k','LineWidth',2.5);
else
    text(3.35,0.2, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
    plot([3 4],[0.195 0.195],'k','LineWidth',2.5);
end



%if strcmp(type,'naturaldesign')
    ylim([0 0.2]);
    set(gca,'ytick',[0:0.05:0.4],'FontSize',11);
    set(hb,'Position',[288   207   262   258]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

    print(hb,['Figures/fig_FN_FP_' type '_Pprime' printpostfix],printmode,printoption);
%else
%     ylim([0 0.2]);
%     set(gca,'ytick',[0:0.05:0.4]);
%     set(hb,'Units','Inches');
%     pos = get(hb,'Position');
%     set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% 
%     print(hb,['Figures/fig_FN_FP_' type '_Pprime' printpostfix],printmode,printoption);
%end

