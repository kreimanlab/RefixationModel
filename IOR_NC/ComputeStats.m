clear all; close all; clc;

% %% compute difference between fixation durations
% TYPELIST = {'array','naturaldesign','waldo','naturalsaliency','wmonkey','cmonkey','egteaplus','os'};
%    
% for t = 1:length(TYPELIST)
%     
%     type = TYPELIST{t};
%     load(['Mat/ReturnFixDuration_' type  '.mat']);
%     diff1mean = [];
%     diff2mean = [];
%     diff3mean = [];
% 
%     for s=unique([SIMNONRETURN_subj SIMRETURN2_subj SIMRETURN_subj])
%         
%         %'SIMRETURN', 'SIMRETURN2','SIMNONRETURN'
%         diff1  = [nanmean(SIMRETURN2(find(SIMRETURN2_subj ==s))) - nanmean(SIMNONRETURN(find(SIMNONRETURN_subj ==s)))];
%         diff2  = [nanmean(SIMRETURN(find(SIMRETURN_subj ==s))) - nanmean(SIMNONRETURN(find(SIMNONRETURN_subj ==s)))];
%         diff3  = [nanmean(SIMRETURN2(find(SIMRETURN2_subj ==s))) - nanmean(SIMRETURN(find(SIMRETURN_subj ==s)))];
% 
%         diff1mean = [diff1mean diff1];
%         diff2mean = [diff2mean diff2];
%         diff3mean = [diff3mean diff3];
% 
%     end
%     
%     %remove two extreme outliers: one max, one min among all
%     if ~strcmp(type, 'cmonkey')
%         diff1mean(find(diff1mean == max(diff1mean))) = [];
%         diff1mean(find(diff1mean == min(diff1mean))) = [];
%         diff2mean(find(diff2mean == max(diff2mean))) = [];
%         diff2mean(find(diff2mean == min(diff2mean))) = [];
%         diff3mean(find(diff3mean == max(diff3mean))) = [];
%         diff3mean(find(diff3mean == min(diff3mean))) = [];
%     end
%     
%     display(['dataset: ' type]);
%     
% %     display(['return vs non-re: ' num2str(median(diff1mean)) '; std = ' num2str(nanstd(diff1mean)/sqrt(length(diff1mean))) ]);
% %     display(['to-be vs non-re: ' num2str(median(diff2mean)) '; std = ' num2str(nanstd(diff2mean)/sqrt(length(diff2mean))) ]);
% %     display(['return vs to-be: ' num2str(median(diff3mean)) '; std = ' num2str(nanstd(diff3mean)/sqrt(length(diff3mean))) ]);
% 
%     
%     display(['return vs non-re: ' num2str(nanmean(diff1mean)) '; std = ' num2str(nanstd(diff1mean)/sqrt(length(diff1mean))) ]);
%     display(['to-be vs non-re: ' num2str(nanmean(diff2mean)) '; std = ' num2str(nanstd(diff2mean)/sqrt(length(diff2mean))) ]);
%     display(['return vs to-be: ' num2str(nanmean(diff3mean)) '; std = ' num2str(nanstd(diff3mean)/sqrt(length(diff3mean))) ]);
% 
% end



%% fixation duration of visual search versus free-viewing humans
diff1 = [];
TYPELIST = {'array','naturaldesign','waldo','naturalsaliency','wmonkey','cmonkey','egteaplus','os'};
for t = 2
    type = TYPELIST{t};
    load(['Mat/ReturnFixDuration_' type  '.mat']);
    diff1  = [diff1 SIMRETURN2 SIMRETURN SIMNONRETURN];
end

diff2 = [];
for t = 4 %length(TYPELIST)
    type = TYPELIST{t};
    load(['Mat/ReturnFixDuration_' type  '.mat']);
    diff2  = [diff2 SIMRETURN2 SIMRETURN SIMNONRETURN];
end
display(['mean(vs): ' num2str(mean(diff1)) '; std(vs): ' num2str(std(diff1)/sqrt(length(diff1)))]);
display(['mean(fv): ' num2str(mean(diff2)) '; std(fv): ' num2str(std(diff2)/sqrt(length(diff2)))]);

[h pnt ci stats ] = ttest2(diff1, diff2);
display(['pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);
% 
%% compute difference between fixation saccades
TYPELIST = {'array','naturaldesign','waldo','naturalsaliency','wmonkey','cmonkey','egteaplus','os'};
   
for t = 1:length(TYPELIST)
    
    type = TYPELIST{t};
    load(['Mat/saccade_' type  '.mat']);
    diff1mean = [];
    diff2mean = [];
    diff3mean = [];

    for s=unique([SIMNONRETURN_subj SIMRETURN2_subj SIMRETURN_subj])
        
        %'SIMRETURN', 'SIMRETURN2','SIMNONRETURN'
        diff1  = [nanmean(SIMRETURN2_Radius(find(SIMRETURN2_subj ==s))) - nanmean(SIMNONRETURN_Radius(find(SIMNONRETURN_subj ==s)))];
        diff2  = [nanmean(SIMRETURN_Radius(find(SIMRETURN_subj ==s))) - nanmean(SIMNONRETURN_Radius(find(SIMNONRETURN_subj ==s)))];
        diff3  = [nanmean(SIMRETURN2_Radius(find(SIMRETURN2_subj ==s))) - nanmean(SIMRETURN_Radius(find(SIMRETURN_subj ==s)))];

        diff1mean = [diff1mean diff1];
        diff2mean = [diff2mean diff2];
        diff3mean = [diff3mean diff3];

    end
    
    %remove two extreme outliers: one max, one min among all
    if ~strcmp(type, 'cmonkey')
        diff1mean(find(diff1mean == max(diff1mean))) = [];
        diff1mean(find(diff1mean == min(diff1mean))) = [];
        diff2mean(find(diff2mean == max(diff2mean))) = [];
        diff2mean(find(diff2mean == min(diff2mean))) = [];
        diff3mean(find(diff3mean == max(diff3mean))) = [];
        diff3mean(find(diff3mean == min(diff3mean))) = [];
    end
    
    display(['dataset: ' type]);
    
%     display(['return vs non-re: ' num2str(median(diff1mean)) '; std = ' num2str(nanstd(diff1mean)/sqrt(length(diff1mean))) ]);
%     display(['to-be vs non-re: ' num2str(median(diff2mean)) '; std = ' num2str(nanstd(diff2mean)/sqrt(length(diff2mean))) ]);
%     display(['return vs to-be: ' num2str(median(diff3mean)) '; std = ' num2str(nanstd(diff3mean)/sqrt(length(diff3mean))) ]);

    
    display(['return vs non-re: ' num2str(nanmean(diff1mean)) '; std = ' num2str(nanstd(diff1mean)/sqrt(length(diff1mean))) ]);
    display(['to-be vs non-re: ' num2str(nanmean(diff2mean)) '; std = ' num2str(nanstd(diff2mean)/sqrt(length(diff2mean))) ]);
    display(['return vs to-be: ' num2str(nanmean(diff3mean)) '; std = ' num2str(nanstd(diff3mean)/sqrt(length(diff3mean))) ]);

end    

%% compute saccade size of monkeys versus humans
TYPELIST = {'naturalsaliency','wmonkey','cmonkey'};
   
diff1 = [];
diff2 = [];
for t = 1:length(TYPELIST)
    
    type = TYPELIST{t};
    load(['Mat/saccade_' type  '.mat']);
    %'SIMRETURN', 'SIMRETURN2','SIMNONRETURN'
    if t == 1
        diff1  = [diff1 SIMRETURN2_Radius SIMNONRETURN_Radius SIMRETURN_Radius];
    
    else
        diff2  = [diff2 SIMRETURN2_Radius SIMNONRETURN_Radius SIMRETURN_Radius];
    end
    
end
[h p ci stats] =ttest2(diff1, diff2);
display(['pnt=' num2str(p) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);

%% compute prop of refixations in visual search versus free-viewing for IVSN2.0
TYPELIST = {'array','naturaldesign','waldo','naturalsaliency','wmonkey','cmonkey'};
prop_vs = []; prop_free = [];

for t = 1:length(TYPELIST)
    type = TYPELIST{t};
    if t<=3
        load(['Mat/IOR_' type '_conv_only_' type '_conv_only_comb.mat']);
        [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
        prop_vs = [prop_vs (propnt)];
    elseif t == 4
        load(['Mat/IOR_' type '_conv_only_' type '_conv_only.mat']);
        [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
        prop_free = [prop_free (propnt)];
    else
        load(['Mat/IOR_' type '_conv_only.mat']);
        [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
        prop_free = [prop_free (propnt)];
    end
end
[h pnt ci stats] = ttest2(prop_vs,prop_free); 
display(['pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);

% %% compute prop of refixations in visual search versus free-viewing for humans
% TYPELIST = {'naturaldesign','naturalsaliency'};
% prop_vs = []; prop_free = [];
% 
% for t = 1:length(TYPELIST)
%     type = TYPELIST{t};
%     
%     if t == 1
%         subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
%         'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
%         'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'};
%         for s = 1:length(subjlist)
%             load(['Mat/IOR_' type '_' subjlist{s} '.mat']);
%             [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
%             prop_vs = [prop_vs (propnt)];
%         end
%     else
%         subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
%         'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'};
%         for s = 1:length(subjlist)
%             load(['Mat/IOR_' type '_' subjlist{s} '.mat']);
%             [propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
%             prop_free = [prop_free (propnt)];
%         end
%     end
% end
% [h pnt ci stats] = ttest2(prop_vs,prop_free); 
% display(['pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);

% %% Compute KLD between refixation and non-return fixation distribution
% TYPELIST = {'array','naturaldesign','waldo','naturalsaliency','wmonkey','cmonkey','egteaplus','os'};
% Wbinlist = [30, 30, 30, 30, 40, 15, 60, 60];
% Hbinlist = [25, 25, 25, 25, 40, 15, 46, 46];
% 
% for t = 1:length(TYPELIST)
%     type = TYPELIST{t};
%     load(['Mat/NR_R_fixationmaps_' type '.mat']); %,'NRbinarymask','Rbinarymask'
%     
%     if t >= 2
%         Wbinranges = Wbinlist(t);
%         Hbinranges = Hbinlist(t);
% 
%         % compute prob for NRbinarymask
%         probNR = imresize(NRbinarymask, [Hbinranges, Wbinranges]);
%         probNR(find(probNR<=0)) = 0.00000000001;
%         subplot(1,2,1);
%         imshow(probNR);
%         probNR = probNR(:);
% 
%         % compute prob for Rbinarymask
%         probR = imresize(Rbinarymask, [Hbinranges, Wbinranges]);
%         probR(find(probR<=0)) = 0.00000000001;
%         subplot(1,2,2);
%         imshow(probR);
%         probR = probR(:); 
%     else
%         probNR = NRbinarymask;
%         probR = Rbinarymask;
%         
%     end
%     
%     %KL(P1(x),P2(x)) = sum[P1(x).log(P1(x)/P2(x))]
%     kld = sum( probNR.*log(probNR./probR));
%     
%     display(['dataset: ' type '; kld =' num2str(kld)]);
% end



















