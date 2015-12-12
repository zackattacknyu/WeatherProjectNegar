function [ dispPatches ] = getDisplayPatches_12_14Meeting(targetPatches,predPatches,errorMatrix,otherMatrix,topRatio)
%GETDISPLAYPATCHESCELL Summary of this function goes here
%   Detailed explanation goes here

errorArray = errorMatrix(:);
otherErrors = otherMatrix(:);

[allPredErrors,linearPatchInds] = sort(errorArray);
goodInds = find(~isnan(allPredErrors));

allPredErrors = allPredErrors(goodInds);
linearPatchInds = linearPatchInds(goodInds);
allPredErrorsOther = otherErrors(linearPatchInds);

goodInds2 = find(~isnan(allPredErrorsOther));
allPredErrors = allPredErrors(goodInds2);
linearPatchInds = linearPatchInds(goodInds2);
allPredErrorsOther = allPredErrorsOther(goodInds2);



numTopInds = floor(topRatio*length(allPredErrors));
indsFromPrimary = 1:numTopInds;
    
allPredErrors = allPredErrors(indsFromPrimary);
allPredErrorsOther = allPredErrorsOther(indsFromPrimary);
linearPatchInds = linearPatchInds(indsFromPrimary);

[otherError,otherErrorInds] = sort(allPredErrorsOther,'descend');

linearPatchInds = linearPatchInds(otherErrorInds);
otherErrorsSorted = allPredErrorsOther(otherErrorInds);

%display patches in Order
[predNumber,patchIndex] = ind2sub(size(errorMatrix),linearPatchInds);
dispPatches = cell(2,length(linearPatchInds));
dispPatches(1,:) = targetPatches(patchIndex);
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearPatchInds);


end

