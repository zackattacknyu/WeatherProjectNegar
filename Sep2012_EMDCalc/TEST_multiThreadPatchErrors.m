inputDataFile = 'patchesOct2012Data_time5.mat';
outputFile = 'patchesOct2012Data_results_time5_multi.mat';

inData = load(inputDataFile);
targetPatches = inData.targetPatches;
predPatches = inData.predPatches;
%%
numPred=2;
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
    
    
    curTarget = targetPatches{patchI};
    
    predErrorsEMD(:,patchI) = predEMD{patchI};
    totalWorkEMD(:,patchI) = workEMD{patchI};
    totalFlowEMD(:,patchI) = flowEMD{patchI};

end

save(outputFile,'predErrorsEMD','totalWorkEMD','totalFlowEMD');

%%

outputFile = 'patchesOct2012Data_results_time5_multi.mat';
outputFile2 = 'patchesOct2012Data_results_time5.mat';

data1 = load(outputFile);
data2 = load(outputFile2);

diffPred = abs(data1.predErrorsEMD-data2.predErrorsEMD);
diffWork = abs(data1.totalWorkEMD-data2.totalWorkEMD);
diffFlow = abs(data1.totalFlowEMD-data2.totalFlowEMD);

sumPred = sum(sum(diffPred))
sumWork = sum(sum(diffWork))
sumFlow = sum(sum(diffFlow))
%%





