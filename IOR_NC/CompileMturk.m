clear all; close all; clc;

typedataset = 'naturaldesign';
sqcommand = ['sqlite3 -header -csv mturk/db/expReturnFix_' typedataset '.db "select * from similarity;" > mturk/csv/similarity_' typedataset '.csv'];
system(sqcommand);

fid = fopen(['mturk/csv/similarity_' typedataset '.csv']);
out = textscan(fid,'%s');
strtotal = out{1,1};
pattern1 = ['""http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/' typedataset '/'];

answer = [];
mturkData = [];
for i = 1:length(strtotal)

    str = strtotal{i,1};         
    k1 = strfind(str,pattern1);
        
    if isempty(k1)
        continue;
    end
    
    if isempty(strfind(strtotal{i-6},'{""current_trial"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i-4},'""trialdata"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i-3},'{""rt"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i-1},'""imageL"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i+1},'""typeseq"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i+3},'""gtlabel"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i+5},'""stimuliseq"":'))
        continue;
    end   
    
    if isempty(strfind(strtotal{i+13},'""imageR"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i+15},'""response"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i+17},'""imageT"":'))
        continue;
    end
    
    if isempty(strfind(strtotal{i+19},'""uniqueid"":'))
        continue;
    end
    
    
    
    strpart = strtotal{i+20};
    strpart = strsplit(strpart,':');
    workerid = strpart{1}(3:end);
    assignmentid = strpart{2}(1:end-3);
    rt = str2num(strtotal{i-2}(1:end-1));
    imgL = strtotal{i}(3:end-3);
    type = str2num(strtotal{i+2}(1));
    gtlabel = str2num(strtotal{i+4}(1));
    stimuliseq = str2num(strtotal{i+6}(1:end-1));
    imgR = strtotal{i+14}(3:end-3);
    response = str2num(strtotal{i+16}(3));
    imgT = strtotal{i+18}(3:end-4);
    trial = str2num(strtotal{i+8}(1:end-1)); 
    
    ans = struct();
    ans.workerid = workerid;
    ans.assignmentid = assignmentid;
    ans.rt = rt;
    ans.imgL = imgL;
    ans.imgR = imgR;
    ans.imgT = imgT;
    ans.type = type;
    ans.gtlabel = gtlabel;
    ans.stimuliseq = stimuliseq;
    ans.response = response;
    ans.trial = trial;

    if length(answer) > 0 
        if strcmp(answer(end).workerid,ans.workerid) && strcmp(answer(end).assignmentid,ans.assignmentid)
            answer = [answer ans];
        else
            subj.workerid = ans.workerid;
            subj.assignmentid = assignmentid;
            subj.numhits = length(answer);
            subj.answer = answer;            
            mturkData = [mturkData subj];
            answer = [];
            answer = [answer ans];
        end
    else
        answer = [answer ans];
    end
  
end
subj.workerid = ans.workerid;
subj.assignmentid = assignmentid;
subj.numhits = length(answer);
subj.answer = answer;
mturkData = [mturkData subj];

fclose(fid);
save(['mturk/Mat/mturk_' typedataset '.mat'],'mturkData');