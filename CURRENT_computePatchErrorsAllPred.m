load('patchesSet11-23Data_3.mat');

numPred=4;
NN = length(targetPatches);
numPairs = numPred*(numPred-1)/2;

predAnum = [1 1 1 2 2 3];
predBnum = [2 3 4 3 4 4];

predErrorsMSE = zeros(numPairs,NN);
predErrorsEMD = zeros(numPairs,NN);
saveInterval = 20;
for patchI = 261:NN
    
    patchI
    
    for jj = 1:numPred
        
        jj

        aNum = predAnum(jj); bNum = predBnum(jj);
        curPredA = predPatches{aNum,patchI};
        curPredB = predPatches{bNum,patchI};
        predErrorsMSE(jj,patchI) = rmsePatches(curPredA,curPredB);
        
        try
            predErrorsEMD(jj,patchI) = getEMDwQP(curPredA,curPredB);
        catch
            predErrorsEMD(jj,patchI) = NaN;
        end
        
    end
    
    if(mod(patchI,saveInterval)==0)
        predErrorsMSEpartial = predErrorsMSE(:,1:patchI);
        predErrorsEMDpartial = predErrorsEMD(:,1:patchI);
        save('patchesSet11-23Data_3_partialAllPredResults_2ndPart.mat',...
            'predErrorsMSEpartial','predErrorsEMDpartial'); 
    end

end

save('patchesSet11-23Data_3_allPredResults_2ndPart.mat','predErrorsMSE','predErrorsEMD');

%BELOW HERE IS JUST REPEAT OF ABOVE
load('patchesSet11-23Data_1.mat');

numPred=4;
NN = length(targetPatches);
numPairs = numPred*(numPred-1)/2;

predAnum = [1 1 1 2 2 3];
predBnum = [2 3 4 3 4 4];

predErrorsMSE = zeros(numPairs,NN);
predErrorsEMD = zeros(numPairs,NN);
saveInterval = 20;
for patchI = 1:NN
    
    patchI
    
    for jj = 1:numPred
        
        jj

        aNum = predAnum(jj); bNum = predBnum(jj);
        curPredA = predPatches{aNum,patchI};
        curPredB = predPatches{bNum,patchI};
        predErrorsMSE(jj,patchI) = rmsePatches(curPredA,curPredB);
        
        try
            predErrorsEMD(jj,patchI) = getEMDwQP(curPredA,curPredB);
        catch
            predErrorsEMD(jj,patchI) = NaN;
        end
        
    end
    
    if(mod(patchI,saveInterval)==0)
        predErrorsMSEpartial = predErrorsMSE(:,1:patchI);
        predErrorsEMDpartial = predErrorsEMD(:,1:patchI);
        save('patchesSet11-23Data_1_partialAllPredResults.mat',...
            'predErrorsMSEpartial','predErrorsEMDpartial'); 
    end

end

save('patchesSet11-23Data_1_allPredResults.mat','predErrorsMSE','predErrorsEMD');


load('patchesSet11-23Data_2.mat');

numPred=4;
NN = length(targetPatches);
numPairs = numPred*(numPred-1)/2;

predAnum = [1 1 1 2 2 3];
predBnum = [2 3 4 3 4 4];

predErrorsMSE = zeros(numPairs,NN);
predErrorsEMD = zeros(numPairs,NN);
saveInterval = 20;
for patchI = 1:NN
    
    patchI
    
    for jj = 1:numPred
        
        jj

        aNum = predAnum(jj); bNum = predBnum(jj);
        curPredA = predPatches{aNum,patchI};
        curPredB = predPatches{bNum,patchI};
        predErrorsMSE(jj,patchI) = rmsePatches(curPredA,curPredB);
        
        try
            predErrorsEMD(jj,patchI) = getEMDwQP(curPredA,curPredB);
        catch
            predErrorsEMD(jj,patchI) = NaN;
        end
        
    end
    
    if(mod(patchI,saveInterval)==0)
        predErrorsMSEpartial = predErrorsMSE(:,1:patchI);
        predErrorsEMDpartial = predErrorsEMD(:,1:patchI);
        save('patchesSet11-23Data_2_partialAllPredResults.mat',...
            'predErrorsMSEpartial','predErrorsEMDpartial'); 
    end

end

save('patchesSet11-23Data_2_allPredResults.mat','predErrorsMSE','predErrorsEMD');