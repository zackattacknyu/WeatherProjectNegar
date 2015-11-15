fileNum=25;

dataFiles = dir('data/compiledData/data*');
load(['data/compiledData/' dataFiles(fileNum).name]);
    
rr1 = rr1(251:875,5626:7375);
rr2 = rr2(1:625,:);
ir = ir(1:625,:);
obs = obs(1:625,:); 

curImage = obs;
minDist = 15;
patchSize = 20;
maxTries = 1000;
maxNumPatches = 50;

[ randPatches, randPatchesCornerCoord, patchSum ] = ...
    getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries );


drawMapWithPatches(curImage,randPatchesCornerCoord,patchSize);








