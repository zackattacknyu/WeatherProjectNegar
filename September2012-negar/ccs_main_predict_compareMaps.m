
predYnickTree = boostTreeVal2(boostStruct,inf,uint8(Xte),0.1);

%%
precip = zeros(500,750);
precip(ir<0) = -1;
precip(L==0) = 0;

precip1 = precip;
precip2 = precip;
precip3 = precip;

precip1(ir>0 & L>0) = predYnickTree;
precip2(ir>0 & L>0) = rr2;
%precip3(ir>0 & L>0) = rr;

figure(1)
imagesc(precip1)
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
colorbar('vertical')
title(fn)

figure(2)
imagesc(precip2)
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
colorbar('vertical')
title(fn)

figure(3)
imagesc(precip3)
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
colorbar('vertical')
title(fn)