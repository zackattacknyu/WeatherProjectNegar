%dataFiles = dir('daily/data_daily1207*');
%dataFiles = dir('data_monthly*');
dataFiles = dir('data/data_hrly1201*');

load('mask_US.mat');

numT = length(dataFiles);
numSampleTimes = 100;
minTimeDiff = 5;
epsilon = 1e-5;

timeStamps = getSampledPoints(numT,numSampleTimes,minTimeDiff);
numTimeStamps = length(timeStamps);
%numTimeStamps = length(dataFiles);

numPred = 2;
patchesT = cell(1,numTimeStamps);
patchesPred = cell(1,numTimeStamps);

for tt = 1:numTimeStamps
    
    tt
    
    fileNum = timeStamps(tt);
    %fileNum=tt;
    
    %load(['daily/' dataFiles(fileNum).name]);
    load(['data/' dataFiles(fileNum).name]);
    %load(dataFiles(fileNum).name);

    mask_US(isnan(mask_US))=0;
    ccs(isnan(ccs))=0;
    ccsadj(isnan(ccsadj))=0;
    pmw(isnan(pmw))=0;
    
    curPredImages = cell(1,2);
    
    curPredImages{1} = ccs(45:140,941:1172).*mask_US;
    curPredImages{2} = ccsadj(45:140,941:1172).*mask_US;
    curImage = pmw(45:140,941:1172).*mask_US;
    
    %curPredImages{1} = ccs_s(45:140,941:1172).*mask_US;
    %curPredImages{2} = ccsadj_s(45:140,941:1172).*mask_US;
    %curImage = pmw_s(45:140,941:1172).*mask_US;
    
    minDist = 10;
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


save('hrly1201patches_1.mat','targetPatches','predPatches','patchesT','patchesPred');



