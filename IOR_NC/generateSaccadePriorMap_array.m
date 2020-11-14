clear all; close all; clc;

%pdf for saccade in arrays _ total
    %1: 0.778; 
    %2: 0.129; 
    %3: 0.04778
    %pdf for saccade in arrays _ cross1
    %1: 0.784; 
    %2: 0.124; 
    %3: 0.043
    %pdf for saccade in arrays _ cross2
    %1: 0.773; 
    %2: 0.134; 
    %3: 0.051
    
prob = [0.778 0.129 0.04778];
%prob = [0.784 0.124 0.043];
%prob = [0.773 0.134 0.051];


prior = [2 6 3 5 4 ;...
    1 3 4 5 6;...
    2 4 1 5 6;...
    3 5 2 6 1;...
    4 6 3 1 2;...
    1 5 2 4 3];


for i = 1: 6
    
    priormat = zeros(756,676);
    
    chosenmask = load(['Datasets/ProcessScanpath_array/saliencyMask/mask' num2str(prior(i,1)) '.mat']);
    chosenmask = chosenmask.mask*prob(1);
    priormat = priormat + chosenmask;
    
    chosenmask = load(['Datasets/ProcessScanpath_array/saliencyMask/mask' num2str(prior(i,2)) '.mat']);
    chosenmask = chosenmask.mask*prob(1);
    priormat = priormat + chosenmask;
    
    chosenmask = load(['Datasets/ProcessScanpath_array/saliencyMask/mask' num2str(prior(i,3)) '.mat']);
    chosenmask = chosenmask.mask*prob(2);
    priormat = priormat + chosenmask;
    
    chosenmask = load(['Datasets/ProcessScanpath_array/saliencyMask/mask' num2str(prior(i,4)) '.mat']);
    chosenmask = chosenmask.mask*prob(2);
    priormat = priormat + chosenmask;
    
    chosenmask = load(['Datasets/ProcessScanpath_array/saliencyMask/mask' num2str(prior(i,5)) '.mat']);
    chosenmask = chosenmask.mask*prob(3);
    priormat = priormat + chosenmask;
    
    %priormat = mat2gray(priormat);
    
    %if i == 1
        hb = figure;
        printpostfix = '.eps';
        printmode = '-depsc'; %-depsc
        printoption = '-r200'; %'-fillpage'
        imshow(priormat);
        colorbar;
        set(hb,'Units','Inches');
        pos = get(hb,'Position');
        set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

        %print(hb,['/home/mengmi/Proj/Proj_VS/HumanExp/githuman/Figures/fig_S02G_array_2Dsaccadeprior_' num2str(i)  printpostfix],printmode,printoption);

    %end
    
    priormask = priormat;
    save(['Datasets/ProcessScanpath_array/saliencyMask/priormask' num2str(i) '.mat'],'priormask');
    %save(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/saliencyMask/priormask' num2str(i) '_cross2.mat'],'priormask');
    
end









