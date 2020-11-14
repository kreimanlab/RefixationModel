clear all; close all; clc;

type = 'waldo'; %waldo, naturaldesign, array, naturalsaliency, cmonkey, wmonkey, os, egteaplus

load(['Mat/saccade_' type '.mat']);
MAX = 65; %max(SIMNONRETURN_Radius);
binranges = [0:0.2:MAX];
bincounts = histc(SIMNONRETURN_Radius,binranges);
bincounts = bincounts/sum(bincounts);
%replace with very small probability
bincounts(find(bincounts == 0)) = 10^(-5);

sampleSize = 5000000;
samplePer = 10;
[cdf R] = pdfrnd(binranges(:), bincounts(:), sampleSize);
O = rand(sampleSize,1)*2*pi;

Sr = reshape(R, [sampleSize/samplePer samplePer]);
So = reshape(O, [sampleSize/samplePer samplePer]);
Sx = Sr.*cos(So);
Sy = Sr.*sin(So);

init = zeros(size(Sx,1),1);
Sx = [init Sx];
Sy = [init Sy];

Sx = cumsum(Sx,2)*38;
Sy = cumsum(Sy,2)*38;

%detect valid random examples within an image frame
xaxislimits = [-17*38 17*38];
yaxislimits = [-14*38 14*38];
Sy(find(Sx< xaxislimits(1) | Sx > xaxislimits(2)))= nan;
Sx(find(Sx< xaxislimits(1) | Sx > xaxislimits(2)))= nan;
Sx(find(Sy< yaxislimits(1) | Sy > yaxislimits(2)))= nan;
Sy(find(Sy< yaxislimits(1) | Sy > yaxislimits(2)))= nan;
Sxc = Sx; Syc = Sy;
Sxc(any(isnan(Sx) | isnan(Sy), 2), :) = [];
Syc(any(isnan(Sx) | isnan(Sy), 2), :) = [];
Sx = Sxc + 1280/2;
Sy = Syc + 1028/2;

% figure;
% for p = 1:10
%     subplot(2,5,p);
%     plot(Sx(p,:), Sy(p,:),'r*-');
%     xlim([0 1280]);
%     ylim([0 1024]);
% end

NumStimuli = size(Sx,1);    
NumSubj = 15;

offsett = [];
offsetnt = [];
counterTotalRt = 0;
counterTtotalRnt = 0;
countertrialt = 0;
countertrialnt = 0;

Deg = 1; %[0.25 0.5 1 2 4]
IORthres = 38*Deg; %threshold as repeated fixations
thres = IORthres;
IORthresT = 133/2; %threshold as within target
NumRandomTrials = 200000;
SIMRETURN = [];

for rand = 1: NumRandomTrials
    fixxC = []; fixyC = []; fixindC = [];
    Rind = randperm(NumStimuli, NumSubj);
    
    rand
    for i = 1:NumSubj

        fx = double(Sx(Rind(i),:));
        fy = double(Sy(Rind(i),:));

        ctx = double(0);
        cty = double(0);

        overlappairsnt = [];
        overlappairst = [];

        countert = 0;
        counternt = 0;

        % remove first fixation    
        fx = fx(2:end);
        fy = fy(2:end);    
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
        
        if ~isempty(overlappairsnt)
        
            overlappairsnt = overlappairsnt(:,2);
            %overlappairsnt = overlappairsnt + 1;
            overlappairsnt = overlappairsnt(:);
            overlappairsnt = unique(overlappairsnt);

            fixxC = [fixxC fx(overlappairsnt) ];
            fixyC = [fixyC fy(overlappairsnt) ];
            fixindC = [fixindC i*ones(1,length(overlappairsnt))];
        end

    end

    totalsubjR = length(unique(fixindC));
    
    if totalsubjR <= 1
        continue;
    end
    
    %find common return fixations
    D = pdist([fixxC; fixyC]');
    D = squareform(D);
    
    Temp = ones(size(D));
    L = tril(Temp);
    D(L>0) = IORthres+10; %eliminate lower triangle + diagonal
    
    %find their index pairs
    [row col] = find(D<=IORthres);
    rowID = fixindC(row);
    colID = fixindC(col);    
    
    [B, iB, iA] = unique([rowID;colID]', 'rows');
    if isempty(B)
        pairsnum = 0;
    else
        pairsnum = length(find(B(:,1)~=B(:,2)));
    end
    SIMRETURN = [SIMRETURN pairsnum/( totalsubjR*(totalsubjR-1)/2)];
end
    


save(['Mat/' type '_chanceRFconsistency.mat'],'SIMRETURN');
