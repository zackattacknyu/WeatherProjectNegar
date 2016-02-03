clear all
close all

DIM1 =[480,1440];
    

%files = dir(['./ccs_hrly/LRrgo_hrly1201*']);
files = dir(['./ccs_hrly/LRrgo_hrly1207*']);
l = length(files);


for i =1:l
    i
    
    curName = files(i).name;
    fn1 = ['./ccs_hrly/',curName];
    fn2 = ['./ccsadj_hrly/Adj',curName];
    fn3 = ['./pmw_hrly/c25mw_hrly',curName(11:end)];
    
     if ~exist(fn1,'file'); continue; end
     if ~exist(fn2,'file'); continue; end          
     if ~exist(fn3,'file'); continue; end
     
     suffix = curName(7:end-7);
     
     ccs = loadbfn_lgz(fn1, DIM1, 'short')/100;
     ccsadj = loadbfn_lgz(fn2, DIM1, 'short')/100;
     pmw = loadbfn_lgz(fn3, DIM1, 'short')/100;
     %pmw = pmw(121:600,:);
     cc1 = find(pmw(:)<0); pmw(cc1) = nan; ccs(cc1) = nan; ccsadj(cc1) = nan;
     cc2 = find(ccs(:)<0); ccs(cc2) = nan; ccsadj(cc2) = nan; pmw(cc2) = nan;
     
     save(strcat('jan18Data/data_',suffix,'.mat'),'ccs','ccsadj','pmw');
     
end  