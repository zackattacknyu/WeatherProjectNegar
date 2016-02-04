%files = dir(['./data/data_hrly1201*']);
files = dir(['./data/data_hrly1207*']);
l = length(files);

fileStr = strcat('data/',files(1).name);
load(fileStr);

ccs_s = zeros(size(ccs));
ccsadj_s = zeros(size(ccsadj));
pmw_s = zeros(size(pmw));

for i =1:l
    i
    
    fileStr = strcat('data/',files(i).name);
    load(fileStr);
    
    ccs_s = getArraySum(ccs_s,ccs);
    ccsadj_s = getArraySum(ccsadj_s,ccsadj);
    pmw_s = getArraySum(pmw_s,pmw);
     
end  

%save('data_monthly1201.mat','ccs_s','ccsadj_s','pmw_s');
save('data_monthly1207.mat','ccs_s','ccsadj_s','pmw_s');