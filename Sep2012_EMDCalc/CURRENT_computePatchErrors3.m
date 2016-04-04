numsUse = 1:9;

for ii = 1:length(numsUse)
    t1 = clock;
    fileNm = ['patchesSep2011DataTest4_rand' num2str(numsUse(ii)) '.mat'];
    resFileNm = ['patchesSep2011DataTest4_rand' num2str(numsUse(ii)) '_results.mat'];
    numSecFileNm = ['patchesSep2011DataTest4_rand' num2str(numsUse(ii)) '_numSeconds.mat'];
    CURRENT_generatePatchErrors_multiThreaded(fileNm,resFileNm)
    t2 = clock;
    numSeconds = etime(t2,t1)
    save(numSecFileNm,'numSeconds');
    
end

t1 = clock;
fileNm = ['patchesSep2011DataTest4.mat'];
resFileNm = ['patchesSep2011DataTest4_results.mat'];
numSecFileNm = ['patchesSep2011DataTest4_numSeconds.mat'];
CURRENT_generatePatchErrors_multiThreaded(fileNm,resFileNm)
t2 = clock;
numSeconds = etime(t2,t1)
save(numSecFileNm,'numSeconds'); 

