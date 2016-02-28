function [  ] = CURRENT_produceAllPredErrors( dataSetNumber )

numString = num2str(dataSetNumber);
loadFileName = strcat('patchesSet11-23Data_',numString,'.mat');
partialSaveFileName = strcat('patchesSet11-23Data_',numString,...
    '_partialAllPredResults.mat');
saveFileName = strcat('patchesSet11-23Data_',numString,...
    '_allPredResults_2ndPart.mat');

data = load(loadFileName);
predPatches = data.predPatches;

NN = size(predPatches,2);

predAnum = [1 1 1 2 2 3];
predBnum = [2 3 4 3 4 4];
numPairs = length(predAnum);

predErrorsMSE = zeros(numPairs,NN);
predErrorsEMD = zeros(numPairs,NN);
saveInterval = 20;
for patchI = 1:NN
    
    patchI
    
    for jj = 1:length(predAnum)
        
        jj

        aNum = predAnum(jj); 
        bNum = predBnum(jj);
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
        save(partialSaveFileName,'predErrorsMSEpartial','predErrorsEMDpartial'); 
    end

end

save(saveFileName,'predErrorsMSE','predErrorsEMD');



end

