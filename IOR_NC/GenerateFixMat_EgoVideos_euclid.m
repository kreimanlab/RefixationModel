clear all; close all; clc;
addpath('/media/mengmi/TOSHIBABlue1/Proj_memory/IOR_NC/WMonkey');

%gbvs_install;
% addpath('/media/mengmi/TOSHIBABlue1/Proj_MonkeyFixations/saliency/code/gbvs/');
% % make some parameters
% params = makeGBVSParams;
% % could change params like this
% params.contrastwidth = .11;
% % example of itti/koch saliency map call
% params.useIttiKochInsteadOfGBVS = 1;


type = 'os'; %os, egteaplus
matlist = dir(['Mat_' type '/gaze_compiled_' type '/*.mat']);
fRate = 24;
visdeg = 21.3; %pixels per degree 60 deg wrt image size 1280
MaxDur = 5; %secs
Interval = fRate*MaxDur;
CE = []; %compiled eyetracking data across monkeys
SampleRateE = double(int32(1/fRate*1000))/1000.0; %24 Hz
Thres = int32(0.3*fRate);
distL2 = [];
filtereddistL2 = [];
AveragedSaccadeRate = 0;
CountSad = 0;

%% comment out
for mmat = 1:length(matlist)
    load(['Mat_' type '/gaze_compiled_' type '/' matlist(mmat).name ]);
    mmat
    %load video
    if strcmp(type, 'os')
        OriVideoFolder = 'OSData_Full';
        videoname = matlist(mmat).name(1:end-4);
        videofoldernames = split(videoname,'_');
        vfolder = videofoldernames{1};
        vname = videofoldernames{4};    
        dirinfo = dir([OriVideoFolder '/' vfolder '/']);
        %dirinfo = dirinfo(3:end);
        subdirinfo = [];
        for K = 1 : length(dirinfo)
          if dirinfo(K).isdir && contains(dirinfo(K).name, 'Participant')
            thisdir = dirinfo(K).name;
            %thisdir
            break;
          end
        end
        fullvideopath = [OriVideoFolder '/' vfolder '/' thisdir '/' vname '.avi'];
    else
        fullvideopath = ['/media/mengmi/KLAB15/Mengmi/EGTEAplus/full_videos/' matlist(mmat).name(1:end-4) '.mp4'];
    end
    
    try
        xyloObj = VideoReader(fullvideopath);
    catch
        continue;
    end
    
    if fRate ~= xyloObj.FrameRate
        error(['loading video frame not match']);
    end    
    
    stopF = size(compiled,1)-Interval;
    
    for s = 1:Interval:stopF
        
        display(['processing: ' num2str(mmat) '; frame: ' num2str(s) ]);
        
        fix_x = compiled(s:s+Interval-1,1);
        fix_y = compiled(s:s+Interval-1,2); 
        fix_t = int32(compiled(s:s+Interval-1,3)/(1/fRate)+1);
        
        if fix_x(1) == 1 && fix_y(1) == 1
            continue;
        else
            %filter out illegal scanpath
            fix_xc = fix_x; fix_yc = fix_y;            
            [ind val] = find(fix_xc == 1 & fix_yc == 1);
            if ~isempty(ind)
                fix_x = fix_x(1:ind(1)-1);
                fix_y = fix_y(1:ind(1)-1);
                fix_t = fix_t(1:ind(1)-1);
            end           
            
            if length(fix_x) < Thres
                continue;
            end
            
            scanpath = [fix_x fix_y]; %input: 2 by dim
            %convert to visual deg
            %scanpath = scanpath/visdeg;
%             figure;imshow(img);hold on;plot(fix_x, fix_y,'*');%xlim([0 1280]); ylim([0 1024]);
            %scanpath output: dim by 2
            scanpath = scanpath'; %2 by dim
            scanpath = {scanpath}; %encapusule in cell to extract fixations
            %SampleRateE = 1/1000;
            %extract fixations using k-means clustering
            try
                fixationstats = ClusterFixEgo(scanpath,SampleRateE);
            catch
                continue;
            end
            myfixations = fixationstats{1}.fixations';            
            myfixations = int32(myfixations);
            myfixations_time = fixationstats{1}.fixationtimes;
            %myfixations_time
            %(myfixations_time(2,:) - myfixations_time(1,:))*1000/24
            myfixations_saccadetime = fixationstats{1}.saccadetimes;
    
            typefix = ones(1,length(fix_x))*0;
            for t= 1:size(myfixations,1)
                typefix(myfixations_time(1,t):myfixations_time(2,t)) = t;
            end
       
            %     %extract microsaccades overall
            scanpath = fixationstats{1}.XY';
            scanpath = horzcat([1:size(scanpath,1)]', scanpath);
            microsad = micsaccdeg(scanpath, 1/SampleRateE);
            microsadmask = zeros(1,size(scanpath,1));
            for m = 1:size(microsad,1)
                microsadmask(microsad(m,1):microsad(m,2)) = m;
            end
            freq = size(microsad,1);
            AveragedSaccadeRate = AveragedSaccadeRate + freq;
            CountSad = CountSad + 1;  

            %pre-filter fixations and remove those out of bound
            if isempty(myfixations)
                continue;
            end
            
            try
                img1 = read(xyloObj,fix_t(1));
                img2 = read(xyloObj,fix_t(end));
                img1 = double(imresize(img1, [480 640]/8));
                img2 = double(imresize(img2, [480 640]/8));
                dist = norm(img1(:)-img2(:),2)/length(img1(:));
                %dist
                
            catch
                continue;
            end
            
            if dist < 0.4
                
                distL2=[distL2 dist];

                myfixations_x = myfixations(:,1);
                myfixations_y = myfixations(:,2);

                myfixations = [myfixations_x myfixations_y];
                myfixations = int32(double(myfixations)/double(1280)*1280);   
                
                %get saliency matrix
%                 myfixations_saliency = [];
%                 for sstep = 1:length(fix_t)
%                     img = read(xyloObj,fix_t(sstep));
%                     out = gbvs(img); 
%                     saliency_map = imresize( out.master_map , [1280 1280] , 'bicubic' );
%                     salval = saliency_map(myfixations_y,myfixations_x);
%                     myfixations_saliency = [myfixations_saliency salval];
%                 end

                % extract number of microsaccades per fixations
                freq_microsac = [];
                scanpath = fixationstats{1}.XY';
                scanpath = horzcat([1:size(scanpath,1)]', scanpath);
                for F = 1:size(myfixations,1)
                    mask = microsadmask(myfixations_time(1,F):myfixations_time(2,F));
                    mask = unique(mask);
                    N = nnz(mask); %number of non-zero values in vector
                    freq = N;
                    %freq
                    freq_microsac = [freq_microsac freq];
                end
                mytrial.freq_microsac = freq_microsac;
                
                mytrial.videoname = fullvideopath;
                mytrial.startframe = fix_t(1);
                mytrial.endframe = fix_t(end);
                mytrial.fixations = myfixations;
                mytrial.fixations_time = myfixations_time;
                mytrial.fixations_saccadetime = myfixations_saccadetime;
                mytrial.dist = dist;

                CE = [CE; mytrial];
            else
                filtereddistL2 = [filtereddistL2 dist];
            end
            
            
        end
    end
    
end
AveragedSaccadeRate = AveragedSaccadeRate/(CountSad*2);
save(['Mat/FrameDistL2_' type '.mat'],'distL2','CE','filtereddistL2','AveragedSaccadeRate','-v7.3'); %file large; use -v7.3 option

%% plot random euclid distance
% NumRand = 100;
% ChanceDist = [];
% 
% for m = 1:length(matlist)
%     load(['Mat_' type '/gaze_compiled_' type '/' matlist(m).name ]);
%     m
%     %load video
%     if strcmp(type, 'os')
%         OriVideoFolder = 'OSData_Full';
%         videoname = matlist(m).name(1:end-4);
%         videofoldernames = split(videoname,'_');
%         vfolder = videofoldernames{1};
%         vname = videofoldernames{4};    
%         dirinfo = dir([OriVideoFolder '/' vfolder '/']);
%         dirinfo = dirinfo(3:end);
%         subdirinfo = [];
%         for K = 1 : length(dirinfo)
%           if dirinfo(K).isdir
%             thisdir = dirinfo(K).name;
%             break;
%           end
%         end
%         fullvideopath = [OriVideoFolder '/' vfolder '/' thisdir '/' vname '.avi'];
%     else
%         fullvideopath = ['/media/mengmi/KLAB15/Mengmi/EGTEAplus/full_videos/' matlist(m).name(1:end-4) '.mp4'];
%     end
%     
%     try
%         xyloObj = VideoReader(fullvideopath);
%         TotalNum = xyloObj.FrameRate*xyloObj.Duration;
%         r = randi([1 int32(TotalNum)],2,NumRand);
%         
%         for p = 1:NumRand
%             
%             try
%                 img1 = read(xyloObj,r(1,p));
%                 img2 = read(xyloObj,r(2,p));
%                 img1 = double(imresize(img1, [480 640]/8));
%                 img2 = double(imresize(img2, [480 640]/8));
%                 dist = norm(img1(:)-img2(:),2)/length(img1(:));
%                 ChanceDist = [ChanceDist dist];
%             catch
%                 continue;
%             end
%         end
%         
%     catch
%         continue;
%     end   
% end
% save(['Mat/FrameDistL2_' type '_chance.mat'],'ChanceDist');


%% plot euclid distance
hb = figure; hold on;
set(gca,'linewidth',2); set(hb,'Position',[313   248   293   242]);

linewidth = 2.5;
load(['Mat/FrameDistL2_' type '.mat']);
load(['Mat/FrameDistL2_' type '_chance.mat']);
distL2 = [distL2 filtereddistL2];

[h p] = ttest2(distL2, ChanceDist);

binranges = [0:0.05:1];
bincounts = histc(distL2,binranges);
bincounts = bincounts/sum(bincounts); 
plot(binranges, bincounts*100,'Color','k','LineWidth',linewidth);

bincounts = histc(ChanceDist,binranges);
bincounts = bincounts/sum(bincounts); 
plot(binranges, bincounts*100,'k--','LineWidth',linewidth);

%legend({'selected','random'});
%legend boxoff;
xlim([0 max(binranges)]);
xtickrange = [0:0.2:max(binranges)];
set(gca,'XTick',xtickrange,'FontSize',11);
ylim([0 1]*20);
set(gca,'YTick',[0:10:50],'FontSize',11);
xlabel('Euclid Distance (Pixel Level)','FontSize',12);
ylabel('Distribution (%)','FontSize',12);
%title([type '; p=' num2str(p)],'FontSize', 14);
set(gca, 'TickDir', 'out');
set(gca, 'Box','off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
print(hb,['Figures/EgoFrameEuclidDist_' type  printpostfix],printmode,printoption);

