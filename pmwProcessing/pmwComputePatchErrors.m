patchFiles = dir('daily12*');

numPred=2;
saveInterval = 20;

for jj = 1:length(patchFiles)
    
    curFile = patchFiles(jj).name;
    curFileNm = curFile(1:end-4);
    
    load(curFile);
    
    NN = length(targetPatches);

    predErrorsMSE = zeros(numPred,NN);
    predErrorsEMD = zeros(numPred,NN);

    for patchI = 1:NN

        patchI

        curTarget = targetPatches{patchI};

        for predJ = 1:numPred

            curPred = predPatches{predJ,patchI};
            predErrorsMSE(predJ,patchI) = rmsePatches(curTarget,curPred);

            %predErrorsEMD(predJ,patchI) = getEMDwQP(curTarget,curPred);
            
            try
                predErrorsEMD(predJ,patchI) = getEMDwQP(curTarget,curPred);
            catch
                predErrorsEMD(predJ,patchI) = NaN;
            end
            
        end

        if(mod(patchI,saveInterval)==0)
            predErrorsMSEpartial = predErrorsMSE(:,1:patchI);
            predErrorsEMDpartial = predErrorsEMD(:,1:patchI);
            save(strcat(curFileNm,'_partialResults.mat'),...
                'predErrorsMSEpartial','predErrorsEMDpartial'); 
        end

    end

    save(strcat(curFileNm,'_results.mat'),'predErrorsMSE','predErrorsEMD');
end


