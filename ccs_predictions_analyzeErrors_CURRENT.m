close all


if(useEMD)
    errorArray = predErrorsEMD(:);
    otherErrors = predErrorsMSE(:);
else
    errorArray = predErrorsMSE(:);
    otherErrors = predErrorsEMD(:);
end

[allPredErrors,linearPatchInds] = sort(errorArray);
goodInds = find(~isnan(allPredErrors));

allPredErrors = allPredErrors(goodInds);
linearPatchInds = linearPatchInds(goodInds);
allPredErrorsOther = otherErrors(linearPatchInds);

goodInds2 = find(~isnan(allPredErrorsOther));
allPredErrors = allPredErrors(goodInds2);
linearPatchInds = linearPatchInds(goodInds2);
allPredErrorsOther = allPredErrorsOther(goodInds2);

topRatio = 0.01;

numTopInds = floor(topRatio*length(allPredErrors));
indsFromPrimary = 1:numTopInds;
    
allPredErrors = allPredErrors(indsFromPrimary);
allPredErrorsOther = allPredErrorsOther(indsFromPrimary);
linearPatchInds = linearPatchInds(indsFromPrimary);

[otherError,otherErrorInds] = sort(allPredErrorsOther,'descend');

linearPatchInds = linearPatchInds(otherErrorInds);
otherErrorsSorted = allPredErrorsOther(otherErrorInds);

%display patches in Order
[predNumber,patchIndex] = ind2sub(size(predErrorsEMD),linearPatchInds);
dispPatches = cell(2,length(linearPatchInds));
dispPatches(1,:) = targetPatches(patchIndex);
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearPatchInds);

numRow=5;
figure
for i = 1:numRow
    
    curTarget = dispPatches{1,i};
    maxP = max(curTarget(:));
    
    for j = 1:2
       subplot(numRow,2,2*(i-1) + j)
       curPatch = dispPatches{j,i};
       imagesc(curPatch,[0 maxP]);
       colorbar;
    end
end

%CURRENT_displaySlider;