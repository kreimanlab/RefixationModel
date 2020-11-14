function fcn_sigstar(x1,x2,y1,percentage)
    plot([x1 x2],[y1 y1],'k','LineWidth',2.5);
    plot([x1 x1],[y1-percentage*y1 y1],'k','LineWidth',2.5);
    plot([x2 x2],[y1-percentage*y1 y1],'k','LineWidth',2.5);

end
