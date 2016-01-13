x = 0:.01:1;
y = 0:.01:1;

[xx,yy] = meshgrid(x,y);
zz = xx.*yy;
Xplot = xx(:);
Yplot = yy(:);
Zplot = zz(:);
Zplot2 = Xplot+Yplot;
figure
hold on
scatter3(Xplot,Yplot,Zplot,'ro');
scatter3(Xplot,Yplot,Zplot2,'go');
hold off