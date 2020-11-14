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

marksizedva = 43/2; %degree of visual angles to pixels

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


matlist = dir(['Mat/IOReg_*']);

for SubjID = 1:length(subjlist)
    for imgID = [4 12 172 181] %1:NumStimuli/2

display(['subjid: ' num2str(SubjID) '; imgID: ' num2str(imgID) ]);

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

%% the first presentation (before month)
        
if strcmp(subtype, 'array')        
    img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli_array_screen_inference/array_' num2str(imgID) '.jpg']);
elseif strcmp(subtype, 'waldo')
    img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean/img_id_' sprintf('%03d',imgID) '.jpg']);
else
    img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gray' sprintf('%03d',imgID) '.jpg']);
end

img = imresize(img,[1024 1280]);
%img = rgb2gray(img);

RGB = img;

hb = figure; 
imshow(RGB);hold on;

for qq = 1: length(posx)
    fixnumstr = {num2str(qq-1)};
    %fixnumstr
    %RGB = insertShape(RGB,'Circle',[int32(posx(qq)) int32(posy(qq)) radiuscircle],'Color','y','LineWidth',10);
    %RGB = insertText(RGB,[int32(posx(qq)) int32(posy(qq))], fixnumstr,'BoxColor','r','TextColor','white','FontSize',50);
    posxqq = posx(qq); posyqq = posy(qq);
    %text(double(posxqq),double(posyqq),fixnumstr{1},'Color','w','BackgroundColor','k','FontSize',50); 
    
    if posxqq>=1280/2
        text(double(posxqq)+35,double(posyqq)+35,fixnumstr{1},'Color','b','FontSize',30, 'FontWeight','Bold'); 
    else
        text(double(posxqq)-50,double(posyqq)-50,fixnumstr{1},'Color','b','FontSize',30, 'FontWeight','Bold');
    end
    %if qq >= 2
        %RGB = insertShape(RGB,'Line',[int32(posx(qq-1)) int32(posy(qq-1)) int32(posx(qq)) int32(posy(qq))],'Color','y','LineWidth',10);    
    %end
end

for qq = 1: length(posx)
    fixnumstr = {num2str(qq-1)}; 
    %RGB = insertShape(RGB,'Circle',[int32(posx(qq)) int32(posy(qq)) radiuscircle],'Color','y','LineWidth',10);
    plot(int32(posx(qq)), int32(posy(qq)), 'Color','y', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
    
    %RGB = insertText(RGB,[int32(posx(qq)) int32(posy(qq))], fixnumstr,'BoxColor','r','TextColor','white','FontSize',50);
    posxqq = posx(qq); posyqq = posy(qq);
    %text(double(posxqq),double(posyqq),fixnumstr{1},'Color','w','FontSize',50); 
    if qq >= 2
        %RGB = insertShape(RGB,'Line',[int32(posx(qq-1)) int32(posy(qq-1)) int32(posx(qq)) int32(posy(qq))],'Color','y','LineWidth',10);    
        %annotation('line',[int32(posx(qq-1)) int32(posy(qq-1))],[int32(posx(qq)) int32(posy(qq))]);
        plot([int32(posx(qq-1)) int32(posx(qq))],[int32(posy(qq-1)) int32(posy(qq))],'Color','y','LineWidth',4);
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
    %RGB = insertShape(RGB,'Circle',[int32(posx(qq1)) int32(posy(qq1)) radiuscircle],'Color','c','LineWidth',10);
    plot(int32(posx(qq1)), int32(posy(qq1)), 'Color','r', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
    
    %RGB = insertShape(RGB,'Rectangle',[int32(posx(qq2))-sidesquare/2 int32(posy(qq2))-sidesquare/2 sidesquare sidesquare],'Color','c','LineWidth',9);
    plot(int32(posx(qq2)), int32(posy(qq2)), 'Color','r', 'Marker','^','MarkerSize',marksizedva, 'LineWidth',6);
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
    %RGB = insertShape(RGB,'Circle',[int32(posx(qq1)) int32(posy(qq1)) radiuscircle ],'Color','g','LineWidth',10);
    plot(int32(posx(qq1)), int32(posy(qq1)), 'Color','m', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
    %RGB = insertShape(RGB,'Rectangle',[int32(posx(qq2))-sidesquare/2 int32(posy(qq2))-sidesquare/2 sidesquare sidesquare],'Color','g','LineWidth',9);
    plot(int32(posx(qq2)), int32(posy(qq2)), 'Color','m', 'Marker','^','MarkerSize',marksizedva, 'LineWidth',6);
  end
end

%RGB = imresize(RGB, [480 640]);
%subplot(2,3,1);
%imshow(RGB);


set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' subtype '/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) printpostfix],printmode,printoption);

%imwrite(RGB, ['Figures/IOR_RGB_first_beforemonth_' num2str(length(posx))  '_subjid_' num2str(SubjID) '_imgid_' num2str(imgID) '.jpg']);
%title(['first; numFix= ' num2str(length(posx))]);


%subplot(2,3,3);
%imshow(target);
%title(TI);

%subplot(2,3,6);
%imshow(gt);

%pause;

    end
end

