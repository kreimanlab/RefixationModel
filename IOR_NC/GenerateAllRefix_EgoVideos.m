clear all; close all; clc;

%T1 long trials; 0,T2; refixations; (VS2,3)
%same num of fixations; 8 carlos remove trials; first 8
%scene understanding, role of refixations in scene understanding adn image captioning 

type = 'os'; %os, egteaplus

load(['Mat/' type '_Fix.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
% printpostfix = '.png';
% printmode = '-dpng'; %-depsc
printoption = '-r500'; %'-fillpage'

%% plot return fixs
imgsize0 = 1024;
imgsize1 = 1280;
binarymask = zeros(imgsize0, imgsize1);
binaryw = [];binaryh = [];

hb = figure; hold on;
for imgID = 1:length(Fix_posx)

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

        if int32(posx(qq1)) > 0 && int32(posx(qq1))<imgsize1 && int32(posy(qq1)) > 0 && int32(posy(qq1))<imgsize0 
            binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%             binaryw = [binaryw int32(posy(qq1))];
%             binaryh = [binaryh int32(posx(qq1))];

            plot(posx(qq1), imgsize0 - posy(qq1), 'ko','markersize',2);

%             pause(0.01);
%             imshow(mat2gray(binarymask));drawnow;
%             int32(posy(qq1))
        end

      end
    end
end

Rbinarymask = binarymask;
Imgh = imgsize1; Imgw = imgsize0;
set(gca,'linewidth',3);
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
% binarymask = binarymask(1:imgsize0,1:imgsize1);
% hb = figure;
% imshow(mat2gray(binarymask));
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_AllRefix_humans' printpostfix],printmode,printoption);

%% plot non-return fixs
close all;
imgsize0 = 1024;
imgsize1 = 1280;
binarymask = zeros(imgsize0, imgsize1);
binaryw = [];binaryh = [];

hb = figure; hold on;
for imgID = 1:length(Fix_posx)

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

    overlappairst = overlappairsnt;
    
    if isempty(overlappairst)
        ind = overlappairst(:,1:2);
        ind = unique(ind(:) + 1);
        allind = [1:length(posx)];
        allind(ind) = [];
    else
        allind = [1:length(posx)];
    end
    
%     if ~isempty(overlappairst)
%       for zz = 1:size(overlappairst,1)
%         if length(posx) == overlappairst(zz,3)
%             qq1 = overlappairst(zz,1);
%             qq2 = overlappairst(zz,2);
%         else
%             qq1 = overlappairst(zz,1)+1;
%             qq2 = overlappairst(zz,2)+1;
%         end
    for qq1  = allind
        if int32(posx(qq1)) > 0 && int32(posx(qq1))<imgsize1 && int32(posy(qq1)) > 0 && int32(posy(qq1))<imgsize0 
            binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%             binaryw = [binaryw int32(posy(qq1))];
%             binaryh = [binaryh int32(posx(qq1))];

            plot(posx(qq1), imgsize0 - posy(qq1), 'ko','markersize',2);

%             pause(0.01);
%             imshow(mat2gray(binarymask));drawnow;
%             int32(posy(qq1))
        end

      
    end
end

NRbinarymask = binarymask;
Imgh = imgsize1; Imgw = imgsize0;
set(gca,'linewidth',3);
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
% binarymask = binarymask(1:imgsize0,1:imgsize1);
% hb = figure;
% imshow(mat2gray(binarymask));
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['/home/mengmi/Desktop/EPSfigs/RefixAllMap/' type '_All_NR_fixs_humans' printpostfix],printmode,printoption);

save(['Mat/NR_R_fixationmaps_' type '.mat'],'NRbinarymask','Rbinarymask');


