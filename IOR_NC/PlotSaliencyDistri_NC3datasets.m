clear all; clc; close all;


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
   
    fix1 = [151 719 0]; %hB
    fix2 = [164 313 0]; %dB
    fix3 = [644 105 0]; %bH
    fix4 = [1127 300 0]; %dL
    fix5 = [1123 716 0]; %hL
    fix6 = [649 914 0]; %hH
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

linewidth  =2;

%% comment out 
SIMRETURN = []; SIMNONRETURN = []; 
% temp = [];

for s = 1: length(subjlist)
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    PosX = PosX(seqInd);
    PosY = PosY(seqInd);
    cellsz = cellfun(@length,PosY,'uni',false);
    cellsz = cell2mat(cellsz);
    %temp = [temp mean(cellsz)];
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
        
        load(['Mat_IOR_' type '/' subjlist{s} '_stimuli_' num2str(i) '.mat']);
        if ~isempty(overlappairsnt)
            overlappairsnt = overlappairsnt(:,1:2);
            %overlappairsnt = overlappairsnt + 1;
            overlappairsnt = overlappairsnt(:);
        end
        if ~isempty(overlappairst)
            overlappairst = overlappairst(:,1:2);
            %overlappairst = overlappairst + 1;
            overlappairst = overlappairst(:);
        end
        
        overlap = [overlappairst; overlappairsnt];
        overlap = unique(overlap);
        
        sim = [];
        if strcmp(type, 'array')            
            filename = [SimilarityName '/sal' num2str(i) '.jpg'];
        elseif strcmp(type, 'naturaldesign') || strcmp(type, 'naturalsaliency')
            filename = [SimilarityName '/sal' num2str(i) '.jpg'];
        else
            filename = [SimilarityName '/' MyData(i).targetname];
        end
        sal = imread(filename);
        sal = mat2gray(sal);
        sal = imresize(sal, [Imgw Imgh]);

        trialfixseqx = fx(2:end);
        trialfixseqy = fy(2:end);
        trialfixseqx(find(isnan(trialfixseqx))) = [];
        trialfixseqy(find(isnan(trialfixseqy))) = [];
        if isempty(trialfixseqx)
            %invalid human trial
            continue;
        end
        selectind = length(trialfixseqx);

        for k = 1:selectind                
            x = trialfixseqx(k);
            y = trialfixseqy(k);

            if x<1
                warning('prob');
                x = 1;
            end
            if x>h
                warning('prob');
                x = h;
            end
            if y<1
                warning('prob');
                y = 1;
            end
            if y>w
                warning('prob');
                y = w;
            end

            fixatedPlace_leftx = x - receptiveSize/2 + 1;
            fixatedPlace_rightx = x + receptiveSize/2;
            fixatedPlace_lefty = y - receptiveSize/2 + 1;
            fixatedPlace_righty = y + receptiveSize/2;

            if fixatedPlace_leftx < 1
                fixatedPlace_leftx = 1;
            end
            if fixatedPlace_lefty < 1
                fixatedPlace_lefty = 1;
            end
            if fixatedPlace_rightx > h
                fixatedPlace_rightx = h;
            end
            if fixatedPlace_righty > w
                fixatedPlace_righty = w;
            end
%             fixatedPlace = gt(fixatedPlace_lefty:fixatedPlace_righty, fixatedPlace_leftx:fixatedPlace_rightx);
%         
%             if sum(sum(fixatedPlace)) > 0                 
%                 break;
%             end

            fixatedPlace = sal(fixatedPlace_lefty:fixatedPlace_righty, fixatedPlace_leftx:fixatedPlace_rightx);
            salvalue = mean(mean(fixatedPlace));
            sim = [sim salvalue];
        end

        if ~isempty(sim)
            sim = sim(1:end);
            %sim = softmax(sim')';
        end
        
        
        if ~isempty(sim)
            SIMRETURN = [SIMRETURN sim(overlap)];
            sim(overlap) = [];
            SIMNONRETURN = [SIMNONRETURN sim];
        end
        
    end
    
end
save(['Mat/saliency_' type  '.mat'],'SIMRETURN','SIMNONRETURN');


% hb = figure; hold on;
% set(gca,'linewidth',2);
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

if strcmp(type, 'array')
    set(gca,'XTickLabel',{'Return','Non-Return'},'FontSize',12);
    set(gca,'XTickLabelRotation',45);
    ylabel('Saliency','FontSize',12);
else
    set(gca,'XTickLabel',{},'FontSize',12);
    set(gca,'YTickLabel',{},'FontSize',12);
end
ylim([0 0.65]);
set(gca,'YTick',[0:0.2:0.6],'FontSize',11);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
%xlabel('Inter Trial Interval','FontSize',14');

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

titlename = [type ': stats p=' num2str(p)];
%title(titlename,'FontSize',14);

if strcmp(type, 'array')
    set(hb,'Position',[303   294   125   186]);
else
    set(hb,'Position',[303   363    71   117]);
end
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/SaliencyBarPlot_' type printpostfix],printmode,printoption);


end



