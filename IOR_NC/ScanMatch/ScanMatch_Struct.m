function ScanMatchInfo = ScanMatch_Struct(ScanMatchInfo)
% SCANMATCH_STRUCT is an Interactive GUI which prepares a structure to be 
% used with the ScanMatch toolbox. This function creates a substitution 
% matrix based on the Euclidian distance between each RoI and a RoI grid
% mask.  
% 
% This toolbox will output a structure with the following fields:
%
% ScanMatchInfo = 
% 
%           Xres: 1024
%           Yres: 768
%           Xbin: 12
%           Ybin: 8
%     RoiModulus: 12
%      Threshold: 3.5000
%       GapValue: 0
%        TempBin: 0
%      SubMatrix: [96x96 double]
%           mask: [768x1024 double]
%
% 
%   Part of the ScanMatch toolbox
%   Written by Filipe Cristino 
%   $Version: 1.00 $  $Date: 10/09/2009

% If ScanMatchInfo is inputed then display its parameters
if nargin == 1 
    % Check if the ScanMatchInfo structure is of the right form
    Ok = ScanMatch_CheckStructure(ScanMatchInfo);
else
    ScanMatchInfo.Xres = 1024;
    ScanMatchInfo.Yres = 768;
    ScanMatchInfo.Xbin = 12.0;
    ScanMatchInfo.Ybin = 8.0;
    ScanMatchInfo.RoiModulus = ScanMatchInfo.Xbin;
    ScanMatchInfo.Threshold = 3.5;
    ScanMatchInfo.GapValue = 0;
    ScanMatchInfo.TempBin = 0;
    % Compute substitution matrix
    ScanMatchInfo.SubMatrix = ScanMatch_CreateSubMatrix(ScanMatchInfo.Xbin,...
            ScanMatchInfo.Ybin, ScanMatchInfo.Threshold);
    ScanMatchInfo.mask = ScanMatch_GridMask(ScanMatchInfo.Xres,ScanMatchInfo.Yres, ScanMatchInfo.Xbin, ScanMatchInfo.Ybin);
end
