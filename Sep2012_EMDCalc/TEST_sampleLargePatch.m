%dataFiles = dir('zach_RR/q2hrus1210*');
%dataFiles2 = dir('zach_ccs/rgo1210*');
%dataFiles3 = dir('negarPredMaps/decTreePred1210*');

dataFiles = dir('zach_RR2/q2hrus1109*');
dataFiles2 = dir('zach_ccs2/rgo1109*');
dataFiles3 = dir('negarPredMaps2/decTreePred1109*');

numT = min([length(dataFiles) length(dataFiles2) length(dataFiles3)]);
numSampleTimes = 400;
minTimeDiff = 2;
epsilon = 1e-2;
precipThresh = 1000;

timeStamps2 = [7];

numTimeStamps = length(timeStamps2);

numPred = 2;
patchesT = cell(1,numTimeStamps);
patchesPred = cell(1,numTimeStamps);

for tt = 1:numTimeStamps
    
    %tt
    
    fileNum = timeStamps2(tt);
    
    fileNum
    
    %fn = ['zach_RR/q2hrus' dataFiles3(fileNum).name(12:end)];
    %fn2 = ['zach_ccs/rgo' dataFiles3(fileNum,1).name(12:end)];
    %fn3 = ['negarPredMaps/decTreePred' dataFiles3(fileNum,1).name(12:end)];
    
    fn = ['zach_RR2/q2hrus' dataFiles3(fileNum).name(12:end)];
    fn2 = ['zach_ccs2/rgo' dataFiles3(fileNum,1).name(12:end)];
    fn3 = ['negarPredMaps2/decTreePred' dataFiles3(fileNum,1).name(12:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    if ~exist(fn2,'file')
                continue;
    end
    if ~exist(fn3,'file')
                continue;
    end
    
    curData = load(fn);
    try
       ir = curData.ir; 
    catch
       ir = curData.rr;
    end
    curImage = ir(126:625,126:875);
    curImage(curImage<0)=0;
    if(sum(curImage(:))<=epsilon)
       continue; 
    end
    
    ccsData = load(fn2); 
    try
        ccsIR = ccsData.ir;
    catch
        ccsIR = ccsData.ccs;
    end
    ccsOverUS = ccsIR(376:875,5751:6500);
    
    negarPred = load(fn3); precipMap = negarPred.precip;

    ccsOverUS(ccsOverUS<0)=0;
    precipMap(precipMap<0)=0;
    
    curPredImages = cell(1,numPred);
    curPredImages{1} = precipMap;
    curPredImages{2} = ccsOverUS;
    
    indicesUse = find(curImage>0);
    decTreeRMSE = sqrt(mean((curImage(indicesUse)-precipMap(indicesUse)).^2))
    ccsRMSE = sqrt(mean((curImage(indicesUse)-ccsOverUS(indicesUse)).^2))
    
    minDist = 180;
    patchSize = 200;
    maxTries = 2000;
    maxNumPatches = 5;
    minPatchSum = 3;

    [ targetPatches, randPatchesCornerCoord, patchSum ] = ...
        getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries, minPatchSum );

    
    curPredPatches = cell(numPred,length(targetPatches));
    for j = 1:numPred
        curPredPatches(j,:) = getPatchesFromCoords(curPredImages{j},randPatchesCornerCoord,patchSize);
    end
    
    indicesToKeep = zeros(1,length(targetPatches));
    newInd = 1;
    for i = 1:length(targetPatches)
       
        curT = targetPatches{i};
        if(sum(curT(:))<=epsilon)
            continue;
        end
        
        
        numBad=0;
        for j = 1:numPred
           curPred = curPredPatches{j,i}; 
           if(sum(curPred(:))<=epsilon)
              numBad=numBad+1; 
           end
        end
        if(numBad>0)
           continue; 
        end
        
        indicesToKeep(newInd) = i;
        newInd = newInd + 1;
        
    end
    indicesToKeep = indicesToKeep(1:(newInd-1));
    
    patchesT{tt} = targetPatches(indicesToKeep);
    patchesPred{tt} = curPredPatches(:,indicesToKeep);
    
    figure
    subplot(2,2,1)
    drawMapWithPatches(curImage,randPatchesCornerCoord(indicesToKeep),patchSize);
    
    subplot(2,2,2)
    drawMapWithPatches(precipMap,randPatchesCornerCoord(indicesToKeep),patchSize);
    
    subplot(2,2,4)
    drawMapWithPatches(ccsOverUS,randPatchesCornerCoord(indicesToKeep),patchSize);
    
    pause(5);
    
end
%%

%now find total number of patches found
numPatches = 0;
for i = 1:length(patchesT)
    numPatches = numPatches + length(patchesT{i});
end


targetPatches = cell(1,numPatches);
predPatches = cell(numPred,numPatches);
index = 1;
for i = 1:length(patchesT)
    
    curPatchesT = patchesT{i};
    curPredPatches = patchesPred{i};
    
    for j = 1:length(curPatchesT);
        
        targetPatches{index} = curPatchesT{j};
        predPatches(:,index) = curPredPatches(:,j);
       
        index = index+1;
    end
    
end
%%

pNum=1;
figure
subplot(1,3,1)
imagesc(targetPatches{pNum})
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
colorbar('vertical')

subplot(1,3,2)
imagesc(predPatches{1,pNum})
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
colorbar('vertical')

subplot(1,3,3)
imagesc(predPatches{2,pNum})
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
colorbar('vertical')
%%

%THIS IS USED TO SUBSAMPLE THE LARGE PATCH
load('TEST_largeSamplePatchInfo1.mat');
%%
pNum=1;
curImage = targetPatches{pNum};
precipMap = predPatches{1,pNum};
ccsOverUS = predPatches{2,pNum};

minDist = 18;
patchSize = 20;
maxTries = 2000;
maxNumPatches = 100;
minPatchSum = 1;

[ targetSubPatches, randPatchesCornerCoord, patchSum ] = ...
    getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries, minPatchSum );


curPredPatches = cell(numPred,length(targetSubPatches));
curPredPatches(1,:) = getPatchesFromCoords(precipMap,randPatchesCornerCoord,patchSize);
curPredPatches(2,:) = getPatchesFromCoords(ccsOverUS,randPatchesCornerCoord,patchSize);

indicesToKeep = zeros(1,length(targetSubPatches));
newInd = 1;
for i = 1:length(targetSubPatches)

    curT = targetSubPatches{i};
    
    if(sum(curT(:))<=epsilon)
        
        continue;
    end


    numBad=0;
    for j = 1:numPred
        
       curPred = curPredPatches{j,i}; 

       
       if(sum(curPred(:))<=epsilon)
          numBad=numBad+1; 
       end
    end
    if(numBad>0)
       continue; 
    end

    indicesToKeep(newInd) = i;
    newInd = newInd + 1;

end
indicesToKeep = indicesToKeep(1:(newInd-1));

patchesT = targetSubPatches(indicesToKeep);
patchesPred = curPredPatches(:,indicesToKeep);

figure
subplot(2,2,1)
drawMapWithPatchesNoOutline(curImage,randPatchesCornerCoord(indicesToKeep),patchSize);

subplot(2,2,2)
drawMapWithPatchesNoOutline(precipMap,randPatchesCornerCoord(indicesToKeep),patchSize);

subplot(2,2,4)
drawMapWithPatchesNoOutline(ccsOverUS,randPatchesCornerCoord(indicesToKeep),patchSize);


