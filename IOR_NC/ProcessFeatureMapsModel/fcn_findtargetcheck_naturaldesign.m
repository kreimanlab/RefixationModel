function [mouseclickwrong, Rfixx, Rfixy, scoremat] = fcn_findtargetcheck_naturaldesign(fixx, fixy, i)
%FCN_FINDTARGETCHECK Summary of this function goes here
%   Detailed explanation goes here

    w = 1024;
    h = 1280;

    arraysize = 80;
    receptiveSize = 200;
    scoremat = zeros(1,arraysize);
    FcTHRESHOLD = 0.3066; %0.3066
    
    path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(i) '.jpg' ];
    gt = imread(path);
    gt = imresize(gt,[w,h]);
    gt = mat2gray(gt);
    gt = im2bw(gt,0.5);
    gtimg = double(gt);
    
    %path = ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CRecog_waldo/img_id_' sprintf('%03d',i) '.jpg' ];
    path = ['/media/mengmi/KLAB15/Mengmi/Proj_memory/compiled/CRecog_naturaldesign/gray' sprintf('%03d',i) '.jpg' ];
    recogmap = imread(path);
    recogmap = imresize(recogmap,[w,h]);
    recogmap = mat2gray(recogmap);    
    recogmap = double(recogmap);

    mouseclickwrong = 0;
    
    for f = 1:length(fixx)
        
        x = fixx(f); y = fixy(f);
%         display(f);
%         display(x);
%         display(y);
        fixatedPlace_leftx = x - receptiveSize/2 + 1;
        fixatedPlace_rightx = x + receptiveSize/2;
        fixatedPlace_lefty = y - receptiveSize/2 + 1;
        fixatedPlace_righty = y + receptiveSize/2;

        if fixatedPlace_leftx < 1
            fixatedPlace_leftx = 1;
        end
        if fixatedPlace_lefty < 1
            fixatedPlace_lefty = 1;
        end
        if fixatedPlace_rightx > size(gt,1)
            fixatedPlace_rightx = size(gt,1);
        end
        if fixatedPlace_righty > size(gt,2)
            fixatedPlace_righty = size(gt,2);
        end
        fixatedPlace = gt(fixatedPlace_leftx:fixatedPlace_rightx, fixatedPlace_lefty:fixatedPlace_righty);

        r = recogmap(fixatedPlace_leftx:fixatedPlace_rightx, fixatedPlace_lefty:fixatedPlace_righty);
        r = r(:);
        %mean(r)
        if (sum(sum(fixatedPlace)) <= 0) && (mean(r) >= FcTHRESHOLD)
            mouseclickwrong = mouseclickwrong + 1;
        end
        
        if sum(sum(fixatedPlace)) > 0 
            %recogprob = rand;
            recogprob = recogmap(x,y);
            %display(recogprob);
            
            %if recogprob <= FcTHRESHOLD
            if recogprob >= FcTHRESHOLD
                found = 1;
                break;
            else
                found = 0;
            end
        else
            found = 0;
        end
    end
    
    if found == 1
        scoremat(1,f) = 1;
        Rfixx = fixx(1:f);
        Rfixy = fixy(1:f);
    else
        Rfixx = fixx;
        Rfixy = fixy;
    end

    mouseclickwrong = mouseclickwrong/length(Rfixx);
end