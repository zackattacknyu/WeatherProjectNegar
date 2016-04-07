t1 = clock;
fileNm = ['patchesSep2011DataTest7.mat'];
resFileNm = ['patchesSep2011DataTest7_results.mat'];
numSecFileNm = ['patchesSep2011DataTest7_numSeconds.mat'];
CURRENT_generatePatchErrors_multiThreaded(fileNm,resFileNm)
t2 = clock;
numSeconds = etime(t2,t1)
save(numSecFileNm,'numSeconds');    



