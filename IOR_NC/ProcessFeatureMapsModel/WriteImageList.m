% % cd to downloaded folder
% clear all; close all; clc;
% 
% % %% Wmonkey
% filename = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/raw/paul_20191111-bhv.h5';
% fileIDimg = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/imglist_wmonkey.txt','w');
% imgnameList = h5read(filename,'/im_fns');
% ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli/';
% imgnameList = unique(imgnameList);
% %imgnameList = cellfun(@(imgname) imgname(find(~isspace(imgname))), imgnameList);
% 
% for i = 1:length(imgnameList)
%     display(i);
%     
%     imgname = imgnameList{i};
%     imgname = imgname(find(~isspace(imgname)));
%     %img = imread([ImgFolder imgname]);
%     fprintf(fileIDimg,'%s\n',[imgname]);
% end
% fclose(fileIDimg);
% 
% clear all; close all; clc;
% %% Naturaldesign
% NumImg = 240;
% fileIDimg = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/imglist_naturaldesign.txt','w');
% fileIDimgTarget = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/targetlist_naturaldesign.txt','w');
% for imgID = 1:NumImg
%     target = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/targetgray' sprintf('%03d',imgID) '.jpg']);
%     targetrgb = cat(3,target,target,target);
%     imwrite(targetrgb,['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered_gray_3channels/targetgray' sprintf('%03d',imgID) '.jpg']); 
% %     img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gray' sprintf('%03d',imgID) '.jpg']);
% %     imgrgb = cat(3,img,img,img);
%     %imwrite(imgrgb,['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered_gray_3channels/gray' sprintf('%03d',imgID) '.jpg']);
%     fprintf(fileIDimg,'%s\n',['gray' sprintf('%03d',imgID) '.jpg']);
%     fprintf(fileIDimgTarget,'%s\n',['targetgray' sprintf('%03d',imgID) '.jpg']);
%     ['gray' sprintf('%03d',imgID) '.jpg']
% end
% fclose(fileIDimgTarget);
% fclose(fileIDimg);



%clear all; close all; clc;

% %% Cmonkey
% load(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/Mat/CE_cmonkey.mat']);
% compiledname = {};
% 
% for i = 1:length(CE)
%     imgn = [CE(i).imgname CE(i).imgext];
%     compiledname = [compiledname imgn];
% end
% imgnameList = unique(compiledname);
% 
% fileIDimg = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/imglist_cmonkey.txt','w');
% for i = 1:length(imgnameList)
%     display(i);
%     
%     imgname = imgnameList{i};
%     
%     ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuli/';
%     
%     %imgname = imgname(find(~isspace(imgname)));
%     img = imread([ImgFolder imgname]);
%     if length(size(img)) ~= 3
%         img = cat(3, img, img,img);
%     end
%     
%     %imshow(img);
%     imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuliRGB/' imgname ]);
%     
%     fprintf(fileIDimg,'%s\n',[imgname]);
% end
% fclose(fileIDimg);

% clear all; close all; clc;
% %% Waldo
% NumImg = 134/2;
% ImgFolder = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Waldo/clean/img_id_' ];
% %fileIDimg = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/imglist_waldo.txt','w');
% fileIDimgTarget = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/targetlist_waldo.txt','w');
% 
% for imgID = 1:NumImg
%     
% %     imgname = [sprintf('%03d',imgID) '.jpg'];
% %     img = imread([ImgFolder imgname]);
% %     if length(size(img)) ~= 3
% %         img = cat(3, img, img,img);
% %     end
% %     
% %     %imshow(img);
% %     %imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuliRGB/' imgname ]);
% %     fprintf(fileIDimg,'%s\n',['img_id_' sprintf('%03d',imgID) '.jpg']);
%     fprintf(fileIDimgTarget, '%s\n',['waldo.JPG']);
% end
% fclose(fileIDimgTarget);
% %fclose(fileIDimg);

clear all; close all; clc;
%% arrays
NumImg = 600/2;
% load(['/media/mengmi/TOSHIBABlue1/Proj_VS/HumanExp/githuman/SubjectArray/array.mat']);
% EntryImgFolder = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/FinalSelected/cate'];
% ImgFolder = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli/array_'];
% fileIDentry = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/entrylist_array.txt','w');
% fileIDimg = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/imglist_array.txt','w');
fileIDtarget = fopen('/home/mengmi/Projects/Proj_curiosity/pytorch/gym-scanpathpred/gym_scanpathpred/envs/datalist/targetlist_array.txt','w');
arraysize = 6;
boxsize = 224;

for imgID = 1:NumImg
    imgID
    
%         
%     trial = MyData(imgID);
%     for numpic = 1:arraysize
%         img = imread([EntryImgFolder num2str(trial.arraycate(numpic)) '/img' num2str(trial.arrayimgnum(numpic)) '.jpg']);
%         img = imresize(img,[boxsize boxsize]);
%         
%         if length(size(img)) ~= 3
%             img = cat(3, img, img,img);
%         end
%     
%         imwrite(img, ['/media/mengmi/KLAB15/Mengmi/Proj_memory/Entry_array/img_' num2str(imgID) '_' num2str(numpic) '.jpg']);
%         fprintf(fileIDentry,'%s\n',['img_' num2str(imgID) '_' num2str(numpic) '.jpg']);
%         
%     end
%     
%     
%     
%     imgname = [num2str(imgID) '.jpg'];
%     img = imread([ImgFolder imgname]);
%     if length(size(img)) ~= 3
%         img = cat(3, img, img,img);
%     end
%     
% %     imshow(img);
%     imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuliRGB/array_' imgname ]);
%     fprintf(fileIDimg,'%s\n',['array_' num2str(imgID) '.jpg']);
%     
    imgname = ['target_' num2str(imgID) '.jpg'];
    img = imread(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuli/' imgname]);
    if length(size(img)) ~= 3
        img = cat(3, img, img,img);
    end
    
%     imshow(img);
    imwrite(img, ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/stimuliRGB/' imgname ]);
    
    for nn = 1:arraysize
        fprintf(fileIDtarget,'%s\n',['target_' num2str(imgID) '.jpg']);
    end
    
end

% fclose(fileIDentry);
% fclose(fileIDimg);
fclose(fileIDtarget);






