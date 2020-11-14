function [scores, scoreswhole ] = fcn_MMevalSS(HumanNumFix, Firstx, Firsty, Secondx, Secondy)

NumStimuli = length(Firstx);
ScanMatchInfo = ScanMatch_Struct(); %first column: horinzontal (longest); sec: vertical
scores = zeros(NumStimuli, HumanNumFix);
scoreswhole = [];
Imgw = 1024;
Imgh = 1280;
ImgSSh = ScanMatchInfo.Xres;
ImgSSw = ScanMatchInfo.Yres;

for i = 1:NumStimuli
    
    Firstx{i} = double(Firstx{i});
    Firsty{i} = double(Firsty{i});
    Secondx{i} = double(Secondx{i});
    Secondy{i} = double(Secondy{i});
    
    Fx = Firstx{i}/Imgh*ImgSSh;
    Fy = Firsty{i}/Imgw*ImgSSw;
    First = [Fx; Fy; zeros(1,length(Fx))]'; %add artificial third column as fixation duration
    if size(First, 1) >1 %remove 1st fixation as subj starts from center
        First = First(2:end,:);
    end
    
    Sx = Secondx{i}/Imgh*ImgSSh;
    Sy = Secondy{i}/Imgw*ImgSSw;
    if size(Sx,1) > size(Sx,2)
        error('impossible');
        Sx = Sx';
        Sy = Sy';
    end
    
    Second = [Sx; Sy; zeros(1,length(Sx))]'; %add artificial third column as fixation duration
    if size(Second, 1) >1 %remove 1st fixation as subj starts from center
        Second = Second(2:end,:);
    end
    
    seq1 = ScanMatch_FixationToSequence(First, ScanMatchInfo);
    seq2 = ScanMatch_FixationToSequence(Second, ScanMatchInfo);
    
    scw = ScanMatch(seq1, seq2, ScanMatchInfo);
    scoreswhole = [scoreswhole; scw];
    
%     for nSel = 1:HumanNumFix
%         
%         score = nan;
%         if length(seq1) >= nSel*2 || length(seq2) >= nSel*2
%             
%             if length(seq1) >= nSel*2
%                 temp1 = seq1(1:nSel*2);
%             end
%             if length(seq2) >= nSel*2
%                 temp2 = seq2(1:nSel*2);
%             end
%             score = ScanMatch(temp1, temp2, ScanMatchInfo);
%         end
%         scores(i, nSel) = score;
%     end

end

% plot(nanmean(scores,1))
% std(scores,0,1)
% mean(scoreswhole)


end %function end
    
