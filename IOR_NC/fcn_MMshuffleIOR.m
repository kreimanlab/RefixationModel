function [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN)
%FCN Summary of this function goes here
%   Detailed explanation goes here
proportion = 0.9;
TotalNumNT = length(countpropntD);
TotalNumT = length(countproptD);
RNT = int32(TotalNumNT*proportion);
RT = int32(TotalNumT*proportion);

RandTimes = 100;

propt = [];
propnt = [];

    for r = 1:RandTimes
        propt = [propt sum(countproptN(randperm(TotalNumT, RT)))/sum(countproptD(randperm(TotalNumT, RT)))];
        propnt = [propnt sum(countpropntN(randperm(TotalNumNT, RNT)))/sum(countpropntD(randperm(TotalNumNT, RNT)))];
    end

end

