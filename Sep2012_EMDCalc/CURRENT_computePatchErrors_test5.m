numsUse = [2 3 5:9 44:52 57 61 95 107:111 138:148 157];

for ii = 1:length(numsUse)
    t1 = clock;
    fileNm = ['patchesSep2011DataTest5_time' num2str(numsUse(ii)) '.mat'];
    resFileNm = ['patchesSep2011DataTest5_time' num2str(numsUse(ii)) '_results.mat'];
    numSecFileNm = ['patchesSep2011DataTest5_time' num2str(numsUse(ii)) '_numSeconds.mat'];
    CURRENT_generatePatchErrors_multiThreaded(fileNm,resFileNm)
    t2 = clock;
    numSeconds = etime(t2,t1)
    save(numSecFileNm,'numSeconds');    
end

