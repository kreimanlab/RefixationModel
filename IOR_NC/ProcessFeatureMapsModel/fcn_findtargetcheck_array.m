function [Rfix, scoremat] = fcn_findtargetcheck_array(fix, i, trial)
%FCN_FINDTARGETCHECK Summary of this function goes here
%   Detailed explanation goes here

[gtind num] = find(  trial.arraycate == trial.targetcate);
arraysize = 6;
scoremat = zeros(1,arraysize);
FcTHRESHOLD = 0.5; %default: 0.5

ffc = [];
for cc = 1:6
    load(['/media/mengmi/KLAB15/Mengmi/Proj_memory/Recog_array/img_' num2str(i) '_' num2str(cc) '.jpg_224.mat']);
    ffc = [ffc recogmap];
end
ffc = mat2gray(ffc);

for f = 1:min([arraysize length(fix)])
    
    chosenfix = fix(f);
    %load(['/media/mengmi/KLAB15/Mengmi/Proj_memory/Recog_array/img_' num2str(i) '_' num2str(chosenfix) '.jpg_224.mat']);
    if chosenfix == gtind
        %recogprob = rand;
        recogprob = ffc(chosenfix);
        %display('im in');
        
        if recogprob >= FcTHRESHOLD
            found = 1;
            break;
        else
            found = 0;
            %display('no');
            display(recogprob)
        end
    else
        found = 0;
    end
   
end

if found == 1
    scoremat(1,f) = 1;
    Rfix = fix(1:f);
else
    Rfix = fix(1:f);
end
    
end %end of function