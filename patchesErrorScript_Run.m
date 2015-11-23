dataFiles = dir('ccs_oldNew_compiledData_2/data*');

numDataFiles = length(dataFiles);
%numDataFiles=5;

patchesT = cell(1,numDataFiles);
patchesOld = cell(1,numDataFiles);
patchesNew = cell(1,numDataFiles);
patchesNew2 = cell(1,numDataFiles);

for fileNum = 1:numDataFiles
    
    fileNum
    
    load(['ccs_oldNew_compiledData_2/' dataFiles(fileNum).name]);

    rr1 = rr1(251:875,5626:7375);
    rr2 = rr2(1:625,:);
    ir = ir(1:625,:);
    obs = obs(1:625,:); 
    rr3 = rr3(251:875,5626:7375);

    curImage = obs;
    minDist = 15;
    patchSize = 20;
    maxTries = 2000;
    maxNumPatches = 30;

    [ targetPatches, randPatchesCornerCoord, patchSum ] = ...
        getSampledPatches( curImage, patchSize, minDist, maxNumPatches, maxTries );

    oldPredPatches = getPatchesFromCoords(rr1,randPatchesCornerCoord,patchSize);
    newPredPatches = getPatchesFromCoords(rr2,randPatchesCornerCoord,patchSize);
    newPred2Patches = getPatchesFromCoords(rr3,randPatchesCornerCoord,patchSize);
    
    targetPatches2 = cell(1,length(targetPatches));
    oldPredPatches2 = cell(1,length(oldPredPatches));
    newPredPatches2 = cell(1,length(newPredPatches));
    newPred2Patches2 = cell(1,length(newPred2Patches));
    newInd = 1;
    for i = 1:length(targetPatches)
        curTarget = targetPatches{i};
        curOldPred = oldPredPatches{i};
        curNewPred = newPredPatches{i};
        curNewPred2 = newPred2Patches{i};
        if(sum(curTarget(:))>0 && sum(curOldPred(:))>0 && ...
                sum(curNewPred(:))>0 && sum(curNewPred2(:))>0)
           targetPatches2{newInd} = targetPatches{i};
           oldPredPatches2{newInd} = oldPredPatches{i};
           newPredPatches2{newInd} = newPredPatches{i};
           newPred2Patches2{newInd} = newPred2Patches{i};
           newInd = newInd + 1;
        end
    end
    targetPatches = targetPatches2(1:(newInd-1));
    oldPredPatches = oldPredPatches2(1:(newInd-1));
    newPredPatches = newPredPatches2(1:(newInd-1));
    newPred2Patches = newPred2Patches2(1:(newInd-1));
    
    patchesT{fileNum} = targetPatches;
    patchesOld{fileNum} = oldPredPatches;
    patchesNew{fileNum} = newPredPatches;
    patchesNew2{fileNum} = newPredPatches;
    
end

currentFile = 'patchesSet11-21.mat';
save(currentFile,'patchesT','patchesOld','patchesNew','patchesNew2');

clear all;
currentFile = 'patchesSet11-21.mat';
load(currentFile);

NN = length(patchesT);

predErrorOldMSE = cell(1,NN);
predErrorNewMSE = cell(1,NN);
predErrorNew2MSE = cell(1,NN);
predErrorOldEMD = cell(1,NN);
predErrorNewEMD = cell(1,NN);
predErrorNew2EMD = cell(1,NN);

for j = 1:NN
    
    targetPatches = patchesT{j};
    oldPredPatches = patchesOld{j};
    newPredPatches = patchesNew{j};
    newPred2Patches = patchesNew2{j};
    
    %indices = randperm(length(targetPatches));
    indices = 1:length(targetPatches);
    
    %numCalc=3;
    numCalc = length(targetPatches);
    
    oldPredErrors = zeros(1,numCalc);
    newPredErrors = zeros(1,numCalc);
    newPred2Errors = zeros(1,numCalc);
    oldPredErrorsEMD = zeros(1,numCalc);
    newPredErrorsEMD = zeros(1,numCalc);
    newPred2ErrorsEMD = zeros(1,numCalc);
    
    for i = 1:numCalc

        patchNum = indices(i);

        curTarget = targetPatches{patchNum};
        curOldPred = oldPredPatches{patchNum};
        curNewPred = newPredPatches{patchNum};
        curNewPred2 = newPred2Patches{patchNum};
        oldPredErrors(i) = rmsePatches(curTarget,curOldPred);
        newPredErrors(i) = rmsePatches(curTarget,curNewPred);
        newPred2Errors(i) = rmsePatches(curTarget,curNewPred2);

        i

        oldPredErrorsEMD(i) = getEMDwQP(curTarget,curOldPred);
        newPredErrorsEMD(i) = getEMDwQP(curTarget,curNewPred);
        newPred2ErrorsEMD(i) = getEMDwQP(curTarget,curNewPred2);
    end

    predErrorOldMSE{fileNum} = oldPredErrors;
    predErrorNewMSE{fileNum} = newPredErrors;
    predErrorNew2MSE{fileNum} = newPred2Errors;
    predErrorOldEMD{fileNum} = oldPredErrorsEMD;
    predErrorNewEMD{fileNum} = newPredErrorsEMD; 
    predErrorNew2EMD{fileNum} = newPred2ErrorsEMD; 
end

save('patches11-21_results.mat');





