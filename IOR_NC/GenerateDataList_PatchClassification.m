clear all; close all; clc;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

type = 'array';
fileID = fopen(['Datalist/patchclassi_' type '.txt'],'w');
WriteDir = ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/PatchClassification/' type '/'];

Rimglist = dir([WriteDir 'return/*.jpg']);
for i = 1:length(Rimglist)
    string1 = [WriteDir 'return/' Rimglist(i).name];
    string1 = string1(1:end-4);
    fprintf(fileID, '%s\n', string1);
end
Rimglist = dir([WriteDir 'nonreturn/*.jpg']);
for i = 1:length(Rimglist)
    string1 = [WriteDir 'nonreturn/' Rimglist(i).name];
    string1 = string1(1:end-4);
    fprintf(fileID, '%s\n', string1);
end
fclose(fileID);