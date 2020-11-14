clear all; close all; clc;

type = 'os'; %os, egteaplus, pranav
matlist = dir(['Mat_' type '/gaze_compiled_' type '/*.mat']);

if strcmp(type, 'pranav')
    fRate = 30;
    Thres = int32(1*fRate); %int32(0.3*fRate)
else
    fRate = 24;
    Thres = int32(0.3*fRate); %int32(0.3*fRate)
end

MaxDur = 5; %secs
Interval = fRate*MaxDur;
CE = []; %compiled eyetracking data across monkeys
SampleRateE = double(int32(1/fRate*1000))/1000.0; %24 Hz


for m = 1:length(matlist)
    load(['Mat_' type '/gaze_compiled_' type '/' matlist(m).name ]);
    stopF = size(compiled,1)-Interval;
    
    for s = 1:Interval:stopF
        
        display(['processing: ' num2str(m) '; frame: ' num2str(s) ]);
        
        fix_x = compiled(s:s+Interval-1,1);
        fix_y = compiled(s:s+Interval-1,2); 
        
        if fix_x(1) == 1 && fix_y(1) == 1
            continue;
        else
            %filter out illegal scanpath
            fix_xc = fix_x; fix_yc = fix_y;            
            [ind val] = find(fix_xc == 1 & fix_yc == 1);
            if ~isempty(ind)
                fix_x = fix_x(1:ind(1)-1);
                fix_y = fix_y(1:ind(1)-1);
            end           
            
            if length(fix_x) < Thres
                continue;
            end
            
            scanpath = [fix_x fix_y]; %input: 2 by dim
            %scanpath output: dim by 2
            scanpath = scanpath'; %2 by dim
            scanpath = {scanpath}; %encapusule in cell to extract fixations
            %SampleRateE = 1/1000;
            %extract fixations using k-means clustering
            try
                fixationstats = ClusterFix(scanpath,SampleRateE);
            catch
                continue;
            end
            myfixations = fixationstats{1}.fixations';            
            myfixations = int32(myfixations);
            myfixations_time = fixationstats{1}.fixationtimes;
            myfixations_saccadetime = fixationstats{1}.saccadetimes;

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

save(['Mat/CE_' type '.mat'],'CE','-v7.3'); %file large; use -v7.3 option