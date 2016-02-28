dataFiles = dir('zach_RR/q2hrus1210*');

numT = length(dataFiles);
numSampleTimes = 1200;
minTimeDiff = 20;
epsilon = 20;
precipThresh = 2000;

timeStamps = getSampledPoints(numT,numSampleTimes,minTimeDiff);
%timeStamps = 1:numT;

timeStamps2 = zeros(1,length(timeStamps));
curInd = 1;
for tt = 1:length(timeStamps)
    
    tt
    
    fileNum = timeStamps(tt);
    
    load(['zach_RR/' dataFiles(fileNum).name],'ir');

    curImage = ir(126:625,126:875);
    
    curImage(curImage<0)=0;
    
    curSum = sum(curImage(:));
    if(curSum>precipThresh)
        %curSum
        timeStamps2(curInd) = fileNum;
        curInd = curInd + 1;
    end
    
    
end

timeStamps2 = timeStamps2(1:(curInd-1));
timeStamps2 = sort(timeStamps2);
%%
numTimeStamps = length(timeStamps2);

%numPred = 4;
patchesT = cell(1,numTimeStamps);
patchesPred = cell(1,numTimeStamps);

for tt = 1:numTimeStamps
    
    %tt
    
    fileNum = timeStamps2(tt);
    
    fileNum
    
    load(['zach_RR/' dataFiles(fileNum).name],'ir');

    %{
    curPredImages = cell(1,4);
    curPredImages{1} = pred253Orig(251:875,5626:7375);
    curPredImages{2} = pred253(1:625,:);
    curPredImages{3} = pred260(1:625,:);
    curPredImages{4} = pred280(1:625,:);
    %}
    curImage = ir(126:625,126:875);
    
    minDist = 18;
    patchSize = 20;
    maxTries = 2000;
    maxNumPatches = 20;

    [ targetPatches, randPatchesCornerCoord, patchSum ] = ...
        getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries );

    %{
    curPredPatches = cell(numPred,length(targetPatches));
    for j = 1:numPred
        curPredPatches(j,:) = getPatchesFromCoords(curPredImages{j},randPatchesCornerCoord,patchSize);
    end
    %}
    indicesToKeep = zeros(1,length(targetPatches));
    newInd = 1;
    for i = 1:length(targetPatches)
       
        curT = targetPatches{i};
        if(sum(curT(:))<=epsilon)
            continue;
        end
        
        %{
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
        %}
        indicesToKeep(newInd) = i;
        newInd = newInd + 1;
        
    end
    indicesToKeep = indicesToKeep(1:(newInd-1));
    
    patchesT{tt} = targetPatches(indicesToKeep);
    %patchesPred{tt} = curPredPatches(:,indicesToKeep);
    
    %figure(1)
    %drawMapWithPatches(curImage,randPatchesCornerCoord(indicesToKeep),patchSize);
    %pause(5);
    
end

%%
%now find total number of patches found
numPatches = 0;
for i = 1:length(patchesT)
    numPatches = numPatches + length(patchesT{i});
end

%%
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


%save('patchesSet11-23Data_3.mat','targetPatches','predPatches','patchesT','patchesPred');



