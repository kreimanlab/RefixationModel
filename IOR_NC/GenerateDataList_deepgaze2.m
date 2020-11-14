clear all; close all; clc;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

fix = [27 158; 31 67; 121 19; 203 67; 196 156; 108  195];

type = 'waldo';

if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
  
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
    
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
    
end

fileID = fopen(['Datalist/sal_deepgaze2_' type '.txt'],'w');
for imgID = 1: NumStimuli/2
        
if strcmp(type, 'array')        
    string1 = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli_array_screen_inference/array_' num2str(imgID) '.jpg'];
elseif strcmp(type, 'waldo')
    string1 = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean/img_id_' sprintf('%03d',imgID) '.jpg'];
else
    string1 = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gray' sprintf('%03d',imgID) '.jpg'];
end
fprintf(fileID, '%s\n', string1);

end
fclose(fileID);