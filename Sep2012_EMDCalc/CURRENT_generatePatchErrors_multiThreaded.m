function [  ] = CURRENT_generatePatchErrors_multiThreaded( inputDataFile,outputFile )
%CURRENT_GENERATEPATCHERRORS Summary of this function goes here
%   Detailed explanation goes here

inData = load(inputDataFile);
targetPatches = inData.targetPatches;
predPatches = inData.predPatches;

numPred=size(predPatches,1);
NN = length(targetPatches);


predEMD = cell(1,NN);
workEMD = cell(1,NN);
flowEMD = cell(1,NN);
parfor patchI = 1:NN
    
    patchI
    
    curTarget = targetPatches{patchI};
    predErrorsEMD = zeros(1,numPred);
    totalWorkEMD= zeros(1,numPred);
    totalFlowEMD = zeros(1,numPred);
    
    for predJ = 1:numPred

        curPred = predPatches{predJ,patchI};
        
        sumVals = [sum(curTarget(:)) sum(curPred(:))];
        maxVals = [max(curTarget(:)) max(curPred(:))];
        
        if(min(sumVals) < 3 || min(maxVals) < 1)
            WORK = 0.1*sum((curTarget(:)-curPred(:)).^2);
            predErrorsEMD(predJ) = WORK;
            totalWorkEMD(predJ) = WORK;
            totalFlowEMD(predJ) = 0;
            continue;
        end
        
        try
            [emdVal,WORK,FLOW] = getEMDwQP(curTarget,curPred);
            predErrorsEMD(predJ) = emdVal;
            totalWorkEMD(predJ) = WORK;
            totalFlowEMD(predJ) = FLOW;
        catch
            predErrorsEMD(predJ) = NaN;
            totalWorkEMD(predJ) = NaN;
            totalFlowEMD(predJ) = NaN;
        end
        
    end
    
    predEMD{patchI} = predErrorsEMD;
    workEMD{patchI} = totalWorkEMD;
    flowEMD{patchI} = totalFlowEMD;
    
    

end

predErrorsEMD = zeros(numPred,NN);

%{
To approx EMD for whole set, we will add all numerators and all
    denominators and compute fraction to get approx EMD
%}
totalWorkEMD = zeros(numPred,NN); %numerator of last step in EMD
totalFlowEMD = zeros(numPred,NN); %denominator of last step in EMD

for patchI = 1:NN
    
    

    
    predErrorsEMD(:,patchI) = predEMD{patchI};
    totalWorkEMD(:,patchI) = workEMD{patchI};
    totalFlowEMD(:,patchI) = flowEMD{patchI};

end

save(outputFile,'predErrorsEMD','totalFlowEMD','totalWorkEMD');

end

