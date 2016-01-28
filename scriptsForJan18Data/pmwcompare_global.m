

clear all
close all

DIM1 =[480,1440];

%  for d = 1:31
%      d
%     
%     if(d<10)
% 	    dd = ['0' int2str(d)];
%         else
% 	    dd = [int2str(d)];
%         end;
     

files = dir(['./ccs_hrly/LRrgo_hrly1201*']);
l = length(files);

load('mask_US.mat');

for i =1:l
    i
    
    fn1 = ['./ccs_hrly/',files(i).name];
    fn2 = ['./ccsadj_hrly/Adj',files(i).name];
    fn3 = ['./pmw_hrly/c25mw_hrly',files(i).name(11:end)]
    
     if ~exist(fn1,'file'); continue; end
     if ~exist(fn2,'file'); continue; end          
     if ~exist(fn3,'file'); continue; end
     
     ccs = loadbfn_lgz(fn1, DIM1, 'short')/100;
     ccsadj = loadbfn_lgz(fn2, DIM1, 'short')/100;
     pmw = loadbfn_lgz(fn3, DIM1, 'short')/100;
     %pmw = pmw(121:600,:);
     cc1 = find(pmw(:)<0); pmw(cc1) = nan; ccs(cc1) = nan; ccsadj(cc1) = nan;
     cc2 = find(ccs(:)<0); ccs(cc2) = nan; ccsadj(cc2) = nan; pmw(cc2) = nan;
     
     ccs_s(:,:,i) = ccs;
     ccsadj_s(:,:,i) = ccsadj;
     pmw_s(:,:,i) = pmw;
     
     
%      figure(1)
%      imagesc(pmw_s(:,:,i))
%      colormap([1 1 1;1 1 1;jet(79)])
%      caxis([-0.25 20]) 
%      drwvect([0 -60 360 60],[480 1440],'/home/dank/t3_vects/nat_360_ug.tmp','k')
%      colorbar('horizontal')
%      xlim([0 1440]);
%      ylim([0 480]);
%      set(gca,'YTick',0:80:480);
%      set(gca,'YTickLabel',{'60N','40N','20N','0','20S','40S','60S'});
%      set(gca,'XTick',0:240:1440);
%      set(gca,'XTickLabel',{'0','60','120','180','240','300','360'});
%      title(fn3);
     
%      pause(2)
%      clf
     
     
     
     
end  
   
for r = 1:480
    
    for c = 1:1440
     
        nn = find(isnan(ccs_s(r,c,:)));
        
        if length(nn) == l
            
            ccs_t(r,c) = nan;
            ccsadj_t(r,c) = nan;
            pmw_t(r,c) = nan;
        else

     ccs_t(r,c) = nansum(ccs_s(r,c,:));
     ccsadj_t(r,c) = nansum(ccsadj_s(r,c,:));
     pmw_t(r,c) = nansum(pmw_s(r,c,:));
     
        end
    end
end
     da1 = ccs_t(181:240,:);
     da2 = ccsadj_t(181:240,:);
     da3 = pmw_t(181:240,:);
     

     figure(1)
     imagesc(ccs_t)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([0 -60 360 60],[480 1440],'/home/dank/t3_vects/nat_360_ug.tmp','k')
     colorbar('vertical')
     xlim([0 1440]);
     ylim([0 480]);
     set(gca,'YTick',0:80:480);
     set(gca,'YTickLabel',{'60N','40N','20N','0','20S','40S','60S'});
     set(gca,'XTick',0:240:1440);
     set(gca,'XTickLabel',{'0','60','120','180','240','300','360'});
     title(fn1);
     
     figure(2)
     imagesc(ccsadj_t)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([0 -60 360 60],[480 1440],'/home/dank/t3_vects/nat_360_ug.tmp','k')
     colorbar('vertical')
     xlim([0 1440]);
     ylim([0 480]);
     set(gca,'YTick',0:80:480);
     set(gca,'YTickLabel',{'60N','40N','20N','0','20S','40S','60S'});
     set(gca,'XTick',0:240:1440);
     set(gca,'XTickLabel',{'0','60','120','180','240','300','360'});
     title(fn2);
     
     figure(3)
     imagesc(pmw_t)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([0 -60 360 60],[480 1440],'/home/dank/t3_vects/nat_360_ug.tmp','k')
     colorbar('horizontal')
     xlim([0 1440]);
     ylim([0 480]);
     set(gca,'YTick',0:80:480);
     set(gca,'YTickLabel',{'60N','40N','20N','0','20S','40S','60S'});
     set(gca,'XTick',0:240:1440);
     set(gca,'XTickLabel',{'0','60','120','180','240','300','360'});
     title(fn3);
     
     figure(4)
     imagesc(ccs_t(45:140,941:1172).*mask_US)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([-125 25 -67 49],[96 232],'/home/dank/t3_vects/us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43N','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67W'});
     title(fn1);
     
     figure(5)
     imagesc(ccsadj_t(45:140,941:1172).*mask_US)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([-125 25 -67 49],[96 232],'/home/dank/t3_vects/us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43N','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67W'});
     title(fn2);
     
     figure(6)
     imagesc(pmw_t(45:140,941:1172).*mask_US)
     colormap([1 1 1;1 1 1;jet(79)])
     caxis([-1 80]) 
     drwvect([-125 25 -67 49],[96 232],'/home/dank/t3_vects/us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43N','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67W'});
     title(fn3);
