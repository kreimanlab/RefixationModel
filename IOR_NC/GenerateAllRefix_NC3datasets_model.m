clear all; close all; clc;


type = 'naturalsaliency_conv_only'; %naturalsaliency_scanpathpred, naturalsaliency_scanpathpred_infor
%naturalsaliency_classi, naturaldesign_classi, waldo_classi

subtype = strsplit(type,'_');
subtype = subtype{1};
%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(subtype, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {type}; %array
   MaxPlotFix = 6; 
   xtickrange = [1:MaxPlotFix];
   
   
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
   
elseif strcmp(subtype, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {type}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    
elseif strcmp(subtype, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {type}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {type}; %natural design
    MaxPlotFix = 80;
    xtickrange = [1 10:10:MaxPlotFix];
end

if strcmp(subtype, 'naturalsaliency')
    centerR = ones(2, NumStimuli/2)*5000;    
else
    load(['Mat/GTRatioList_' subtype '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
end

Imgw = 1024;
Imgh = 1280;



marksizedva = 31/2; %degree of visual angles to pixels

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

%hb = figure;
radiuscircle = 10; %
sidesquare = 35;

%waldo: 6 12 30 39
%array: 6 19 20 39  
%naturaldesign: 3 226 134 169
%naturalsaliency: 4 12 172 181

%selected
%naturalsaliency: 12
%naturaldesign: 169
%array: 39
%waldo: 39

binarymask = zeros(Imgw, Imgh);
binaryw = [];binaryh = [];

hb=figure; hold on;

matlist = dir(['Mat/IOReg_*']);

for SubjID = 1:length(subjlist)
    for imgID = 1:NumStimuli/2

%display(['subjid: ' num2str(SubjID) '; imgID: ' num2str(imgID) ]);

%% pre-filter whether it satisfies 
ImgSelected = imgID;
subjectid = subjlist{SubjID};

load(['Mat_IOR_' type '/' subjectid '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

if strcmp(subtype, 'naturalsaliency')
    if isempty(overlappairsnt)
        continue;
    end
else
    if isempty(overlappairst) && isempty(overlappairsnt)
        continue;
    end
end

filename = ['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type '/' subjectid '.mat'];
load(['Mat/' type '_Fix.mat']);
%load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
PosX = Fix_posx;
PosY = Fix_posy; 
    
posx = PosX{ImgSelected};
posy = PosY{ImgSelected};
NumFix1 = length(posx);
posx = posx(1:end); %do not remove first fixation at center
posy = posy(1:end); %always start the first fixation in the center

% if length(posx) > 16 %prefer examples with <= 10 fixations
%     continue;
% end

if strcmp(subtype, 'array')
    posxcopy = posx;
    posycopy = posy;

    for ctype = 1:size(fixC,1)
        posx(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,1);
        posy(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,2);
    end
end

if ~isempty(overlappairst)
  for zz = 1:size(overlappairst,1)
    if length(posx) == overlappairst(zz,3)
        qq1 = overlappairst(zz,1);
        qq2 = overlappairst(zz,2);
    else
        qq1 = overlappairst(zz,1)+1;
        qq2 = overlappairst(zz,2)+1;
    end
%     %RGB = insertShape(RGB,'Circle',[int32(posx(qq1)) int32(posy(qq1)) radiuscircle],'Color','c','LineWidth',10);
%     plot(int32(posx(qq1)), int32(posy(qq1)), 'Color','r', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
%     
%     %RGB = insertShape(RGB,'Rectangle',[int32(posx(qq2))-sidesquare/2 int32(posy(qq2))-sidesquare/2 sidesquare sidesquare],'Color','c','LineWidth',9);
%     plot(int32(posx(qq2)), int32(posy(qq2)), 'Color','r', 'Marker','^','MarkerSize',marksizedva, 'LineWidth',6);
    
    binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    binaryw = [binaryw int32(posy(qq1))];
    binaryh = [binaryh int32(posx(qq1))];

    plot(posx(qq1), posy(qq1), 'ko','markersize',2);
  end
end

overlappairst = overlappairsnt;
if ~isempty(overlappairst)
  for zz = 1:size(overlappairst,1)
    if length(posx) == overlappairst(zz,3)
        qq1 = overlappairst(zz,1);
        qq2 = overlappairst(zz,2);
    else
        qq1 = overlappairst(zz,1)+1;
        qq2 = overlappairst(zz,2)+1;
    end
%     %RGB = insertShape(RGB,'Circle',[int32(posx(qq1)) int32(posy(qq1)) radiuscircle ],'Color','g','LineWidth',10);
%     plot(int32(posx(qq1)), int32(posy(qq1)), 'Color','r', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
%     %RGB = insertShape(RGB,'Rectangle',[int32(posx(qq2))-sidesquare/2 int32(posy(qq2))-sidesquare/2 sidesquare sidesquare],'Color','g','LineWidth',9);
%     plot(int32(posx(qq2)), int32(posy(qq2)), 'Color','r', 'Marker','^','MarkerSize',marksizedva, 'LineWidth',6);
    binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    binaryw = [binaryw int32(posy(qq1))];
    binaryh = [binaryh int32(posx(qq1))];
    plot(posx(qq1), posy(qq1), 'ko','markersize',2);
    
  end
end


    end
end

if strcmp(subtype, 'array')
    
    NumRefix = [];
    for ctype = 1:size(fixC,1)
        num = length(find(binaryh == fixC(ctype,1) & binaryw == fixC(ctype,2)));
        NumRefix = [NumRefix num];
    end
    
    hb = figure('Position',[283   202   335   258]); hold on;
    set(gca,'linewidth',2);

    M = NumRefix/sum(NumRefix);
    Rbinarymask = M;
    %Mstd = [std(entropylist)/sqrt(length(entropylist))];
    bar([1:6],M,'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
    plot([0.5:6.5], 1/6*ones(length([0.5:6.5]),1),'k:','LineWidth',2.5);
    
    xlim([0.5 6.5]);
    xtickrange = [1:6];
    set(gca,'XTick',xtickrange,'FontSize',11);
    %set(gca,'XTickLabel',{1:6},'FontSize',12);
    %set(gca,'XTickLabelRotation',45);
    yaxislim = [0 0.3];
    ytickrange = [0:0.1:0.3];
    set(gca,'YTick',ytickrange,'FontSize',11);
    ylim(yaxislim);
    ylabel('Proportion','FontSize',12);
    xlabel('Position in object array','FontSize',12);
    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');

    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_AllRefix_model' printpostfix],printmode,printoption);
    
else
    
%     hb = figure;
%     imshow(mat2gray(binarymask));
    set(gca,'linewidth',3);
    Rbinarymask = binarymask;
%     plot([0:Imgh],Imgw,'k-','MarkerSize',4);
%     plot(Imgh,[0:Imgw],'k-','MarkerSize',4);
    plot([0 Imgh],[Imgw Imgw],'k-','LineWidth',3);
    plot([Imgh Imgh],[0 Imgw],'k-','LineWidth',3);
    %axis([0 Imgh 0 Imgw])
    xlim([0 Imgh]);
    ylim([0 Imgw]);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    set(hb,'Position',[680   549   560   420]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_AllRefix_model' printpostfix],printmode,printoption);
end

%% non-return
close all;

binarymask = zeros(Imgw, Imgh);
binaryw = [];binaryh = [];

hb=figure; hold on;

matlist = dir(['Mat/IOReg_*']);

for SubjID = 1:length(subjlist)
    for imgID = 1:NumStimuli/2

%display(['subjid: ' num2str(SubjID) '; imgID: ' num2str(imgID) ]);

%% pre-filter whether it satisfies 
ImgSelected = imgID;
subjectid = subjlist{SubjID};

load(['Mat_IOR_' type '/' subjectid '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

if strcmp(subtype, 'naturalsaliency')
    if isempty(overlappairsnt)
        continue;
    end
else
    if isempty(overlappairst) && isempty(overlappairsnt)
        continue;
    end
end

filename = ['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type '/' subjectid '.mat'];
load(['Mat/' type '_Fix.mat']);
%load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
PosX = Fix_posx;
PosY = Fix_posy; 
    
posx = PosX{ImgSelected};
posy = PosY{ImgSelected};
NumFix1 = length(posx);
posx = posx(1:end); %do not remove first fixation at center
posy = posy(1:end); %always start the first fixation in the center

% if length(posx) > 16 %prefer examples with <= 10 fixations
%     continue;
% end

if strcmp(subtype, 'array')
    posxcopy = posx;
    posycopy = posy;

    for ctype = 1:size(fixC,1)
        posx(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,1);
        posy(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,2);
    end
end

if ~isempty(overlappairst)
    ind = overlappairst(:,1:2);
    ind = unique(ind(:) + 1);
    allind = [1:length(posx)];
    allind(ind) = [];
else
    allind = [1:length(posx)];
end

% if ~isempty(overlappairst)
%   for zz = 1:size(overlappairst,1)
%     if length(posx) == overlappairst(zz,3)
%         qq1 = overlappairst(zz,1);
%         qq2 = overlappairst(zz,2);
%     else
%         qq1 = overlappairst(zz,1)+1;
%         qq2 = overlappairst(zz,2)+1;
%     end

for qq1 = allind
%     %RGB = insertShape(RGB,'Circle',[int32(posx(qq1)) int32(posy(qq1)) radiuscircle],'Color','c','LineWidth',10);
%     plot(int32(posx(qq1)), int32(posy(qq1)), 'Color','r', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
%     
%     %RGB = insertShape(RGB,'Rectangle',[int32(posx(qq2))-sidesquare/2 int32(posy(qq2))-sidesquare/2 sidesquare sidesquare],'Color','c','LineWidth',9);
%     plot(int32(posx(qq2)), int32(posy(qq2)), 'Color','r', 'Marker','^','MarkerSize',marksizedva, 'LineWidth',6);
    
    binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    binaryw = [binaryw int32(posy(qq1))];
    binaryh = [binaryh int32(posx(qq1))];

    plot(posx(qq1), posy(qq1), 'ko','markersize',2);
  
end

overlappairst = overlappairsnt;

if ~isempty(overlappairst)
    ind = overlappairst(:,1:2);
    ind = unique(ind(:) + 1);
    allind = [1:length(posx)];
    allind(ind) = [];
else
    allind = [1:length(posx)];
end

for qq1 = allind
%     %RGB = insertShape(RGB,'Circle',[int32(posx(qq1)) int32(posy(qq1)) radiuscircle ],'Color','g','LineWidth',10);
%     plot(int32(posx(qq1)), int32(posy(qq1)), 'Color','r', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
%     %RGB = insertShape(RGB,'Rectangle',[int32(posx(qq2))-sidesquare/2 int32(posy(qq2))-sidesquare/2 sidesquare sidesquare],'Color','g','LineWidth',9);
%     plot(int32(posx(qq2)), int32(posy(qq2)), 'Color','r', 'Marker','^','MarkerSize',marksizedva, 'LineWidth',6);
    binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    binaryw = [binaryw int32(posy(qq1))];
    binaryh = [binaryh int32(posx(qq1))];
    plot(posx(qq1), posy(qq1), 'ko','markersize',2);
    
end



    end
end

if strcmp(subtype, 'array')
    
    NumRefix = [];
    for ctype = 1:size(fixC,1)
        num = length(find(binaryh == fixC(ctype,1) & binaryw == fixC(ctype,2)));
        NumRefix = [NumRefix num];
    end
    
    hb = figure('Position',[283   202   335   258]); hold on;
    set(gca,'linewidth',2);

    M = NumRefix/sum(NumRefix);
    NRbinarymask = M;
    %Mstd = [std(entropylist)/sqrt(length(entropylist))];
    bar([1:6],M,'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
    plot([0.5:6.5], 1/6*ones(length([0.5:6.5]),1),'k:','LineWidth',2.5);
    
    xlim([0.5 6.5]);
    xtickrange = [1:6];
    set(gca,'XTick',xtickrange,'FontSize',11);
    %set(gca,'XTickLabel',{1:6},'FontSize',12);
    %set(gca,'XTickLabelRotation',45);
    yaxislim = [0 0.3];
    ytickrange = [0:0.1:0.3];
    set(gca,'YTick',ytickrange,'FontSize',11);
    ylim(yaxislim);
    ylabel('Proportion','FontSize',12);
    xlabel('Position in object array','FontSize',12);
    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');
    %set(hb,'Position',[680   549   560   420]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_All_NR_fixs_models' printpostfix],printmode,printoption);
    
else
    
%     hb = figure;
%     imshow(mat2gray(binarymask));
    set(gca,'linewidth',3);
    NRbinarymask = binarymask;
%     plot([0:Imgh],Imgw,'k-','MarkerSize',4);
%     plot(Imgh,[0:Imgw],'k-','MarkerSize',4);
    plot([0 Imgh],[Imgw Imgw],'k-','LineWidth',3);
    plot([Imgh Imgh],[0 Imgw],'k-','LineWidth',3);
    %axis([0 Imgh 0 Imgw])
    xlim([0 Imgh]);
    ylim([0 Imgw]);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    set(hb,'Position',[680   549   560   420]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_All_NR_fixs_models' printpostfix],printmode,printoption);
end

save(['Mat/NR_R_fixationmaps_' type '.mat'],'NRbinarymask','Rbinarymask');
