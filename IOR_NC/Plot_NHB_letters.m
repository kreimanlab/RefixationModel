clear all; close all; clc;
letterslist = {'A','B','C','D','E','F','G','H'};
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

% for l = 1:length(letterslist)
%     hb=figure; text(0,1,letterslist{l},'fontweight','bold','FontSize',14);
%     get(hb,'Position')
%     set(gca,'visible','off')
%     set(gca, 'TickDir', 'out');
%     set(gca, 'Box','off');
%     set(hb,'Position',[675   950    31    19]);
%     set(hb,'Units','Inches');
%     pos = get(hb,'Position');
%     %set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%     set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%     print(hb,['Figures/font_'  letterslist{l} printpostfix],printmode,printoption);
% end

% letterslist = {'A','B','C','D','E','F','G','H','J'};
% numberslist = [1:12];
% printpostfix = '.eps';
% printmode = '-depsc'; %-depsc
% printoption = '-r200'; %'-fillpage'
% 
% for l = 1:length(letterslist)
%     for n = 1:length(numberslist)
%         hb=figure; text(0,1,[letterslist{l} num2str(numberslist(n))],'FontSize',14,'fontweight','bold');
%         get(hb,'Position')
%         set(gca,'visible','off')
%         set(gca, 'TickDir', 'out');
%         set(gca, 'Box','off');
%         set(hb,'Position',[675   950    44    19]);
%         set(hb,'Units','Inches');
%         pos = get(hb,'Position');
%         %set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%         set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%         print(hb,['Figures/font_'  letterslist{l} num2str(numberslist(n)) printpostfix],printmode,printoption);
%     end
% end

%figure label string
textlabel = {'Hs','Visual search 1',...
    'Hs','Visual search 2',...
    'Hs','Visual search 3',...
    'Hs','Free viewing',...
    'Mm','Free viewing 1',...
    'Mm','Free viewing 2',...
    'Hs','Videos 1',...
    'Hs','Videos 2'};
NumCate = 8;

%% print the string in two lines
for c = 1:NumCate
    hb=figure; text(0,1,[textlabel{2*(c-1)+1}],'FontSize',12);
    get(hb,'Position')
    set(gca,'visible','off')
    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');
    set(hb,'Position',[675   950    44    19]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    %set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['Figures/figlabel_' num2str(c) '_1' printpostfix],printmode,printoption);
    
    hb=figure; text(0,1,[textlabel{2*c}],'FontSize',12);
    get(hb,'Position');
    set(gca,'visible','off')
    set(gca, 'TickDir', 'out');
    set(gca, 'Box','off');
    set(hb,'Position',[675   950    140    19]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    %set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    print(hb,['Figures/figlabel_' num2str(c) '_2' printpostfix],printmode,printoption);
end

