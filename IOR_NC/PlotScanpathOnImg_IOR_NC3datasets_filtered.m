clear all; close all; clc;

type = 'naturalsaliency'; %waldo, naturaldesign, array, naturalsaliency

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
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    MaxPlotFix = 30;
    xtickrange = [1 5:5:MaxPlotFix];
    
elseif strcmp(type, 'naturalsaliency')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
        'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'}; %natural design
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

marksizedva = 43/2; %degree of visual angles to pixels
Gsize = 130; Gvar = 25; %gaussian filter specs

if strcmp(type, 'naturalsaliency')
    centerR = ones(2, NumStimuli/2)*5000;    
else
    load(['Mat/GTRatioList_' type '.mat'],'centerR'); %centerR(1,:) horizontal 1280;
end

[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

%hb = figure;
radiuscircle = 10; %
sidesquare = 35;

matlist = dir(['Mat/IOReg_*']);

binarymask = zeros(Imgw, Imgh);
for SubjID = 1:length(subjlist)
    for imgID = [127] %1:NumStimuli/2

display(['subjid: ' num2str(SubjID) '; imgID: ' num2str(imgID) ]);
%waldo: 2,8    2,26    3,3  3,6    
%array: 1,10    1,14    1,25     1,31
%naturaldesign: 1,105   1,134  1,139  1,145
%naturalsaliency: 2,46  3,64  3,116  3,131

%chanege to models
%waldo: 6 12 30 39
%array: 6 19 20 39  
%naturaldesign: 3 226 134 169
%naturalsaliency: 4 12 172 181

%selected
%naturalsaliency: 12
%naturaldesign: 169
%array: 39
%waldo: 39

%selected_consistency refix
%naturalsaliency: 127
%naturaldesign: 23
%waldo: 24
%array: 40

%% pre-filter whether it satisfies 
ImgSelected = imgID;
subjectid = subjlist{SubjID};

load(['Mat_IOR_' type '/' subjectid '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

if strcmp(type, 'naturalsaliency')
    if isempty(overlappairsnt)
        continue;
    end
else
    if isempty(overlappairst) && isempty(overlappairsnt)
        continue;
    end
end

filename = ['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/Code/ProcessScanpath_' type '/' subjectid '.mat'];
load(filename);
PosX = FixData.Fix_posx;
PosY = FixData.Fix_posy;
PosX = PosX(seqInd);
PosY = PosY(seqInd);
    
posx = PosX{ImgSelected};
posy = PosY{ImgSelected};
NumFix1 = length(posx);
posx = posx(1:end); %do not remove first fixation at center
posy = posy(1:end); %always start the first fixation in the center

% if length(posx) > 10 %prefer examples with <= 10 fixations
%     continue;
% end

if strcmp(type, 'array')
    posxcopy = posx;
    posycopy = posy;

    for ctype = 1:size(fixC,1)
        posx(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,1);
        posy(find(posxcopy == fixO(ctype,1) & posycopy == fixO(ctype,2))) = fixC(ctype,2);
    end
end

%% the first presentation (before month)
        
if strcmp(type, 'array')        
    img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli_array_screen_inference/array_' num2str(imgID) '.jpg']);
elseif strcmp(type, 'waldo')
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
        %text(double(posxqq)+35,double(posyqq)+35,fixnumstr{1},'Color','b','FontSize',30, 'FontWeight','Bold'); 
    else
        %text(double(posxqq)-50,double(posyqq)-50,fixnumstr{1},'Color','b','FontSize',30, 'FontWeight','Bold');
    end
    %if qq >= 2
        %RGB = insertShape(RGB,'Line',[int32(posx(qq-1)) int32(posy(qq-1)) int32(posx(qq)) int32(posy(qq))],'Color','y','LineWidth',10);    
    %end
end

for qq = 1: length(posx)
    fixnumstr = {num2str(qq-1)}; 
    %RGB = insertShape(RGB,'Circle',[int32(posx(qq)) int32(posy(qq)) radiuscircle],'Color','y','LineWidth',10);
    %plot(int32(posx(qq)), int32(posy(qq)), 'Color','y', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
    
    %RGB = insertText(RGB,[int32(posx(qq)) int32(posy(qq))], fixnumstr,'BoxColor','r','TextColor','white','FontSize',50);
    posxqq = posx(qq); posyqq = posy(qq);
    %text(double(posxqq),double(posyqq),fixnumstr{1},'Color','w','FontSize',50); 
    if qq >= 2
        %RGB = insertShape(RGB,'Line',[int32(posx(qq-1)) int32(posy(qq-1)) int32(posx(qq)) int32(posy(qq))],'Color','y','LineWidth',10);    
        %annotation('line',[int32(posx(qq-1)) int32(posy(qq-1))],[int32(posx(qq)) int32(posy(qq))]);
        %plot([int32(posx(qq-1)) int32(posx(qq))],[int32(posy(qq-1)) int32(posy(qq))],'Color','y','LineWidth',4);
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
    
    if int32(posx(qq1)) > 0 && int32(posx(qq1))<=Imgh && int32(posy(qq1)) > 0 && int32(posy(qq1))<=Imgw 
        %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
        binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    end
    if int32(posx(qq2)) > 0 && int32(posx(qq2))<=Imgh && int32(posy(qq2)) > 0 && int32(posy(qq2))<=Imgw
        binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
        %binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    end
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
    plot(int32(posx(qq1)), int32(posy(qq1)), 'Color','r', 'Marker','o','MarkerSize',marksizedva, 'LineWidth',6);
    %RGB = insertShape(RGB,'Rectangle',[int32(posx(qq2))-sidesquare/2 int32(posy(qq2))-sidesquare/2 sidesquare sidesquare],'Color','g','LineWidth',9);
    plot(int32(posx(qq2)), int32(posy(qq2)), 'Color','r', 'Marker','^','MarkerSize',marksizedva, 'LineWidth',6);
    
    if int32(posx(qq1)) > 0 && int32(posx(qq1))<=Imgh && int32(posy(qq1)) > 0 && int32(posy(qq1))<=Imgw 
        %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
        binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    end
    if int32(posx(qq2)) > 0 && int32(posx(qq2))<=Imgh && int32(posy(qq2)) > 0 && int32(posy(qq2))<=Imgw
        binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
        %binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    end
  end
end

%RGB = imresize(RGB, [480 640]);
%subplot(2,3,1);
%imshow(RGB);



set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
['/home/mengmi/Desktop/EPSfigs/visEgs/' type '/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) printpostfix]

%print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' type '/' type '_' num2str(SubjID)  '_imgid_' num2str(imgID) printpostfix],printmode,printoption);
print(hb,['/home/mengmi/Desktop/EPSfigs/Consistency_visEgs/' type '/' type '_' num2str(SubjID)  '_imgid_' num2str(imgID) printpostfix],printmode,printoption);

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

hb = figure;
G = fspecial('gaussian',[Gsize Gsize], Gvar);            
saliency = imfilter(binarymask,G,'same');
saliency = mat2gray(saliency);
imshow(heatmap_overlay(img,saliency));

set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' type '/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) '_sal' printpostfix],printmode,printoption);
print(hb,['/home/mengmi/Desktop/EPSfigs/Consistency_visEgs/' type '/' type '_' num2str(16)  '_imgid_' num2str(imgID) printpostfix],printmode,printoption);
