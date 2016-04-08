
for ii = 1:20
    t1 = clock;
    fileNm = ['patchesSep2011DataTest7.mat'];
    resFileNm = ['patchesSep2011DataTest7_samplingTest' num2str(ii) '_results.mat'];
    numSecFileNm = ['patchesSep2011DataTest7_samplingTest' num2str(ii) '_numSeconds.mat'];
    CURRENT_generatePatchErrors_sampling(fileNm,resFileNm)
    t2 = clock;
    numSeconds = etime(t2,t1)
    save(numSecFileNm,'numSeconds');    
end


for ii = 1:20
    t1 = clock;
    fileNm = ['patchesSep2011DataTest4.mat'];
    resFileNm = ['patchesSep2011DataTest4_samplingTest' num2str(ii) '_results.mat'];
    numSecFileNm = ['patchesSep2011DataTest4_samplingTest' num2str(ii) '_numSeconds.mat'];
    CURRENT_generatePatchErrors_sampling(fileNm,resFileNm)
    t2 = clock;
    numSeconds = etime(t2,t1)
    save(numSecFileNm,'numSeconds');    
end