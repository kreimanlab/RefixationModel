R = linspace(0,10,100);
theta = linspace(0,360,360);
Z = linspace(0,10,360)'*linspace(0,10,100);
figure
polarPcolor(R,theta,Z,'Ncircles',10)