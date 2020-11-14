clear all; close all; clc;

type = 'wmonkey'; 

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

for stimulusID = 1:length(imgnamelist)

    binaryw = [];binaryh = [];
    binarywNT = []; binaryhNT=[];


    [a] = strcmp(imgnamelist{stimulusID},Fix_pic);
    [duplicatesind b] = find(a==1);

    subjects = [];
    trialid = stimulusID;

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
%                 binarymask(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
%                 binarymaskNT(int32(posy(qq1)), int32(posx(qq1))) = binarymask(int32(posy(qq1)), int32(posx(qq1))) + 1;
                binaryw = [binaryw int32(posy(qq1))];
                binaryh = [binaryh int32(posx(qq1))];
                binarywNT = [binarywNT int32(posy(qq1))];
                binaryhNT = [binaryhNT int32(posx(qq1))];
                subjects = [subjects ImgSelected];
            end
            if int32(posx(qq2)) > 0 && int32(posx(qq2))<=imgsize && int32(posy(qq2)) > 0 && int32(posy(qq2))<=imgsize
                %binarymask(int32(posy(qq2)), int32(posx(qq2))) = binarymask(int32(posy(qq2)), int32(posx(qq2))) + 1;
            end  

          end
        end
        

    end

    subjects = unique(subjects);
    
    if length(subjects) >= 2
        trial.subjects = subjects;
        trial.imgID = trialid;
        trial.binaryw = binaryw; trial.binaryh = binaryh;
        trial.binarywNT = binarywNT; trial.binaryhNT = binaryhNT;

        RefixMaps = [RefixMaps trial];
    end
    
end

save(['Mat/refixmap_consistency_' type '.mat'],'RefixMaps','-v7.3');


