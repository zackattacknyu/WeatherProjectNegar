dataFiles = dir('data/compiledData11-23/data*');
%load(['data/compiledData11-23/' dataFiles(fileNum).name]);

numT = length(dataFiles);
numSampleTimes = 30;
minTimeDiff = 15;
epsilon = 1e-5;

timeStamps = getSampledPoints(numT,numSampleTimes,minTimeDiff);

numTimeStamps = length(timeStamps);

numPred = 4;
patchesT = cell(1,numTimeStamps);
patchesPred = cell(1,numTimeStamps);

for tt = 1:numTimeStamps
    
    tt
    
    fileNum = timeStamps(tt);
    
    load(['data/compiledData11-23/' dataFiles(fileNum).name]);

    curPredImages = cell(1,4);
    curPredImages{1} = pred253Orig(251:875,5626:7375);
    curPredImages{2} = pred253(1:625,:);
    curPredImages{3} = pred260(1:625,:);
    curPredImages{4} = pred280(1:625,:);
    curImage = target(1:625,:);
    
    minDist = 15;
    patchSize = 20;
    maxTries = 2000;
    maxNumPatches = 40;

    [ targetPatches, randPatchesCornerCoord, patchSum ] = ...
        getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries );

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
    
end

%%
%now find total number of patches found
numPatches = 0;
for i = 1:length(patchesT)
    numPatches = numPatches + length(patchesT{i});
end


numPred=4;
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
save('patchesSet11-23Data_1.mat','targetPatches','predPatches','patchesT','patchesPred');



