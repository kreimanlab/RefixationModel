clear all; close all; clc;
type = 'naturaldesign'; %wmonkey, naturalsaliency, naturaldesign

if strcmp(type, 'wmonkey')
    imgsize = 596;
    visualdeg=39.7*imgsize/635;
elseif strcmp(type, 'naturalsaliency')
    imgsize = 1024;    
    visualdeg=43; %1024/38;
elseif strcmp(type, 'naturaldesign')
    imgsize = 1024;    
    visualdeg=43; %1024/38;
elseif strcmp(type, 'waldo')
    imgsize = 1024;    
    visualdeg=43; %1024/38;
elseif strcmp(type, 'cmonkey')
    imgsize = 596;    
    visualdeg=39.7;
else
    warning(['for object arrays; pls run "generateSaccadePriorMap_array.m"']);
end

if strcmp(type, 'array')
    
    for i = 1:6
        load(['Datasets/ProcessScanpath_array/saliencyMask/priormask' num2str(i) '.mat']);
        saccademask = mat2gray(priormask);
        imwrite(saccademask,['Figures/' type '_2Dsaccadeprior_' num2str(i) '.jpg']);
    end
    
    totalmask = load(['Datasets/ProcessScanpath_array/saliencyMask/masktotal.mat']);
    totalmask = totalmask.masktotal;
    imwrite(totalmask,['Figures/' type '_2Dsaccadeprior_' num2str(0) '.jpg']);
else
    RadiusDegConvert = visualdeg;
    load(['Mat/saccade_' type '.mat']);
    HumanDistval = [SIMRETURN_Radius SIMNONRETURN_Radius]*RadiusDegConvert;
    Imgw = imgsize; Imgh = imgsize;
    binrangespixel = [0:2:sqrt(Imgw*Imgw+Imgh*Imgh)];
    %binrangespixel = [0:1:20];
    bincountspixel = histc(HumanDistval,binrangespixel);
    bincountspixel = bincountspixel/sum(bincountspixel);
    %plot(binrangespixel,bincountspixel,'k-','LineWidth',2.5);
    %ylim([0 0.2]);

    saccademask = zeros(Imgw*2, Imgh*2);
    [row,col] = ind2sub(size(saccademask),[1:2*Imgw*2*Imgh]);
    ctrx = Imgh;
    ctry = Imgw;
    dist_ctr = sqrt( (row-ctry).^2 + (col-ctrx).^2 );
    %valdist_ctr = pdf(pd,dist_ctr);
    valdist_ctr = interp1(binrangespixel,bincountspixel,dist_ctr);
    saccademask = reshape(valdist_ctr,size(saccademask));

    hb = figure;
    %max(max(saccademask));    
    saccademask = mat2gray(saccademask);
    %max(max(saccademask))
    saccademask = imgaussfilt(saccademask,15);
    %max(max(saccademask))
    saccademask = mat2gray(saccademask);
    imshow(saccademask);
    colorbar;
    % set(hb,'Units','Inches');
    % pos = get(hb,'Position');
    % set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    % 
    % print(hb,['../Figures/fig_S02H_' type '_2Dsaccadeprior'  printpostfix],printmode,printoption);
    imwrite(saccademask,['Figures/' type '_2Dsaccadeprior.jpg']);
end