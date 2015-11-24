
%multiple files

dataFiles = dir('compiledData11-23/data*');
epsilon = 1e-5;

numDataFiles = length(dataFiles);
%numDataFiles=10;

numPred = 4;
patchesT = cell(1,numDataFiles);
patchesPred = cell(1,numDataFiles);

for fileNum = 1:numDataFiles
    
    fileNum
    
    load(['compiledData11-23/' dataFiles(fileNum).name]);

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
    
    patchesT{fileNum} = targetPatches(indicesToKeep);
    patchesPred{fileNum} = curPredPatches(:,indicesToKeep);
    
end

currentFile = 'patchesSet11-23Data_1.mat';
save(currentFile,'patchesT','patchesPred');





