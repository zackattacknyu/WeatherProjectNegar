clear all
close all

DIM1 =[480,1440];

DIM2 = [160,280];

files = dir(['./ccs_hrly/LRrgo_hrly1207*']);
l = length(files);

%kk = loadbfn('radmask_2us25.bin',[160 280],'int8');
%kk = kk(5:100,41:272);
%ll = find(kk == 0);

%load('mask_US.mat');

for i =1:l
    i
    
    fn1 = ['./ccs_hrly/',files(i).name];
    fn2 = ['./ccsadj_hrly/Adj',files(i).name];
    fn3 = ['./q2_hrly/q21h',files(i).name(11:end)];
    
    if ~exist(fn1,'file'); continue; end
    if ~exist(fn2,'file'); continue; end          
    if ~exist(fn3,'file'); continue; end 
    
    
    ccs = loadbfn_lgz(fn1, DIM1, 'short')/100;
    ccsadj = loadbfn_lgz(fn2, DIM1, 'short')/100;
    q2 = loadbfn_lgz(fn3, DIM2, 'short')/10;
    
    ccs(ccs<= 1) = 0;
    ccsadj(ccsadj<= 1) = 0;
    q2(q2<=0.1) = 0;
    
    ccs = ccs(45:140,941:1172);
    ccsadj = ccsadj(45:140,941:1172);
    q2 = q2(5:100,41:272);
    
    cc1 = find(q2(:)<0); q2(cc1) = nan; ccs(cc1) = nan; ccsadj(cc1) = nan;
    cc2 = find(ccs(:)<0); ccs(cc2) = nan; ccsadj(cc2) = nan; q2(cc2) = nan;
    %cc3 = find(ccsadj(:)<0); ccs(cc3) = nan; ccsadj(cc3) = nan; q2(cc3) = nan; 
    
    ccs_s(:,:,i) = ccs;
    ccsadj_s(:,:,i) = ccsadj;
    q2_s(:,:,i) = q2;
    
    
end

for r = 1:96
    
    for c = 1:232
     
        nn = find(isnan(ccs_s(r,c,:)));
        mm = find(~isnan(ccs_s(r,c,:)));
        
        if length(nn) == l
            
            ccs_t(r,c) = nan;
            ccsadj_t(r,c) = nan;
            q2_t(r,c) = nan;
        else

     ccs_t(r,c) = nansum(ccs_s(r,c,:)); %./length(mm);
     ccsadj_t(r,c) = nansum(ccsadj_s(r,c,:)); %./length(mm);
     q2_t(r,c) = nansum(q2_s(r,c,:));%./length(mm);
     
        end
    end
end

%%
     figure(1)
     %imagesc(ccs_t.*mask_US)
     imagesc(ccs_t)
     colormap([1 1 1;1 1 1;jet(179)])
     caxis([-0.1 180]) 
     drwvect([-125 25 -67 49],[96 232],'us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67'});
     title(fn1);
     
     figure(2)
     %imagesc(ccsadj_t.*mask_US)
     imagesc(ccsadj_t)
     colormap([1 1 1;1 1 1;jet(179)])
     caxis([-0.1 180]) 
     drwvect([-125 25 -67 49],[96 232],'us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67'});
     title(fn2);
     
     figure(3)
     %imagesc(q2_t.*kk.*mask_US)
     imagesc(q2_t)
     colormap([1 1 1;1 1 1;jet(179)])
     caxis([-0.1 180]) 
     drwvect([-125 25 -67 49],[96 232],'us_states_outl_ug.tmp','k')
     colorbar('vertical')
     xlim([0 232]);
     ylim([0 96]);
     set(gca,'YTick',0:24:96);
     set(gca,'YTickLabel',{'49N','43','37N','31N','25N'});
     set(gca,'XTick',0:116:232);
     set(gca,'XTickLabel',{'125W','96W','67'});
     title(fn3);
