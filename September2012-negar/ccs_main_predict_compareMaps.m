[Xte,nn] = ccs_patchpixel_Feature(ir,L,MAXL,FF);
    
predYotherTree = predYTest(nn);
predYactual = Yte(nn);

precip = zeros(500,750);
precip(ir<0) = -1;
precip(L==0) = 0;
precip(ir>0 & L>0) = predYotherTree;

precip2 = zeros(500,750);
precip2(ir<0) = -1;
precip2(L==0) = 0;
precip2(ir>0 & L>0) = predYactual;

precip3 = zeros(500,750);
precip3(ir<0) = -1;
precip3(L==0) = 0;
precip3(ir>0 & L>0) = rr;

figure(1)
imagesc(precip)
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