load('patchesSep2011Data.mat');

numPred=2;
NN = length(targetPatches);

predErrorsEMD = zeros(numPred,NN);
%%
%{
To approx EMD for whole set, we will add all numerators and all
    denominators and compute fraction to get approx EMD
%}
totalWorkEMD = zeros(numPred,NN); %numerator of last step in EMD
totalFlowEMD = zeros(numPred,NN); %denominator of last step in EMD
%%
saveInterval = 10;
for patchI = 561:NN
    
    patchI
    
    curTarget = targetPatches{patchI};
    
    for predJ = 1:numPred

        curPred = predPatches{predJ,patchI};
        
        try
            [emdVal,WORK,FLOW] = getEMDwQP(curTarget,curPred);
            predErrorsEMD(predJ,patchI) = emdVal;
            totalWorkEMD(predJ,patchI) = WORK;
            totalFlowEMD(predJ,patchI) = FLOW;
        catch
            predErrorsEMD(predJ,patchI) = NaN;
            totalWorkEMD(predJ,patchI) = NaN;
            totalFlowEMD(predJ,patchI) = NaN;
        end
        
    end
    
    if(mod(patchI,saveInterval)==0)
        predErrorsEMDpartial = predErrorsEMD(:,1:patchI);
        totalWorkEMDpartial = totalWorkEMD(:,1:patchI);
        totalFlowEMDpartial = totalFlowEMD(:,1:patchI);
        save('patchesSep2011Data_partialResults.mat',...
            'predErrorsEMD',...
            'predErrorsEMDpartial',...
            'totalWorkEMDpartial',...
            'totalFlowEMDpartial',...
            'totalWorkEMD','totalFlowEMD'); 
    end

end

save('patchesSep2011Data_results.mat','predErrorsEMD','totalFlowEMD','totalWorkEMD');