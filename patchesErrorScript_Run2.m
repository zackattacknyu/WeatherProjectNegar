
load('matlabRun11-22_2.mat');

NN=98;
%NN = length(patchesT);

predErrorOldMSE = cell(1,NN);
predErrorNewMSE = cell(1,NN);
predErrorNew2MSE = cell(1,NN);
predErrorOldEMD = cell(1,NN);
predErrorNewEMD = cell(1,NN);
predErrorNew2EMD = cell(1,NN);

for j = 2:NN
    
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

        try
            oldPredErrorsEMD(i) = getEMDwQP(curTarget,curOldPred);
            newPredErrorsEMD(i) = getEMDwQP(curTarget,curNewPred);
            newPred2ErrorsEMD(i) = getEMDwQP(curTarget,curNewPred2);
        catch
            oldPredErrorsEMD(i) = NaN;
            newPredErrorsEMD(i) = NaN;
            newPred2ErrorsEMD(i) = NaN;
        end
    end

    predErrorOldMSE{j} = oldPredErrors;
    predErrorNewMSE{j} = newPredErrors;
    predErrorNew2MSE{j} = newPred2Errors;
    predErrorOldEMD{j} = oldPredErrorsEMD;
    predErrorNewEMD{j} = newPredErrorsEMD; 
    predErrorNew2EMD{j} = newPred2ErrorsEMD; 
end

save('patches11-21_results.mat');





