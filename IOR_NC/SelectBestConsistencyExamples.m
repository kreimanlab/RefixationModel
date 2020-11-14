clear all; close all; clc;
TYPELIST = {'naturaldesign','waldo','array','naturalsaliency','wmonkey','cmonkey'};

for i = 5%1:length(TYPELIST)
    
    type = TYPELIST{i};
    
    if strcmp(type, 'naturaldesign') || strcmp(type, 'array') || strcmp(type, 'waldo')
        SubjThres = 10;
    elseif strcmp(type, 'naturalsaliency') 
        SubjThres = 4;
    else
        SubjThres = 2;
    end


    load(['Mat/refixmap_consistency_' type '.mat']);
    load(['Mat/RefixMapConsistency_entropy_' type '.mat']);
    [ind a] = sort(entropylist);

    for j = 1:length(a)
        selectedimg = RefixMaps(a(j));
        if SubjThres <= length(selectedimg.subjects)
            display(['found image ID: ' num2str(selectedimg.imgID) ' for dataset: ' type '; entropy list: ' num2str(j)]);
            break;
        end
    end

end