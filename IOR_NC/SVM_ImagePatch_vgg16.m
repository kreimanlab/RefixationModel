clear all; close all; clc;

type = 'array';

WriteDir = ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '/'];
NumSample = 400; %samples per class
PCcomp = 500;
Kfold = 5;
Rmat = [];
NRmat = [];

%read in all images for return
Rimglist = dir([WriteDir 'return/*.mat']);
for i = 1:length(Rimglist)
    load([WriteDir 'return/' Rimglist(i).name(1:end-4) '.mat']);
    img = double(x(:));
    Rmat = [Rmat; img'];
end

%read in all images for non-return
Rimglist = dir([WriteDir 'nonreturn/*.mat']);
for i = 1:length(Rimglist)
    load([WriteDir 'nonreturn/'  Rimglist(i).name(1:end-4) '.mat']);
    img = double(x(:));
    NRmat = [NRmat; img'];
end

save(['Mat/svm_vgg16_data_' type '.mat'],'Rmat','NRmat');

load(['Mat/svm_vgg16_data_' type '.mat'],'Rmat','NRmat');
Data = [Rmat; NRmat];

% PCA dim reduction (optional)
[coeff,score,~,~,explained,mu]  = pca(Data,'NumComponents',PCcomp);
%reducedDimension = coeff(:,1:PCcomp);
%reducedData = Data * reducedDimension;
%Data  = reducedData;
Data  = score;

%process data and labels
Data = Data(:,1:PCcomp);
label    = cell(size(Data,1),1);
gt = [ones(1,length(label)/2) 2*ones(1,length(label)/2)];
label(1:length(label)/2) = {'Return'};
label(length(label)/2+1:end) = {'NonReturn'};

display(['training svm classifer']);
SVMModel = fitcsvm(Data, label,'Standardize',true,'KernelFunction','Linear','KernelScale','auto');
display(['cross val svm classifer']);
CVSVMModel = crossval(SVMModel,'KFold',Kfold);
display(['predicting svm classifer']);
[labelPred,scorePred] = kfoldPredict(CVSVMModel);
accu = strcmp(labelPred, label);
display(['mean = ' num2str(mean(double(accu)))]);
display(['std = ' num2str(std(double(accu))/sqrt(length(accu)))]);
