
numPatches = 0;
for i = 1:43
    numPatches = numPatches + length(patchesT{i});
end
%%
targetPatches = cell(1,numPatches);
predPatches = cell(1,numPatches);
predErrorMSE = cell(1,numPatches);
predErrorEMD = cell(1,numPatches);
predErrorOrderMSE = cell(1,numPatches);
predErrorOrderEMD = cell(1,numPatches);
maxMSEdiff = zeros(1,numPatches);
maxEMDdiff = zeros(1,numPatches);
iValue = zeros(1,numPatches); %timestep val
jValue = zeros(1,numPatches); %index in timestep
interestingPatchInds = zeros(1,numPatches);
patchInd = 1;
index = 1;
for i = 1:43
   
    oldPredErrors = predErrorOldMSE{i};
    newPredErrors = predErrorNewMSE{i};
    newPred2Errors = predErrorNew2MSE{i};
    oldPredErrorsEMD = predErrorOldEMD{i};
    newPredErrorsEMD = predErrorNewEMD{i}; 
    newPred2ErrorsEMD = predErrorNew2EMD{i};
    
    curPatchesT = patchesT{i};
    curPatchesOld = patchesOld{i};
    curPatchesNew = patchesNew{i};
    curPatchesNew2 = patchesNew2{i};
    
    for j = 1:length(oldPredErrors);
        curMSEerrors = [oldPredErrors(j) newPredErrors(j) newPred2Errors(j)];
        curEMDerrors = [oldPredErrorsEMD(j) newPredErrorsEMD(j) newPred2ErrorsEMD(j)];
        
        targetPatches{index} = curPatchesT{j};
        predPatches{index} = {curPatchesOld{j},curPatchesNew{j},curPatchesNew2{j}};
        
        predErrorMSE{index} = curMSEerrors;
        predErrorEMD{index} = curEMDerrors;
        
        [sortedMSE,mseOrder] = sort(curMSEerrors);
        [sortedEMD,emdOrder] = sort(curEMDerrors);
        
        if(mseOrder(1)~=emdOrder(1) && ~isnan(sortedEMD(1)))
            interestingPatchInds(patchInd) = index;
            patchInd = patchInd + 1;
        end
        
        maxMSEdiff(index) = sortedMSE(2)-sortedMSE(1);
        maxEMDdiff(index) = sortedEMD(2)-sortedEMD(1);
        iValue(index) = i;
        jValue(index) = j;
        index = index+1;
    end
    
end
%%
interestingPatchInds = interestingPatchInds(1:(patchInd-1));
interestingEMDdiffs = maxEMDdiff(interestingPatchInds);
interestingMSEdiffs = maxMSEdiff(interestingPatchInds);
[sortedEMDdiffs,orderedExamples] = sort(interestingEMDdiffs,'descend');

%%

patchIndsUse = interestingPatchInds(orderedExamples);

%%

%numDisplay = length(patchIndsUse);
numDisplay = 12;
numPerWindow = 4;
%displayInds = randperm(numCalc);
%displayInds = displayInds(randperm(length(displayInds)));

for j = 1:numDisplay
    
    if(mod(j-1,numPerWindow)==0)
       figure
       rowInd = 0;
    end
    rowInd = rowInd+1;
    
    curInd = patchIndsUse(j);
    curII = iValue(curInd);
    curJJ = jValue(curInd);
    
    targetP = targetPatches{curInd};
    maxPixel = max(targetP(:));
    
    curMSEerrors = predErrorMSE{curInd};
    curEMDerrors = predErrorEMD{curInd};
    [sortedMSE,mseOrder] = sort(curMSEerrors);
    [sortedEMD,emdOrder] = sort(curEMDerrors);
    
    curPredPatches = predPatches{curInd};
    
    usedInds = [emdOrder(1) mseOrder(1)];
    lastInd = setdiff(emdOrder,usedInds);
    
    leftP = curPredPatches{emdOrder(1)};
    middleP = curPredPatches{mseOrder(1)};
    rightP = curPredPatches{lastInd(1)};
    
    pInd = 4*(rowInd-1);
    subplot(numPerWindow,4,1+pInd);
    imagesc(targetP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,4,2+pInd);
    imagesc(leftP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,4,3+pInd);
    imagesc(middleP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,4,4+pInd);
    imagesc(rightP,[0 maxPixel]);
    colorbar;
end