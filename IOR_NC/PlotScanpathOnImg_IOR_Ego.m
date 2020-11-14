clear all; close all; clc;

type = 'os'; %os, egteaplus

subtype = strsplit(type, '_');
subtype = subtype{1};

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

marksizedva = 32/2; %degree of visual angles to pixels

imgsize0 = 1024;
imgsize1 = 1280;


%os: 9, 10, 11, 19, 20, 23
%egteaplus: 6 7  48 451

%final selection:
%os:10, 19
%egteaplus: 48, 451

for imgID = [9, 10, 11, 19, 20, 23] %1:length(Fix_posx)

%% pre-filter whether it satisfies 
ImgSelected = imgID;

display(['imgID: ' num2str(imgID) ]);

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

% if length(posx) > 10
%     continue;
% end

%% the first presentation (before month)
%[ImgFolder Fix_pic{ImgSelected}]
xyloObj = VideoReader(Fix_pic{ImgSelected});
img = read(xyloObj,Fix_endIndex{ImgSelected});

%img = imread([ImgFolder Fix_pic{ImgSelected}]) ;    
img = imresize(img, [imgsize0 imgsize1] );


RGB = img;

imgend = RGB;
imgstart = read(xyloObj,Fix_endIndex{ImgSelected}-length(posx));
imgstart = imresize(imgstart, [imgsize0 imgsize1] );

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
        text(double(posxqq)-35,double(posyqq)-35,fixnumstr{1},'Color','b','FontSize',30, 'FontWeight','Bold');
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

% for qq = 1: length(posx)
%     fixnumstr = {num2str(qq-1)};
%     %fixnumstr
%     %RGB = insertShape(RGB,'Circle',[int32(posx(qq)) int32(posy(qq)) radiuscircle],'Color','y','LineWidth',10);
%     %RGB = insertText(RGB,[int32(posx(qq)) int32(posy(qq))], fixnumstr,'BoxColor','r','TextColor','white','FontSize',50);
%     posxqq = posx(qq); posyqq = posy(qq);
%     text(double(posxqq),double(posyqq),fixnumstr{1},'Color','w','BackgroundColor','k','FontSize',50); 
%     %if qq >= 2
%         %RGB = insertShape(RGB,'Line',[int32(posx(qq-1)) int32(posy(qq-1)) int32(posx(qq)) int32(posy(qq))],'Color','y','LineWidth',10);    
%     %end
% end

clear xyloObj;
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) printpostfix],printmode,printoption);

%imwrite(RGB, ['Figures/IOR_RGB_first_beforemonth_' num2str(length(posx))  '_subjid_' num2str(SubjID) '_imgid_' num2str(imgID) '.jpg']);
%title(['first; numFix= ' num2str(length(posx))]);

hb = figure;
imshow(imgstart);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) '_start' printpostfix],printmode,printoption);

hb = figure;
imshow(imgend);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/visEgs/' type '_' num2str(length(posx))  '_imgid_' num2str(imgID) '_end' printpostfix],printmode,printoption);


%subplot(2,3,3);
%imshow(target);
%title(TI);

%subplot(2,3,6);
%imshow(gt);

%pause;

end