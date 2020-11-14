clear all; close all; clc;

type = 'os'; %os, egteaplus
matlist = dir(['Mat_' type '/gaze_compiled_' type '/*.mat']);
fRate = 24;
visdeg = 21.3; %pixels per degree 60 deg wrt image size 1280
MaxDur = 5; %secs
Interval = fRate*MaxDur;
CE = []; %compiled eyetracking data across monkeys
SampleRateE = double(int32(1/fRate*1000))/1000.0; %24 Hz
Thres = int32(0.3*fRate);

vissize = 400;

for m = 1:length(matlist)
    load(['Mat_' type '/gaze_compiled_' type '/' matlist(m).name ]);
    
    %load video
    if strcmp(type, 'os')
        OriVideoFolder = 'OSData_Full';
        videoname = matlist(m).name(1:end-4);
        videofoldernames = split(videoname,'_');
        vfolder = videofoldernames{1};
        vname = videofoldernames{4};    
        dirinfo = dir([OriVideoFolder '/' vfolder '/']);
        dirinfo = dirinfo(3:end);
        subdirinfo = [];
        for K = 1 : length(dirinfo)
          if dirinfo(K).isdir
            thisdir = dirinfo(K).name;
            break;
          end
        end
        fullvideopath = [OriVideoFolder '/' vfolder '/' thisdir '/' vname '.avi'];
    else
        fullvideopath = ['/media/mengmi/KLAB15/Mengmi/EGTEAplus/full_videos/' matlist(m).name(1:end-4) '.mp4'];
    end
    xyloObj = VideoReader(fullvideopath);
    if fRate ~= xyloObj.FrameRate
        error(['loading video frame not match']);
    end    
    
    stopF = size(compiled,1)-Interval;
    
    for s = 1:Interval:stopF
        
        display(['processing: ' num2str(m) '; frame: ' num2str(s) ]);
        
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
            
            %write video clips without fixations
%             v = VideoWriter(['sampleS_' type '.avi']);
%             v.FrameRate = 24;
%             open(v);
%             for t = 1:length(fix_t)
%                 img = read(xyloObj,fix_t(t));
%                 img = imresize(img,[1024 1280]);
%                 RGB = insertShape(img,'FilledCircle',[fix_x(t) fix_y(t) 15],'Color','r','LineWidth',5);
%                 RGB = imresize(RGB, [vissize vissize]);
%                 imshow(RGB);
%                 drawnow;    
%                 writeVideo(v,RGB);
%             end
%             close(v);
            
            
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
            myfixations_saccadetime = fixationstats{1}.saccadetimes;
            
            
%             figure; plot(myfixations(:,1),myfixations(:,2),'o');%xlim([0 1280]); ylim([0 1024]);
            %length(size(myfixations,1))
            %write video clips with fixations
            typefix = ones(1,length(fix_x))*0;
            for t= 1:size(myfixations,1)
                typefix(myfixations_time(1,t):myfixations_time(2,t)) = t;
            end
%             v = VideoWriter(['sampleF_' type '.avi']);
%             v.FrameRate = 24;
%             open(v);
%             mkdir(['/home/mengmi/Desktop/' type]);
%             for t = 1:length(fix_t)
%                 img = read(xyloObj,fix_t(t));
%                 img = imresize(img,[1024 1280]);
%                 if typefix(t) >0
%                     %RGB = insertShape(img,'FilledCircle',[fix_x(t) fix_y(t) 15],'Color','red','LineWidth',5);
%                     RGB = insertShape(img,'FilledCircle',[myfixations(typefix(t),1) myfixations(typefix(t),2) 15],'Color','red','LineWidth',5);
%                 else
%                     RGB = insertShape(img,'FilledCircle',[fix_x(t) fix_y(t) 15],'Color','yellow','LineWidth',5);
%                 end
%                 RGB = imresize(RGB, [vissize vissize]);
%                 imwrite(RGB,['/home/mengmi/Desktop/' type '/frame_' num2str(t) '.jpg']);
%                 imshow(RGB);
%                 drawnow;    
%                 writeVideo(v,RGB);
%             end
%             close(v);
%             
            t = length(fix_t);
            img = read(xyloObj,fix_t(t));
            img = imresize(img,[1024 1280]);
            %display all fixations on last video frames
            RGB = insertShape(img,'FilledCircle',[myfixations ones(size(myfixations,1),1)*15],'Color','red','LineWidth',5);
            figure;
            imshow(RGB);
            hold on;
            plot(fix_x, fix_y,'-*');
            pause;
            

            %pre-filter fixations and remove those out of bound
            if isempty(myfixations)
                continue;
            end
            
            myfixations_x = myfixations(:,1);
            myfixations_y = myfixations(:,2);

            myfixations = [myfixations_x myfixations_y];

            %conver to same as carlos imgsize 596
            myfixations = int32(double(myfixations)/double(1280)*1280);            

            mytrial.fixations = myfixations;
            mytrial.fixations_time = myfixations_time;
            mytrial.fixations_saccadetime = myfixations_saccadetime;
            
            CE = [CE; mytrial];
    
        end
    end
    
end

%save(['Mat/CE_' type '.mat'],'CE','-v7.3'); %file large; use -v7.3 option