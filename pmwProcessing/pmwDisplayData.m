
load('mask_US.mat');

     %%

     figure(1)
     imagesc(ccs_s)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([0 -60 360 60],[480 1440],'nat_360_ug.tmp','k')
     colorbar('vertical')
     xlim([0 1440]);
     ylim([0 480]);
     set(gca,'YTick',0:80:480);
     set(gca,'YTickLabel',{'60N','40N','20N','0','20S','40S','60S'});
     set(gca,'XTick',0:240:1440);
     set(gca,'XTickLabel',{'0','60','120','180','240','300','360'});
     title('CCS Data');
     
     figure(2)
     imagesc(ccsadj_s)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([0 -60 360 60],[480 1440],'nat_360_ug.tmp','k')
     colorbar('vertical')
     xlim([0 1440]);
     ylim([0 480]);
     set(gca,'YTick',0:80:480);
     set(gca,'YTickLabel',{'60N','40N','20N','0','20S','40S','60S'});
     set(gca,'XTick',0:240:1440);
     set(gca,'XTickLabel',{'0','60','120','180','240','300','360'});
     title('CCS Adj Data');
     
     figure(3)
     imagesc(pmw_s)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([0 -60 360 60],[480 1440],'nat_360_ug.tmp','k')
     colorbar('horizontal')
     xlim([0 1440]);
     ylim([0 480]);
     set(gca,'YTick',0:80:480);
     set(gca,'YTickLabel',{'60N','40N','20N','0','20S','40S','60S'});
     set(gca,'XTick',0:240:1440);
     set(gca,'XTickLabel',{'0','60','120','180','240','300','360'});
     title('PMW Data');
     %%
     figure(4)
     imagesc(ccs_s(45:140,941:1172).*mask_US)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([-125 25 -67 49],[96 232],'us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43N','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67W'});
     title('CCS Data');
     
     figure(5)
     imagesc(ccsadj_s(45:140,941:1172).*mask_US)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([-125 25 -67 49],[96 232],'us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43N','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67W'});
     title('CCS Adj Data');
     
     figure(6)
     imagesc(pmw_s(45:140,941:1172).*mask_US)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([-125 25 -67 49],[96 232],'us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43N','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67W'});
     title('PMW Data');
