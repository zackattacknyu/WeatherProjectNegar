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
maxTries = 1000;
maxNumPatches = 100;

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
subplot(1,2,1);
drawMapWithPatches(rr1,randPatchesCornerCoord,patchSize);
subplot(1,2,2);
drawMapWithPatches(rr2,randPatchesCornerCoord,patchSize);
%%
%indices = randperm(length(targetPatches));
indices = 1:length(targetPatches);

numCalc = 5;
%numCalc = length(targetPatches);
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

figure
for i = 1:numCalc
    
    oldBetter = false;
    if(oldPredErrors(i)<newPredErrors(i))
        oldBetter=true;
    end
    
    oldBetterEMD = false;
    if(oldPredErrorsEMD(i)<newPredErrorsEMD(i))
        oldBetterEMD=true;
    end
    
    pInd = 3*(i-1);
    subplot(numCalc,3,1+pInd);
    imagesc(targetPatches{i});
    subplot(numCalc,3,2+pInd);
    imagesc(oldPredPatches{i});
    if(oldBetter)
       text(10,10,'**'); 
    end
    if(oldBetterEMD)
       text(10,12,'##'); 
    end
    subplot(numCalc,3,3+pInd);
    imagesc(newPredPatches{i});
    if(~oldBetter)
       text(10,10,'**'); 
    end
    if(~oldBetterEMD)
       text(10,12,'##'); 
    end
end








