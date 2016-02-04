
DIM1 =[480,1440];

for j = 1:31
    j
    dayStr = num2str(j,'%02d');
    %regexUse = strcat('./data/data_hrly1201',dayStr,'*');
    regexUse = strcat('./data/data_hrly1207',dayStr,'*');
    files = dir(regexUse);
    
    %files = dir(['./data/data_hrly1207*']);
    
    l = length(files);

    ccs_s = zeros(DIM1);
    ccsadj_s = zeros(DIM1);
    pmw_s = zeros(DIM1);

    for i =1:l
        %i

        fileStr = strcat('data/',files(i).name);
        %fileStr
        load(fileStr);

        ccs_s = getArraySum(ccs_s,ccs);
        ccsadj_s = getArraySum(ccsadj_s,ccsadj);
        pmw_s = getArraySum(pmw_s,pmw);

    end  
    
    save(strcat('daily1201/data_daily1207',dayStr,'.mat'),...
        'ccs_s','ccsadj_s','pmw_s');
    
    %save(strcat('daily1201/data_daily1201',dayStr,'.mat'),...
    %    'ccs_s','ccsadj_s','pmw_s');

    %save('data_monthly1201.mat','ccs_s','ccsadj_s','pmw_s');
    %save('data_monthly1207.mat','ccs_s','ccsadj_s','pmw_s');
    
end


%%

for i = 1:31
   curstr = num2str(i, '%02d' );
end