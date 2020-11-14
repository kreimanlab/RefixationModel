clear all; close all; clc;

type = 'cmonkey'; 

Gsize = 130; Gvar = 25; %gaussian filter specs
%wmonkey, cmonkey, wmonkey_conv_only, cmonkey_conv_only
%wmonkey_classi
subtype = strsplit(type, '_');
subtype = subtype{1};

if strcmp(subtype, 'cmonkey')
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuli/';
    MaxPlotFix = 5;
    xtickrange = [1:1:MaxPlotFix];
else
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli/';
    MaxPlotFix = 10;
    xtickrange = [1:2:MaxPlotFix];
end

marksizedva = 39.7; %degree of visual angles to pixels

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
load(['Mat/' type '_Fix.mat']);
imgnamelist = unique(Fix_pic);

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

probrefix = [];

for stimulusID = 1:length(imgnamelist)

    [a] = strcmp(imgnamelist{stimulusID},Fix_pic);
    [duplicatesind b] = find(a==1);

    for imgID = duplicatesind'         

        %% pre-filter whether it satisfies 
        ImgSelected = imgID;

        load(['Mat_IOR_' type '/' type '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

        if isempty(overlappairsnt)
            continue;
        end        
        
        if ~isempty(overlappairsnt)
            qq1 = overlappairsnt(:,1);
            qq2 = overlappairsnt(:,2);

            %remove those triple pairs (A,B) and (B,C); then we only take C
            qq2(ismember(qq2,qq1)) = [];  

            probrefix = [probrefix; qq2];
        end
        

    end

    
end

hb = figure; hold on; set(hb,'Position',[313   248   293   242]);
linewidth = 2;
set(gca,'linewidth',2);
binranges = xtickrange;
bincounts = histc(probrefix,binranges);
bincounts = bincounts/sum(bincounts);
  
plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');

load(['Mat/' type '_chanceoffsetnt.mat']);
bincounts = histc(probrefix,binranges);
bincounts = bincounts/sum(bincounts);
plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle',':');


xlim([1 MaxPlotFix]);
set(gca,'XTick',xtickrange,'FontSize',11);
set(gca,'YTick',[0:30:90],'FontSize',11);
ylim([0 1]*90);
xlabel('Fixation Number','FontSize',12);
ylabel('Distribution (%)','FontSize',12);
%title(type,'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/ProbRefixSeq_' type '_humans' printpostfix],printmode,printoption);


