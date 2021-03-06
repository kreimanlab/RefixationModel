clear all; close all; clc;

type = 'naturalsaliency'; %waldo, naturaldesign, array, naturalsaliency, cmonkey, wmonkey, os, egteaplus, pranav

load(['Mat/saccade_' type '.mat']);
MAX = 65; %max(SIMNONRETURN_Radius);
binranges = [0:0.2:MAX];
bincounts = histc(SIMNONRETURN_Radius,binranges);
bincounts = bincounts/sum(bincounts);
%replace with very small probability
bincounts(find(bincounts == 0)) = 10^(-5);

sampleSize = 24000000;

if strcmp(type,'array')
    samplePer = 5;
    sampleSize = 240000;
    
%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;

elseif strcmp(type,'naturaldesign')
    samplePer = 30;
    sampleSize = 24000000;
    
%     samplePer = 6; %for exp23only
%     sampleSize = 240000;

%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;

elseif strcmp(type,'waldo')
    samplePer = 30;
    sampleSize = 24000000;
    
%     samplePer = 14; %for exp23only
%     sampleSize = 2400020;

%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;
    
elseif strcmp(type,'naturalsaliency')
    samplePer = 15;
    sampleSize = 24000000; 
    
%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;
    
elseif strcmp(type,'wmonkey')
    samplePer = 10;
    sampleSize = 240000;
    
%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;
    
elseif strcmp(type,'cmonkey')
    samplePer = 5;
    sampleSize = 240000;
    
%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;
    
elseif strcmp(type,'os')
    samplePer = 20;
    sampleSize = 24000000;
    
%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;
    
else
    samplePer = 20;
    sampleSize = 24000000;
    
%     samplePer = 6; %for first 6 fixations analysis
%     sampleSize = 240000;
end
    

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
Sx = Sxc;
Sy = Syc;

figure;
for p = 1:10
    subplot(2,5,p);
    plot(Sx(p,:), Sy(p,:),'r*-');
    xlim([-17*38 17*38]);
    ylim([-14*38 14*38]);
end

NumStimuli = size(Sx,1);    
    
offsett = [];
offsetnt = [];
counterTotalRt = 0;
counterTtotalRnt = 0;
countertrialt = 0;
countertrialnt = 0;

Deg = 1; %[0.25 0.5 1 2 4]
IORthres = 43*Deg; %threshold as repeated fixations
thres = IORthres;
IORthresT = 133/2; %threshold as within target

countpropntD =[];
countpropntN =[];
countproptD =[];
countproptN =[];

probrefix = [];

for i = 1:NumStimuli

    fx = double(Sx(i,:));
    fy = double(Sy(i,:));    

    %ctx = double((17*38*2).*rand(1,1) -17*38); %random pick a xaix location
    %cty = double((14*38*2).*rand(1,1) -14*38); %random pick a yaxis location
    ctx = double(0); %random pick a xaix location
    cty = double(0); %random pick a yaxis location

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

    if ~isempty(overlappairst)
        qq1 = overlappairst(:,1);
        qq2 = overlappairst(:,2);

        %remove those triple pairs (A,B) and (B,C); then we only take C
        qq2(ismember(qq2,qq1)) = [];  

        probrefix = [probrefix; qq2];
    end

    if ~isempty(overlappairsnt)
        qq1 = overlappairsnt(:,1);
        qq2 = overlappairsnt(:,2);

        %remove those triple pairs (A,B) and (B,C); then we only take C
        qq2(ismember(qq2,qq1)) = [];  

        probrefix = [probrefix; qq2];
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

chanceoffsetnt = offsetnt;
figure;
hist(chanceoffsetnt);
propt
propnt
%save(['Mat/' type '_chanceoffsetnt_exp23only.mat'],'probrefix','chanceoffsetnt','propnt','propt','countpropntD', 'countpropntN', 'countproptD', 'countproptN');
save(['Mat/' type '_chanceoffsetnt.mat'],'probrefix','chanceoffsetnt','propnt','propt','countpropntD', 'countpropntN', 'countproptD', 'countproptN');
%save(['Mat/' type '_chanceoffsetnt_first6.mat'],'probrefix','chanceoffsetnt','propnt','propt','countpropntD', 'countpropntN', 'countproptD', 'countproptN');


% typelist = {'array','naturaldesign','waldo','wmonkey','cmonkey','os','egteaplus'};
% for t = 1:length(typelist)
%     
%     load(['Mat/' typelist{t} '_chanceoffsetnt.mat']);
%     display([typelist{t} ': T: ' num2str(propt) '; NT: ' num2str(propnt)]);
% end

