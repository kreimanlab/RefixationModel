clear all; close all; clc;
%type = 'wmonkey_curiosity_recog'; %wmonkey, cmonkey, wmonkey_scanpathpred_infor, wmonkey_scanpathpred, wmonkey_curiosity_recog

TYPELIST = {'wmonkey','cmonkey','wmonkey_conv_only','cmonkey_conv_only'};

for T = 1:length(TYPELIST)

type = TYPELIST{T}; %egteaplus, os

preprocess = 0; %toggle between 1 and 0
subtype = strsplit(type, '_');
subtype = subtype{1};

imgsize = 596;
visualdeg=39.7;
if strcmp(subtype, 'cmonkey')
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/CMonkey/monkey_eyetracking/AllStimuli/';
    visualdeg=39.7;
    
    if preprocess == 1
        load(['Mat/CE_' subtype '.mat']);
        %convert everything to cells
        Fix_posx = {}; Fix_posy = {}; Fix_time = {}; Fix_pic = {}; Fix_endIndex = {}; Fix_microsad = {};
        Fix_subj = {};
        counter = 0;
        fixlen = 0;
        for i = 1:length(CE)
            for j = 1:length(CE(i).fixations)
                fixations = CE(i).fixations{j};
                subj = CE(i).subjid(j);
                fixx = fixations(:,1);
                counter = counter + 1;
                fixlen = fixlen + length(fixx);
                %fixx = [imgsize/2; fixx]; %pending dummy center fixation; dim by 1
                fixy = imgsize - fixations(:,2); 
                %fixy = [imgsize/2; fixy]; %pending dummy center fixation; dim by 1
                fixations_time = CE(i).fixations_time{j};
                fixtime = (fixations_time(2,:) - fixations_time(1,:)+1); 
                
                %% pre-filter anomaly fixation durations
                %fixtime(find(fixtime <= 0 )) = nan;
                %fixtime(find(fixtime >500 )) = nan;
                                
                %fixtime = [200 fixtime]; %pending dummy center duration; dim by 1               
                imgname = [CE(i).imgname CE(i).imgext];
                Fix_pic = [Fix_pic; imgname];
                Fix_posx = [Fix_posx; fixx'];
                Fix_posy = [Fix_posy; fixy'];
                Fix_time = [Fix_time; fixtime]; 
                Fix_subj = [Fix_subj; subj];
                %Fix_microsad = [Fix_microsad; CE(i).fixations_freq_microsac{j}];
            end
        end
        fixlen/counter
        save(['Mat/' subtype '_Fix.mat'],'Fix_posx','Fix_posy','Fix_time','Fix_pic','Fix_microsad','Fix_subj');
 
    end
    
elseif strcmp(subtype, 'wmonkey')
    imgsize = 596;
    ImgFolder = '/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey/stimuli/';
    visualdeg=39.7*imgsize/635;
    %temp = [];
    if preprocess == 1
        load(['Mat/CE_' subtype '.mat']);
        %convert everything to cells
        Fix_posx = {}; Fix_posy = {}; Fix_time = {}; Fix_pic = {}; Fix_endIndex = {}; Fix_microsad= {};
        Fix_subj = {};
        counter = 0;
        fixlen = 0;
        for i = 1:length(CE)
            for j = 1:1%length(CE(i).fixations)
                fixx = CE(i).fixations(:,1);
                subj = CE(i).subjid;
                counter = counter + 1;
                fixlen = fixlen + length(fixx);
                fixx = [imgsize/2; fixx]; %pending dummy center fixation; dim by 1
                fixy = CE(i).fixations(:,2); 
                fixy = [imgsize/2; fixy]; %pending dummy center fixation; dim by 1
                %CE(i).fixations_time
                fixtime = (CE(i).fixations_time(2,:) - CE(i).fixations_time(1,:)+1); 
                
                %% pre-filter anomaly fixation durations
                %fixtime(find(fixtime <= 0 )) = nan;
                %fixtime(find(fixtime >500 )) = nan;
                                
                fixtime = [200 fixtime]; %pending dummy center duration; dim by 1               
                imgname = deblank(CE(i).imgname);
                Fix_pic = [Fix_pic; imgname];
                Fix_posx = [Fix_posx; fixx'];
                Fix_posy = [Fix_posy; fixy'];
                Fix_time = [Fix_time; fixtime]; 
                Fix_subj = [Fix_subj; subj];
                %freq_microsac = [0 CE(i).freq_microsac]; %add dummy microsaccade for dummy center fixation
                %Fix_microsad = [Fix_microsad; freq_microsac];
            end
        end
        fixlen/counter
        save(['Mat/' subtype '_Fix.mat'],'Fix_posx','Fix_posy','Fix_time','Fix_pic','Fix_microsad','Fix_subj');
 
    end
end

%create dummy 
load(['Mat/' type '_Fix.mat']);
centerR = ones(2, length(Fix_posx))*2000;
Firstx = Fix_posx; Firsty = Fix_posy;
centerRx = centerR(1,:); centerRy = centerR(2,:);
imgvalid = [1:length(Firstx)];

%fair to model; subsampled from 38 x 50 grids wrt 1024 x 1280 grids
%margin 1280/50 = 25.6 gap min
Deg = 1; %[0.25 0.5 1 2 4]
IORthres = visualdeg*Deg; %threshold as repeated fixations
IORthresT = 133/2; %threshold as within target
MaxPlotFix = 8;
binranges = [0:MaxPlotFix+1];
xtickrange = [1:MaxPlotFix];
linewidth = 2;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'


% [propnt1, offsetnt1, propt1, offsett1,countpropntD, countpropntN, countproptD, countproptN ] = fcn_MMevalInhibitionOfReturn(Firstx, Firsty, centerRx, centerRy, IORthres, IORthresT, type, imgvalid, 1, type);
% save(['Mat/IOR_' type '.mat'],'propnt1', 'offsetnt1', 'propt1', 'offsett1','countpropntD', 'countpropntN', 'countproptD', 'countproptN'); 

overallMeanS1 = []; overallStdS1 = [];
offsettotalNT = [];
load(['Mat/IOR_' type '.mat']);

offsetnt1(find(offsetnt1>MaxPlotFix)) = [];
offsettotalNT = [offsettotalNT offsetnt1];

[propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
Mpropnt1 = propnt;

propnt1 = propnt;
overallMeanS1 = [nanmean(propnt1)] * 100;
overallStdS1 = [nanstd(propnt1)/sqrt(length(propnt1))]*100;
display([type '; mean=' num2str(overallMeanS1) '; std=' num2str(overallStdS1)]);


%% show IOR prop (overall)
hb = figure('Position',[288   207    85   258]); hold on;

set(gca,'linewidth',2);
%load(['Mat/saccade_' type  '.mat']);
%chanceval = length(find(SIMNONRETURN_Radius<=Deg))/length(SIMNONRETURN_Radius);
subtype = strsplit(type, '_'); 
load(['Mat/' subtype{1} '_chanceoffsetnt.mat']);
[propt, propnt] = fcn_MMshuffleIOR(countpropntD, countpropntN, countproptD, countproptN);
[h pnt ci stats] = ttest2(propnt,Mpropnt1); 
chanceval = mean(propnt);
display([type '; pnt=' num2str(pnt) '; t=' num2str(stats.tstat) ';df=' num2str(stats.df)]);

if pnt <= 0.05
    text(1,40, '*', 'Fontsize', 12, 'Fontweight', 'bold');
% elseif pvalue <= 0.01
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '**', 'Fontsize', 16, 'Fontweight', 'bold');
% elseif pvalue <= 0.001
%     text(s-0.05,max(intersubj_consis_avg)+max(intersubj_consis_std)+0.05, '*', 'Fontsize', 16, 'Fontweight', 'bold');
else
    text(1,40, 'n.s.', 'Fontsize', 12, 'Fontweight', 'bold');
end



if strcmp(type, 'array')
    %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(596*596)*100,'k:','LineWidth',2.5);
    plot([0:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2.5);
else
    %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(596*596)*100,'k:','LineWidth',2.5);
    plot([0:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
end

%bar([1],overallMeanS1,'FaceColor',[0.5020    0.5020    0.5020],'LineWidth',1.5);
bar([1],overallMeanS1,'FaceColor',[0 0 0],'LineWidth',1.5);

errorbar([1], overallMeanS1, overallStdS1,'k.');
%plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(imgsize*imgsize)*100,'k:','LineWidth',2.5);
if strcmp(type, 'array')
    %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(596*596)*100,'k:','LineWidth',2.5);
    plot([0:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2.5);
else
    %plot([0:3],ones(size([0:3]))* IORthres*IORthres*pi/(596*596)*100,'k:','LineWidth',2.5);
    plot([0:3],ones(size([0:3]))* chanceval*100,'w:','LineWidth',2);
end
set(gca,'YTick',[0:0.1:0.4]*100,'FontSize',11);
set(gca,'YTickLabel',{},'FontSize',12);
%set(gca,'YTick',[],'FontSize',11);
set(gca,'XTick',[1],'FontSize',12);
xlim([0.5 1.5]);
ylim([0 40]);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(gca,'XTickLabel',{''},'FontSize',11);
% if strcmp(subtype{1}, 'wmonkey')
%     set(gca,'XTickLabel',{'Mm, free view 1'},'FontSize',11);
% else
%     set(gca,'XTickLabel',{'Mm, free view 2'},'FontSize',11);
% end
set(gca,'XTickLabelRotation',45);
%xlabel('Inter Trial Interval','FontSize',14');
%ylabel('Proportion (%)','FontSize',12);
%legend({'Chance'},'FontSize',14);legend boxoff ;
titlename = [type ';pnt=' num2str(pnt)];
%title(titlename,'FontSize',14); 
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/IOR_first_overall_' type '_Deg_' num2str(Deg*100)  printpostfix],printmode,printoption);

%% show IOR offset (overall)
hb = figure; hold on; 

if strcmp(type, subtype{1})
    set(hb,'Position',[308   368   127   117]);
else
    set(hb,'Position',[313   248   293   242]);
end

set(gca,'linewidth',2);
if isempty(offsettotalNT)
    bincounts = zeros(size(binranges));
else
    bincounts = histc(offsettotalNT,binranges);
    bincounts = bincounts/sum(bincounts);
end    
%plot(binranges, bincounts,'Color',ColorList(3,:),'LineWidth',linewidth);
plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle','--');

binc = bincounts*100;
display([type '; 1st: ' num2str(binc(3)) ';first 3: ' num2str(sum(binc(3:5)))]);

subtype = strsplit(type, '_'); 
load(['Mat/' subtype{1} '_chanceoffsetnt.mat']);
bincounts = histc(chanceoffsetnt,binranges);
bincounts = bincounts/sum(bincounts);
%plot(binranges-1, bincounts*100,'Color','k','LineWidth',linewidth,'LineStyle',':');
%plot(binranges-1,ones(size(binranges-1))* 1/MaxPlotFix*100,'k:','LineWidth',linewidth);

%legend({'Free-viewing','Chance'},'Location','northeast','FontSize',14);
%legend boxoff ;
xlim([1 MaxPlotFix]);
set(gca,'XTick',xtickrange,'FontSize',11);
set(gca,'YTick',[0:30:90],'FontSize',11);
set(gca,'YTickLabel',{},'FontSize',12);
ylim([0 1]*90);
%xlabel('Returning Offset (Fixations)','FontSize',12);
%ylabel('Distribution (%)','FontSize',12);
%title(type,'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(hb,['Figures/IORoffsetFirstOnly_' type '_Deg_' num2str(Deg*100) printpostfix],printmode,printoption);

end
