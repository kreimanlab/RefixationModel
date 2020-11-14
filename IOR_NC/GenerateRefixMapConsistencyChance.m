clear all; close all; clc;
warning('run this in matlab2014a on local machine; use parfor');

% %for NC3datasets
NumRefix = 500;
SimulatedTrials = 100;
ChanceResults = {}; %stores entropy value
Imgw = 1024; Imgh = 1280;
Gsize = 130; Gvar = 25; %gaussian filter specs
G = fspecial('gaussian',[Gsize Gsize], Gvar);            
Wbinranges = [0:32:1024];
Hbinranges = [0:32:1280];

for n = 1:NumRefix
    entropylist = [];
    n
    for t = 1:SimulatedTrials
        
        bin = zeros(Imgw, Imgh);
        x = int32((Imgw-1).*rand(1,n) + 1);
        y = int32((Imgh-1).*rand(1,n) + 1);

        [prob,Xedges,Yedges] = histcounts2(x,y,Wbinranges,Hbinranges,'Normalization','probability');
        prob(find(prob<=0)) = 0.00000000001;
        prob=prob(:);
        H=-sum(prob.*log2(prob));
        entropylist = [entropylist H];
    end
    ChanceResults = [ChanceResults; entropylist];
end

save(['Mat/RefixMatConsistency_chance_NC3datasets.mat'],'ChanceResults');

a = cellfun(@mean, ChanceResults);
plot(a);

%for monkey datasets
NumRefix = 100;
SimulatedTrials = 100;
ChanceResults = {}; %stores entropy value
Imgw = 596; Imgh = 596;
Gsize = 130; Gvar = 25; %gaussian filter specs
G = fspecial('gaussian',[Gsize Gsize], Gvar);            
Wbinranges = [0:18.625:Imgw];
Hbinranges = [0:14.9:Imgh];

for n = 1:NumRefix
    n
    entropylist = [];
    for t = 1:SimulatedTrials
        
        bin = zeros(Imgw, Imgh);
        x = int32((Imgw-1).*rand(1,n) + 1);
        y = int32((Imgh-1).*rand(1,n) + 1);
        [prob,Xedges,Yedges] = histcounts2(x,y,Wbinranges,Hbinranges,'Normalization','probability');
        prob(find(prob<=0)) = 0.00000000001;
        prob=prob(:);
        H=-sum(prob.*log2(prob));        
        entropylist = [entropylist H];
    end
    ChanceResults = [ChanceResults; entropylist];
end

save(['Mat/RefixMatConsistency_chance_monkeys.mat'],'ChanceResults');

a = cellfun(@mean, ChanceResults);
plot(a);
    
    
    
    
    
    

