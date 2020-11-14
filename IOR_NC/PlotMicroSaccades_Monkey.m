clear all; clc; close all;

TYPELIST = {'cmonkey'};
%TYPELIST = {'wmonkey','cmonkey'};

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
SIMRETURN = []; SIMNONRETURN = [];
PosX = Fix_posx;
PosY = Fix_posy;

%all trials
Firstx = PosX;
Firsty = PosY;

% cellsz = cellfun(@length,PosY,'uni',false);
% cellsz = cell2mat(cellsz);
% mean(cellsz)

for i = 1:length(Firstx)

   display(['processing ... img: ' num2str(i) ]);
   fx = double(Firstx{i});
   fy = double(Firsty{i});

   % remove those trials with only one fixation
    if length(fx)== 1
        continue;            
    end        

    load(['Mat_IOR_' type '/' type '_stimuli_' num2str(i) '.mat']);
    if ~isempty(overlappairsnt)
        overlappairsnt = overlappairsnt(:,1:1);
        %overlappairsnt = overlappairsnt + 1;
        overlappairsnt = overlappairsnt(:);
    end
    if ~isempty(overlappairst)
        overlappairst = overlappairst(:,1:1);
        %overlappairst = overlappairst + 1;
        overlappairst = overlappairst(:);
    end
    
    overlap = [overlappairst; overlappairsnt];
    overlap = unique(overlap);   

    sim = [];    
    %use the one excluding the first center fixations
    sim = Fix_microsad{i};


    if ~isempty(sim)
        sim = sim(2:end);
        %sim = softmax(sim')';
    end


    if ~isempty(sim)
        try
        SIMRETURN = [SIMRETURN sim(overlap)];
        sim(overlap) = [];
        SIMNONRETURN = [SIMNONRETURN sim];
        catch
            warning(['continue ...']);
            continue;
        end
    end

end
    

save(['Mat/microsaccade_' type  '.mat'],'SIMRETURN','SIMNONRETURN');

%% bar plot and report stats
hb = figure; hold on;
set(gca,'linewidth',2);
load(['Mat/microsaccade_' type '.mat']);

bar([1],nanmean(SIMRETURN),'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
errorbar([1], nanmean(SIMRETURN), nanstd(SIMRETURN)/sqrt(length(SIMRETURN)),'k.');
bar([2],nanmean(SIMNONRETURN),'FaceColor',[0.8020    0.8020    0.8020],'LineWidth',1.5);
errorbar([2], nanmean(SIMNONRETURN), nanstd(SIMNONRETURN)/sqrt(length(SIMNONRETURN)),'k.');
set(gca,'XTick',[1 2],'FontSize',14);
xlim([0.5 2.5]);
set(gca,'XTickLabel',{'Return','Non-Return'},'FontSize',12);
set(gca,'XTickLabelRotation',45);
ylim([0 0.1]);
set(gca,'YTick',[0:0.02:0.1],'FontSize',11);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
%xlabel('Inter Trial Interval','FontSize',14');
ylabel('Microsaccade Rate (Hz)','FontSize',12);
%legend({'Chance'},'FontSize',14);legend boxoff ;
[a p] = ttest2(SIMRETURN, SIMNONRETURN);

if p <= 0.05
    text(1.5,8, '*', 'Fontsize', 11, 'Fontweight', 'bold');
    plot([1 2],[7.8 7.8],'k','LineWidth',2.5);
% elseif pvalue <= 0.01
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
% elseif pvalue <= 0.001
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
else
    text(1.5,8, 'n.s.', 'Fontsize', 11, 'Fontweight', 'bold');
    plot([1 2],[7.8 7.8],'k','LineWidth',2.5);
end

titlename = [type ': Stats p=' num2str(p)];
%title(titlename,'FontSize',14);
set(hb,'Position',[288   207   153   258]);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/MicrosaccadeBarPlot_' type printpostfix],printmode,printoption);


end