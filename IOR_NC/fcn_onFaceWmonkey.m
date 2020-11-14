function [ faceflag ] = fcn_onFaceWmonkey( fixx, fixy, imgID, flag )
%FCN_ONFACEWMONKEY Summary of this function goes here
%   Detailed explanation goes here

    faceflag = zeros(size(fixx));
    if flag ~= 0
        mask = imread(['/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/face_clean/mask_' num2str(imgID) '.png']);
        for f = 2:length(fixx)
            if mask(fixy(f),fixx(f)) == 1
                faceflag(f) = 1;
            end
        end
    end

end

