numsUse = [111   147   157   146   140   145   141   110];

for ii = 1:length(numsUse)
    t1 = clock;
    fileNm = ['patchesSep2011DataTest6_time' num2str(numsUse(ii)) '.mat'];
    resFileNm = ['patchesSep2011DataTest6_time' num2str(numsUse(ii)) '_results.mat'];
    numSecFileNm = ['patchesSep2011DataTest6_time' num2str(numsUse(ii)) '_numSeconds.mat'];
    CURRENT_generatePatchErrors_multiThreaded(fileNm,resFileNm)
    t2 = clock;
    numSeconds = etime(t2,t1)
    save(numSecFileNm,'numSeconds');    
end



