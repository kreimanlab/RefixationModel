function [ propnt, offsetnt, propt, offsett, countpropntD, countpropntN, countproptD, countproptN ] = fcn_MMevalInhibitionOfReturn_exp23only( Firstx, Firsty, Centerx, Centery, thres, IORthresT, subjid, imgvalid, Time, type, LongThres, ShortThres)
%FCN_MMEVALINHIBITIONOFRETURN Summary of this function goes here
%   Detailed explanation goes here

    NumStimuli = length(Firstx);    
    
    offsett = [];
    offsetnt = [];
    counterTotalRt = 0;
    counterTtotalRnt = 0;
    countertrialt = 0;
    countertrialnt = 0;
    
    countpropntD =[];
    countpropntN =[];
    countproptD =[];
    countproptN =[];
    
    for i = 1:NumStimuli
        %i
        fx = double(Firstx{i});
        fy = double(Firsty{i});
        
        if length(fx) < LongThres+1
            continue;
        end
        
        fx = fx(1:ShortThres+1);
        fy = fy(1:ShortThres+1);
        
        ctx = double(Centerx(i));
        cty = double(Centery(i));
    
        overlappairsnt = [];
        overlappairst = [];
        
        countert = 0;
        counternt = 0;
        
        % remove first fixation
        if length(fx)>1
            fx = fx(2:end);
            fy = fy(2:end);
        end
        
        if length(fx) >= 3
            for j = 3:length(fx)
                cx = fx(j); cy = fy(j);
                cmpx = fx(1:j-2);
                cmpy = fy(1:j-2);
                dist = sqrt( (cmpx - cx).^2 + (cmpy - cy).^2 );
                distc = sqrt( (cmpx - ctx).^2 + (cmpy - cty).^2 );                
                
                if length(find(dist<=thres)) >= 1
                    [a b] = find(dist <= thres);                    
                    o  = j-b(end);
                    
                    if length(find(distc(b(end))<=IORthresT)) > 0
                        countert = countert + 1;
                        offsett = [offsett o];
                        overlappairst = [overlappairst; j  b(end) length(fx)];
                    else
                        counternt = counternt + 1;
                        offsetnt = [offsetnt o];
                        overlappairsnt = [overlappairsnt; j  b(end) length(fx)];
                    end
                    
                end
                
                
                
            end 
            
            
            
        end
        
        %save(['Mat_IOR_' type '/' subjid '_stimuli_' num2str(imgvalid(i))  '.mat'],'overlappairst','overlappairsnt');
                    
        counterTotalRt = counterTotalRt + countert + 1;
        counterTtotalRnt = counterTtotalRnt + length(fx) - countert - 1;
        countertrialt = countertrialt + countert;
        countertrialnt = countertrialnt + counternt;
        
        countproptD = [countproptD countert + 1];
        countpropntD = [countpropntD length(fx) - countert - 1];
        countproptN = [countproptN countert];
        countpropntN = [countpropntN counternt];
         
    end
%     counterTotalRt
%     countertrialt
%     counterTtotalRnt
%     countertrialnt
    propt = countertrialt/counterTotalRt;
    propnt = countertrialnt/counterTtotalRnt;
end

