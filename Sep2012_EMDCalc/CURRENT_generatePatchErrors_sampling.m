function [  ] = CURRENT_generatePatchErrors_sampling( inputDataFile,outputFile )
%CURRENT_GENERATEPATCHERRORS Summary of this function goes here
%   Detailed explanation goes here

inData = load(inputDataFile);
targetPatches = inData.targetPatches;
predPatches = inData.predPatches;

numSamplesPerIter = 100;

numPred=size(predPatches,1);
NN = length(targetPatches);
randomInds = randperm(NN);


totalWorkEMD = zeros(numPred,NN);

needMoreSamples = true;
curStartInd = 1;

while needMoreSamples
    
    curEndInd = curStartInd+numSamplesPerIter;
    if(curEndInd>NN)
       curEndInd=NN; 
    end
    curIndsToSample = randomInds(curStartInd:curEndInd);
    
    workEMD = cell(1,(numSamplesPerIter+1));
    curTargets = targetPatches(curIndsToSample);
    curPreds = predPatches(:,curIndsToSample);
    
    parfor curII = 1:(numSamplesPerIter+1)

        curTarget = curTargets{curII};
        currentWork= zeros(1,numPred);

        for predJ = 1:numPred

            curPred = curPreds{predJ,curII};

            sumVals = [sum(curTarget(:)) sum(curPred(:))];
            maxVals = [max(curTarget(:)) max(curPred(:))];

            if(min(sumVals) < 3 || min(maxVals) < 1)
                WORK = 0.1*sum((curTarget(:)-curPred(:)).^2);
                currentWork(predJ) = WORK;
                continue;
            end

            try
                [~,WORK,~] = getEMDwQP(curTarget,curPred);
                currentWork(predJ) = WORK;
            catch
                currentWork(predJ) = NaN;
            end

        end

        workEMD{curII} = currentWork;

    end

    
    for curII = 1:(numSamplesPerIter+1)
        patchI = curIndsToSample(curII);
        totalWorkEMD(:,patchI) = workEMD{curII};
    end

    curStartInd = curEndInd + 1;
    
    numSampled = curEndInd-1;
    indsForTest = randomInds(1:curEndInd);
    totalWorkFound = totalWorkEMD(:,indsForTest);
    meanW = mean(totalWorkFound,2);
    woReplaceMult = (NN-numSampled)/(numSampled*(NN-1));
    varW = var(totalWorkFound,[],2).*woReplaceMult;
    multiplier1 = 3.9; %for 99.99% confidence
    upperConfidence = meanW + multiplier1.*sqrt(varW);
    lowerConfidence = meanW - multiplier1.*sqrt(varW);
    
    %checks if confidence bounds do not intersect
    intervalVals = zeros(1,2*numPred);
    [~,sorting] = sort(lowerConfidence);
    intervalVals(1:2:end) = lowerConfidence(sorting);
    intervalVals(2:2:end) = upperConfidence(sorting);
    needMoreSamples = ~all(diff(intervalVals)>0);
    
    if(curEndInd>=NN)
       break; 
    end
end

save(outputFile,'totalWorkEMD','meanW','totalWorkFound','indsForTest');

end

