fileNum=50;

dataFiles = dir('data/compiledData/data*');
load(['data/compiledData/' dataFiles(fileNum).name]);
    
rr1 = rr1(251:875,5626:7375);
rr2 = rr2(1:625,:);
ir = ir(1:625,:);
obs = obs(1:625,:); 

curImage = rr1;
minDist = 15;
patchSize = 20;
maxTries = 1000;
maxNumPatches = 50;

[ randPatches, randPatchesCornerCoord, patchSum ] = ...
    getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries );


figure(1)
imagesc(curImage)
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
drwvect([-135 25 -65 50],[625 1750],'us_states_outl_ug.tmp','k');
colorbar('vertical')
hold on
for i = 1:length(randPatchesCornerCoord)
   centerLoc = randPatchesCornerCoord{i};
   centerLoc = centerLoc - [patchSize/2 patchSize/2];
   rectangle('Position',[centerLoc(2) centerLoc(1) patchSize patchSize]);
end
hold off








