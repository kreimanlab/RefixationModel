clear all; close all; clc;

typelist = {'array','naturaldesign','waldo','naturalsaliency','wmonkey','cmonkey','egteaplus','os'};
totalfix = 0;
totalrefix = 0;
prevtotalfix = 0;
prevtotalrefix = 0;

for t = 1:length(typelist)
    
    type = typelist{t};
    flag = 0;
    if strcmp(type, 'array')        
        subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
           'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
           'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
        flag = 1;
    elseif strcmp(type, 'naturaldesign')        
        subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
            'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
            'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
        flag = 1;
    elseif strcmp(type, 'naturalsaliency')        
        subjlist = {'subj05-er','subj07-af','subj08-cs','subj09-jm','subj10-jc',...
        'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'}; %natural saliency
        flag = 1;
    elseif strcmp(type, 'waldo')
        subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
            'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
            'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard        
        flag = 1;
    end

    if flag == 1
        for s = 1:length(subjlist)
            load(['Mat/IOR_' type '_' subjlist{s} '.mat']);
            
            if strcmp(type, 'naturalsaliency')
                totalfix = totalfix + sum(countpropntD);
                totalrefix = totalrefix + sum(countpropntN);
            else
                totalfix = totalfix + sum(countpropntD) + sum(countproptD);
                totalrefix = totalrefix + sum(countpropntN) + sum(countproptN);
            end
        end
    else
        load(['Mat/IOR_' type '.mat']);
        totalfix = totalfix + sum(countpropntD);
        totalrefix = totalrefix + sum(countpropntN);
    end
    
    display(['dataset: ' type '; refixnum = ' num2str(totalrefix-prevtotalrefix) '; fixnum = ' num2str(totalfix - prevtotalfix) '; ratio= ' num2str((totalrefix-prevtotalrefix)/(totalfix - prevtotalfix))]);
    prevtotalfix = totalfix;
    prevtotalrefix = totalrefix;
    
end

display(['Total fix: ' num2str(totalfix)]);
display(['Total refix: ' num2str(totalrefix)]);
display(['Prop: ' num2str(double(totalrefix)/double(totalfix))]);

