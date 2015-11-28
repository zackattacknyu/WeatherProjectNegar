load('patchesSet11-23Data_2.mat');

numPred=4;
NN = length(targetPatches);

predErrorsMSE = zeros(numPred,NN);
predErrorsEMD = zeros(numPred,NN);
saveInterval = 20;
for patchI = 1:NN
    
    patchI
    
    curTarget = targetPatches{patchI};
    
    for predJ = 1:numPred

        curPred = predPatches{predJ,patchI};
        predErrorsMSE(predJ,patchI) = rmsePatches(curTarget,curPred);
        
        try
            predErrorsEMD(predJ,patchI) = getEMDwQP(curTarget,curPred);
        catch
            predErrorsEMD(predJ,patchI) = NaN;
        end
        
    end
    
    if(mod(patchI,saveInterval)==0)
        predErrorsMSEpartial = predErrorsMSE(:,1:patchI);
        predErrorsEMDpartial = predErrorsEMD(:,1:patchI);
        save('patchesSet11-23Data_2_partialResults.mat',...
            'predErrorsMSEpartial','predErrorsEMDpartial'); 
    end

end

save('patchesSet11-23Data_2_results.mat','predErrorsMSE','predErrorsEMD');