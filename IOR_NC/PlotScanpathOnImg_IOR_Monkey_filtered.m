clear all; close all; clc;

type = 'wmonkey';  %wmonkey_conv_only



%wmonkey_conv_only

Gsize = 130; Gvar = 25; %gaussian filter specs
%wmonkey, cmonkey, wmonkey_conv_only, cmonkey_conv_only
%wmonkey_classi
subtype = strsplit(type, '_');
subtype = subtype{1};

if strcmp(subtype, 'cmonkey')
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuli/';
else
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli/';
end

marksizedva = 39.7; %degree of visual angles to pixels

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
load(['Mat/' type '_Fix.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

%hb = figure;
radiuscircle = 10; %
sidesquare = 35;


%wmonkey_conv_only: 6, 15, 25, 43
%wmonkey: 6, 15, 25, 43
%cmonkey_conv_only: 20, 55, 62, 138, 163, 195, 229
%cmonkey: 17, 20, 146, 263 

%selected examples
%wmonkey_conv_only: 6
%wmonkey: 6
%cmonkey_conv_only: 20
%cmonkey: 20 

%selected examples for consistency
%wmonkey: 91
%cmonkey: 493
%2453, 81 for wmonkey
%64 73 80 93 94
for loopy = [1]

binarymask = zeros(imgsize, imgsize);
selectedimgID = loopy; %64; 
[a] = strcmp(Fix_pic{selectedimgID},Fix_pic);
[duplicatesind b] = find(a==1);

if strcmp(type,'wmonkey_conv_only') || strcmp(type,'cmonkey_conv_only')
    duplicatesind = duplicatesind(1);
end

for imgID = duplicatesind' %1:length(Fix_posx)

display(['imgID: ' num2str(imgID) ]);

%% pre-filter whether it satisfies 
ImgSelected = imgID;

load(['Mat_IOR_' type '/' type '_stimuli_' num2str(imgID) '.mat'],'overlappairst','overlappairsnt');

if isempty(overlappairsnt)
    continue;
end

PosX = Fix_posx;
PosY = Fix_posy;
    
posx = PosX{ImgSelected};
posy = PosY{ImgSelected};
posx = posx(1:end); %do not remove first fixation at center
posy = posy(1:end); %always start the first fixation in the center


%% the first presentation (before month)
[ImgFolder Fix_pic{ImgSelected}]
       
img = imread([ImgFolder Fix_pic{ImgSelected}]) ;    
img = imresize(img, [imgsize imgsize] );


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
        %text(double(posxqq)-35,double(posyqq)-35,fixnumstr{1},'Color','b','FontSize',30, 'FontWeight','Bold');
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
  
    if int32(posx(qq1)) > 0 && int32(posx(qq1))<=imgsize && int32(posy(qq1)) > 0 && int32(posy(qq1))<=imgsize 
        %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
        binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    end
    if int32(posx(qq2)) > 0 && int32(posx(qq2))<=imgsize && int32(posy(qq2)) > 0 && int32(posy(qq2))<=imgsize
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
  
    if int32(posx(qq1)) > 0 && int32(posx(qq1))<=imgsize && int32(posy(qq1)) > 0 && int32(posy(qq1))<=imgsize 
        %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
        binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
    end
    if int32(posx(qq2)) > 0 && int32(posx(qq2))<=imgsize && int32(posy(qq2)) > 0 && int32(posy(qq2))<=imgsize
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
%print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' subtype '/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) printpostfix],printmode,printoption);
print(hb,['/home/mengmi/Desktop/EPSfigs/Consistency_visEgs/' subtype '/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) printpostfix],printmode,printoption);


%imwrite(RGB, ['Figures/IOR_RGB_first_beforemonth_' num2str(length(posx))  '_subjid_' num2str(SubjID) '_imgid_' num2str(imgID) '.jpg']);
%title(['first; numFix= ' num2str(length(posx))]);


%subplot(2,3,3);
%imshow(target);
%title(TI);

%subplot(2,3,6);
%imshow(gt);

%pause;

end
%pause;
end

if strcmp(type, subtype)

hb = figure;
G = fspecial('gaussian',[Gsize Gsize], Gvar);            
saliency = imfilter(binarymask,G,'same');
saliency = mat2gray(saliency);
imshow(heatmap_overlay(img,saliency));

set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' subtype '/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) '_sal' printpostfix],printmode,printoption);
print(hb,['/home/mengmi/Desktop/EPSfigs/Consistency_visEgs/' subtype '/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) '_sal' printpostfix],printmode,printoption);

end



