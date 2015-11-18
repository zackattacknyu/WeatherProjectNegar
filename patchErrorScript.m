fileNum=23;
%fileNum=50;

dataFiles = dir('data/compiledData/data*');
load(['data/compiledData/' dataFiles(fileNum).name]);
    
rr1 = rr1(251:875,5626:7375);
rr2 = rr2(1:625,:);
ir = ir(1:625,:);
obs = obs(1:625,:); 

curImage = obs;
minDist = 15;
patchSize = 20;
maxTries = 2000;
maxNumPatches = 200;

[ targetPatches, randPatchesCornerCoord, patchSum ] = ...
    getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries );

oldPredPatches = getPatchesFromCoords(rr1,randPatchesCornerCoord,patchSize);
newPredPatches = getPatchesFromCoords(rr2,randPatchesCornerCoord,patchSize);

targetPatches2 = cell(1,length(targetPatches));
oldPredPatches2 = cell(1,length(oldPredPatches));
newPredPatches2 = cell(1,length(newPredPatches));
newInd = 1;
for i = 1:length(targetPatches)
    curTarget = targetPatches{i};
    curOldPred = oldPredPatches{i};
    curNewPred = newPredPatches{i};
    if(sum(curTarget(:))>0 && sum(curOldPred(:))>0 && sum(curNewPred(:))>0)
       targetPatches2{newInd} = targetPatches{i};
       oldPredPatches2{newInd} = oldPredPatches{i};
       newPredPatches2{newInd} = newPredPatches{i};
       newInd = newInd + 1;
    end
end
targetPatches = targetPatches2(1:(newInd-1));
oldPredPatches = oldPredPatches2(1:(newInd-1));
newPredPatches = newPredPatches2(1:(newInd-1));


figure
drawMapWithPatches(curImage,randPatchesCornerCoord,patchSize);
figure
drawMapWithPatches(rr1,randPatchesCornerCoord,patchSize);
figure
drawMapWithPatches(rr2,randPatchesCornerCoord,patchSize);
%%
%indices = randperm(length(targetPatches));
indices = 1:length(targetPatches);

%numCalc = 5;
numCalc = length(targetPatches);
oldPredErrors = zeros(1,numCalc);
newPredErrors = zeros(1,numCalc);
oldPredErrorsEMD = zeros(1,numCalc);
newPredErrorsEMD = zeros(1,numCalc);
for i = 1:numCalc
    
    patchNum = indices(i);
    
    curTarget = targetPatches{patchNum};
    curOldPred = oldPredPatches{patchNum};
    curNewPred = newPredPatches{patchNum};
    oldPredErrors(i) = rmsePatches(curTarget,curOldPred);
    newPredErrors(i) = rmsePatches(curTarget,curNewPred);
   
    i
   
    oldPredErrorsEMD(i) = getEMDwQP(curTarget,curOldPred);
    newPredErrorsEMD(i) = getEMDwQP(curTarget,curNewPred);
end

%meanOldError = mean(oldPredErrors)
%meanNewError = mean(newPredErrors)
%meanOldErrorEMD = mean(oldPredErrorsEMD)
%meanNewErrorEMD = mean(newPredErrorsEMD)

%%

displayInds = zeros(1,numCalc);
emdBetter = false(1,numCalc);
emdGap = zeros(1,numCalc);
mseGap = zeros(1,numCalc);
curInd = 1;
for i = 1:numCalc
    
    oldBetter = 0;
    if(oldPredErrors(i)<newPredErrors(i))
        oldBetter=1;
    end
    
    oldBetterEMD = 0;
    if(oldPredErrorsEMD(i)<newPredErrorsEMD(i))
        oldBetterEMD=1;
    end
    
    %one of them true and the other false
    %   meaning the MSE and EMD predict different patches
    if(oldBetter+oldBetterEMD==1) 
        displayInds(curInd)=i;
        if(oldBetterEMD)
           emdBetter(curInd)=true; 
        end
        
        emdGap(curInd) = oldPredErrors(i)-newPredErrors(i);
        mseGap(curInd) = oldPredErrorsEMD(i)-newPredErrorsEMD(i);
        
        curInd = curInd+1;
    end
end
displayInds = displayInds(1:(curInd-1));
emdBetter = emdBetter(1:(curInd-1));
%%
numDisplay = length(displayInds);
numPerWindow = 8;
%displayInds = randperm(numCalc);
%displayInds = displayInds(randperm(length(displayInds)));

for j = 1:numDisplay
    
    if(mod(j-1,numPerWindow)==0)
       figure
       rowInd = 0;
    end
    rowInd = rowInd+1;
    
    i = displayInds(j);
    
    targetP = targetPatches{i};
    maxPixel = max(targetP(:));
    
    
    leftP = newPredPatches{i};
    rightP = oldPredPatches{i};
    if(emdBetter(j))
        leftP = oldPredPatches{i};
        rightP = newPredPatches{i};
    end
    
    
    pInd = 3*(rowInd-1);
    subplot(numPerWindow,3,1+pInd);
    imagesc(targetP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,3,2+pInd);
    imagesc(leftP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,3,3+pInd);
    imagesc(rightP,[0 maxPixel]);
    colorbar;
end








