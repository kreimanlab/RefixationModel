clear all; close all; clc;

% %https://www.immagic.com/eLibrary/ARCHIVES/GENERAL/TKK_FI/H070420G.pdf
% % height = 14.4; %visible size; horizontal
% % width = 10.8; %visisble size; vertical
% height = 15.2; %physical size given 4:3 screen ratio
% width = 11.4; %physical size given 4:3 screen ratio
% 
% imgheight = 1280; %in pixels
% imgwidth = 1024; %in pixels
% 
% %convert to cm from inch
% unit = 2.54; %1 inch  = 2.54 cm
% height = height * unit * 0.01; %now in meter
% width =  width * unit * 0.01; %now in meter
% 
% valueused = 156/5; %data used in the paper
% subjdist = [0.4:0.02:0.65]; %subject sitting distance away from screen
% 
% height_VAlist = []; width_VAlist = [];
% pixelpervd_heightlist = []; pixelpervd_widthlist = [];
% 
% for i = 1:length(subjdist)
%     
%     height_VA = 2* atan(height/2/subjdist(i)) /pi*180; %in degrees
%     width_VA = 2* atan(width/2/subjdist(i)) /pi*180; %in degrees
% 
%     pixelpervd_height = imgheight/height_VA; %pixels per visual angle degree
%     pixelpervd_width = imgwidth/width_VA; %pixels per visual angle degree
%     
%     height_VAlist = [height_VAlist height_VA];
%     width_VAlist = [width_VAlist width_VA];
%     pixelpervd_heightlist = [pixelpervd_heightlist pixelpervd_height];
%     pixelpervd_widthlist = [pixelpervd_widthlist pixelpervd_width];
%     
% end
% 
% hb = figure;
% subplot(2,2,1); hold on;
% plot(subjdist, height_VAlist,'r-');
% xlabel(['subj sitting distance (meter)']); ylabel('screen (dva)');
% title('horizontal');
% subplot(2,2,2); hold on;
% plot(subjdist, pixelpervd_heightlist,'r-');
% title('horizontal');
% xlabel(['subj sitting distance (meter)']); ylabel('pixels per degree');
% subplot(2,2,3); hold on;
% plot(subjdist, width_VAlist,'r-');
% xlabel(['subj sitting distance (meter)']); ylabel('screen (dva)');
% title('vertical');
% subplot(2,2,4); hold on;
% plot(subjdist, pixelpervd_widthlist,'r-');
% xlabel(['subj sitting distance (meter)']); ylabel('pixels per degree');
% title('vertical');

% Based on actual measurements
% Physical screen size (in mm): 360x295
% Physical distance between monitor and the eyetracking camera (in mm): 76.2
% Screen Size in Pixels: 1280 x 1024
% IP address to access to eyetracking server: 100.1.1.1
HeightScreen = 36; %in cm
DistScreen = mean([61 74 63 68 66]); %in cm
VisualAngle_Height = 2*atan(HeightScreen/2/DistScreen)/pi*180;
WidthScreen = 29.5;
VisualAngle_Width = 2*atan(WidthScreen/2/DistScreen)/pi*180;
%
subjlist={'subj12-fb','subj13-va','subj15-lp','subj16-jw','subj17-zd'};





