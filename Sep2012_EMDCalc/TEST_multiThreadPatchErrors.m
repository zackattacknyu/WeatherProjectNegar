inputDataFile = 'patchesOct2012Data_time4.mat';
outputFile = 'patchesOct2012Data_results_time4_multi.mat';

inData = load(inputDataFile);
targetPatches = inData.targetPatches;
predPatches = inData.predPatches;

numPred=2;
NN = length(targetPatches);

predErrorsEMD = zeros(numPred,NN);

%{
To approx EMD for whole set, we will add all numerators and all
    denominators and compute fraction to get approx EMD
%}
totalWorkEMD = zeros(numPred,NN); %numerator of last step in EMD
totalFlowEMD = zeros(numPred,NN); %denominator of last step in EMD

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

save(outputFile,'predEMD','workEMD','flowEMD');


