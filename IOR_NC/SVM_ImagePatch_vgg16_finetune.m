clear all; close all; clc;

type = 'naturaldesign';
Kfold = 5;
correct = [];

%read in all images for return
%0: non return; 1: return
for i = 1:Kfold
    
    WriteDir = ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '_crossval_' num2str(i) '_test/'];
    Rimglist = dir([WriteDir '*.mat']);
    
    for m = 1:length(Rimglist)
        load([WriteDir Rimglist(m).name(1:end-4) '.mat']);
        img = double(softmax(double(ps')));
        [a pred] = max(img);
        if strfind(Rimglist(m).name,'nonReturn')
            gt = 1;
        else
            gt = 2;
        end
        
        correct = [correct; pred == gt];
    end
end

accu = double(correct);
display(['mean = ' num2str(mean(double(accu)))]);
display(['std = ' num2str(std(double(accu))/sqrt(length(accu)))]);
