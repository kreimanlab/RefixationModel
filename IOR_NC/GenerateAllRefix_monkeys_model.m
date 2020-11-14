clear all; close all; clc;

type = 'wmonkey_conv_only';   %'cmonkey_conv_only' 'wmonkey_conv_only'

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
imgnamelist = unique(Fix_pic);

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

%hb = figure;
radiuscircle = 10; %
sidesquare = 35;

RefixMaps = [];
binarymask = zeros(imgsize, imgsize);
% binarymaskT = zeros(Imgw, Imgh);
% binarymaskNT = zeros(Imgw, Imgh);
binaryw = [];binaryh = [];

hb = figure; hold on;

for stimulusID = 1:length(imgnamelist)

%     binaryw = [];binaryh = [];
%     binarywNT = []; binaryhNT=[];


    [a] = strcmp(imgnamelist{stimulusID},Fix_pic);
    [duplicatesind b] = find(a==1);

    for imgID = duplicatesind'         

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
        %[ImgFolder Fix_pic{ImgSelected}]

        img = imread([ImgFolder Fix_pic{ImgSelected}]) ;    
        img = imresize(img, [imgsize imgsize] );

        RGB = img;

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
            
            if int32(posx(qq1)) > 0 && int32(posx(qq1))<=imgsize && int32(posy(qq1)) > 0 && int32(posy(qq1))<=imgsize 
                binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%                 binarymaskNT(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%                 binarymask(int32(posy(qq1)), int32(posx(qq1))) = 0;
%                 binaryw = [binaryw int32(posy(qq1))];
%                 binaryh = [binaryh int32(posx(qq1))];
                plot(posx(qq1), posy(qq1), 'ko','markersize',2);
%                 binarywNT = [binarywNT int32(posy(qq1))];
%                 binaryhNT = [binaryhNT int32(posx(qq1))];
%                 subjects = [subjects ImgSelected];
            end
            if int32(posx(qq2)) > 0 && int32(posx(qq2))<imgsize && int32(posy(qq2)) > 0 && int32(posy(qq2))<imgsize
                %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
            end  

          end
        end
        

    end

    
end

Rbinarymask = binarymask;
% hb = figure;
% imshow(mat2gray(binarymask));
set(gca,'linewidth',3);
plot([0 imgsize],[imgsize imgsize],'k-','LineWidth',3);
plot([imgsize imgsize],[0 imgsize],'k-','LineWidth',3);
%axis([0 Imgh 0 Imgw])
xlim([0 imgsize]);
ylim([0 imgsize]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
set(hb,'Position',[680   549   420   420]);      
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_AllRefix_model' printpostfix],printmode,printoption);

%% non-return
close all;

binarymask = zeros(imgsize, imgsize);
% binarymaskT = zeros(Imgw, Imgh);
% binarymaskNT = zeros(Imgw, Imgh);
binaryw = [];binaryh = [];

hb = figure; hold on;

for stimulusID = 1:length(imgnamelist)

%     binaryw = [];binaryh = [];
%     binarywNT = []; binaryhNT=[];


    [a] = strcmp(imgnamelist{stimulusID},Fix_pic);
    [duplicatesind b] = find(a==1);

    for imgID = duplicatesind'         

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
        %[ImgFolder Fix_pic{ImgSelected}]

        img = imread([ImgFolder Fix_pic{ImgSelected}]) ;    
        img = imresize(img, [imgsize imgsize] );

        RGB = img;

        overlappairst = overlappairsnt;
        
        if isempty(overlappairst)
            ind = overlappairst(:,1:2);
            ind = unique(ind(:) + 1);
            allind = [1:length(posx)];
            allind(ind) = [];
        else
            allind = [1:length(posx)];
        end
        
        for qq1 = allind
            
            if int32(posx(qq1)) > 0 && int32(posx(qq1))<=imgsize && int32(posy(qq1)) > 0 && int32(posy(qq1))<=imgsize 
                binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%                 binarymaskNT(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%                 binarymask(int32(posy(qq1)), int32(posx(qq1))) = 0;
%                 binaryw = [binaryw int32(posy(qq1))];
%                 binaryh = [binaryh int32(posx(qq1))];
                plot(posx(qq1), posy(qq1), 'ko','markersize',2);
%                 binarywNT = [binarywNT int32(posy(qq1))];
%                 binaryhNT = [binaryhNT int32(posx(qq1))];
%                 subjects = [subjects ImgSelected];
            end
            if int32(posx(qq2)) > 0 && int32(posx(qq2))<imgsize && int32(posy(qq2)) > 0 && int32(posy(qq2))<imgsize
                %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
            end  

        end
        
        

    end

    
end

NRbinarymask = binarymask;
% hb = figure;
% imshow(mat2gray(binarymask));
set(gca,'linewidth',3);
plot([0 imgsize],[imgsize imgsize],'k-','LineWidth',3);
plot([imgsize imgsize],[0 imgsize],'k-','LineWidth',3);
%axis([0 Imgh 0 Imgw])
xlim([0 imgsize]);
ylim([0 imgsize]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
set(hb,'Position',[680   549   420   420]);      
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_All_NR_fixs_models' printpostfix],printmode,printoption);

save(['Mat/NR_R_fixationmaps_' type '.mat'],'NRbinarymask','Rbinarymask');




