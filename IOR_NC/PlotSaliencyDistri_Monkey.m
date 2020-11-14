clear all; clc; close all;


TYPELIST = {'wmonkey','wmonkey_conv_only','cmonkey','cmonkey_conv_only'};

for T = 1:length(TYPELIST)

type = TYPELIST{T};

%wmonkey_classi
subtype = strsplit(type, '_');
subtype = subtype{1};

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(subtype, 'cmonkey')
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuli/';
    SimilarityName = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuli_gbvs/';
    receptiveSize = 39.7;
else
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli/';
    SimilarityName = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli_gbvs/';
    receptiveSize = 39.7;
end
  
load(['Mat/' type '_Fix.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
Imgw = imgsize;
w = Imgw;
Imgh  = imgsize;
h = Imgh;
linewidth  =2;

% %% comment out 
% SIMRETURN = []; SIMNONRETURN = [];
% PosX = Fix_posx;
% PosY = Fix_posy;
% 
% %all trials
% Firstx = PosX;
% Firsty = PosY;
% 
% % cellsz = cellfun(@length,PosY,'uni',false);
% % cellsz = cell2mat(cellsz);
% % mean(cellsz)
% 
% for i = 1:length(Firstx)
% 
%    display(['processing ... img: ' num2str(i) ]);
%    fx = double(Firstx{i});
%    fy = double(Firsty{i});
% 
%    % remove those trials with only one fixation
%     if length(fx)== 1
%         continue;            
%     end        
% 
%     load(['Mat_IOR_' type '/' type '_stimuli_' num2str(i) '.mat']);
%     if ~isempty(overlappairsnt)
%         overlappairsnt = overlappairsnt(:,1:1);
%         %overlappairsnt = overlappairsnt + 1;
%         overlappairsnt = overlappairsnt(:);
%     end
%     if ~isempty(overlappairst)
%         overlappairst = overlappairst(:,1:1);
%         %overlappairst = overlappairst + 1;
%         overlappairst = overlappairst(:);
%     end
%     
%     overlap = [overlappairst; overlappairsnt];
%     overlap = unique(overlap);
%     
%     
% 
%     sim = [];
%     filename = [SimilarityName  Fix_pic{i}];    
%     filename = [filename  '.mat'];
%     
%     if exist(filename, 'file') ~= 2 
%         warning('missing file');
%         display('===============');
%         continue;
%     end
%     
%     load(filename);
%     sal = x;
%     sal = mat2gray(sal);
%     sal = imresize(sal, [Imgw Imgh]);
% 
%     trialfixseqx = fx(2:end);
%     trialfixseqy = fy(2:end);
% %     trialfixseqx(find(isnan(trialfixseqx))) = [];
% %     trialfixseqy(find(isnan(trialfixseqy))) = [];
%     if isempty(trialfixseqx)
%         %invalid human trial
%         continue;
%     end
%     selectind = length(trialfixseqx);
% 
%     for k = 1:selectind                
%         x = trialfixseqx(k);
%         y = trialfixseqy(k);
% 
%         if x<1
%             warning('prob');
%             x = 1;
%         end
%         if x>h
%             warning('prob');
%             x = h;
%         end
%         if y<1
%             warning('prob');
%             y = 1;
%         end
%         if y>w
%             warning('prob');
%             y = w;
%         end
% 
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
%         if fixatedPlace_rightx > h
%             fixatedPlace_rightx = h;
%         end
%         if fixatedPlace_righty > w
%             fixatedPlace_righty = w;
%         end
% %             fixatedPlace = gt(fixatedPlace_lefty:fixatedPlace_righty, fixatedPlace_leftx:fixatedPlace_rightx);
% %         
% %             if sum(sum(fixatedPlace)) > 0                 
% %                 break;
% %             end
% 
%         fixatedPlace = sal(fixatedPlace_lefty:fixatedPlace_righty, fixatedPlace_leftx:fixatedPlace_rightx);
%         salvalue = mean(mean(fixatedPlace));
%         sim = [sim salvalue];
%     end
% 
%     if ~isempty(sim)
%         sim = sim(1:end);
%         %sim = softmax(sim')';
%     end
% 
% 
%     if ~isempty(sim)
%         SIMRETURN = [SIMRETURN sim(overlap)];
%         sim(overlap) = [];
%         SIMNONRETURN = [SIMNONRETURN sim];
%     end
% 
% end
%     
% 
% save(['Mat/saliency_' type  '.mat'],'SIMRETURN','SIMNONRETURN');


% hb = figure; hold on;
% set(gca,'linewidth',2);
% 
% load(['Mat/saliency_' type '.mat']);
% MAX = max([max(SIMRETURN) max(SIMNONRETURN)]);
% BINNUM = 100;
% binranges = [0:MAX/BINNUM:MAX];
% bincounts = histc(SIMRETURN,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','b','LineWidth',linewidth);
% 
% bincounts = histc(SIMNONRETURN,binranges);
% bincounts = bincounts/sum(bincounts);
% plot(binranges, bincounts*100,'Color','r','LineWidth',linewidth);
% 
% legend({'Return','Non-return','Chance'},'Location','northeast','FontSize',14);
% legend boxoff ;
% xlim([0 MAX]);
% %set(gca,'XTick',xtickrange);
% %ylim([0 1]*80);
% xlabel(['Saliency'],'FontSize',14);
% ylabel('Distribution (%)','FontSize',14);
% title([type '; m(R)=' num2str(mean(SIMRETURN)) '; m(NR)=' num2str(mean(SIMNONRETURN))],'FontSize', 14);
% set(gca, 'TickDir', 'out');
% set(gca, 'Box','off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% %print(hb,['Figures/Saliency_' type printpostfix],printmode,printoption);

%% bar plot and report stats
hb = figure; hold on;
set(gca,'linewidth',2);
load(['Mat/saliency_' type '.mat']);

bar([1],nanmean(SIMRETURN),'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
errorbar([1], nanmean(SIMRETURN), nanstd(SIMRETURN)/sqrt(length(SIMRETURN)),'k.');
bar([2],nanmean(SIMNONRETURN),'FaceColor',[0.8020    0.8020    0.8020],'LineWidth',1.5);
errorbar([2], nanmean(SIMNONRETURN), nanstd(SIMNONRETURN)/sqrt(length(SIMNONRETURN)),'k.');
set(gca,'XTick',[1 2],'FontSize',14);
xlim([0.5 2.5]);
%set(gca,'XTickLabel',{'To-be-revisited','Return','Non-Return'},'FontSize',12);
set(gca,'XTickLabel',{},'FontSize',12);
set(gca,'YTickLabel',{},'FontSize',12);
set(gca,'XTickLabelRotation',45);
ylim([0 0.65]);
set(gca,'YTick',[0:0.2:0.6],'FontSize',11);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
%xlabel('Inter Trial Interval','FontSize',14');
%ylabel('Saliency Value','FontSize',12);
%legend({'Chance'},'FontSize',14);legend boxoff ;
[a p] = ttest2(SIMRETURN, SIMNONRETURN);

if p <= 0.05
    text(1.5,0.67, '*', 'Fontsize', 12, 'Fontweight', 'bold');
    %plot([1 2],[0.65 0.65],'k','LineWidth',2.5);
    fcn_sigstar(1,2,0.63,0.03);
% elseif pvalue <= 0.01
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
% elseif pvalue <= 0.001
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
else
%     text(1.5,0.67, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
%     plot([1 2],[0.65 0.65],'k','LineWidth',2.5);
end

titlename = [type ': Stats p=' num2str(p)];
%title(titlename,'FontSize',14);

if contains(type, '_')
    set(hb,'Position',[288   207   153   258]);
else    
    set(hb,'Position',[303   363    71   117]);
end
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/SaliencyBarPlot_' type printpostfix],printmode,printoption);


end