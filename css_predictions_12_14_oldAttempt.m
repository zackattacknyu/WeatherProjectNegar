%{
This block of code finds the predictions that MSE and EMD will use for each
    target and singles out the examples where those predictions are
    different

Let A be best by EMD, B be best patch by MSE
The EMD and MSE values for A and B are compared and the comparison
    is used for sorting
%}

useEMD=false; %order by EMD if true. MSE if false
if(useEMD)
    [allPredErrors,patchIndices] = sort(predErrorsEMD(:));
    endPatchInd = find(isnan(allPredErrors),1)-1; %linear index of last valid patch
    linearPatchInds = patchIndices(1:endPatchInd);
    allPredErrorsOther = predErrorsMSE(:);
    allPredErrorsOther = allPredErrorsOther(linearPatchInds);
else
    [allPredErrors,linearPatchInds] = sort(predErrorsMSE(:));
    allPredErrorsOther = predErrorsEMD(:);
    allPredErrorsOther = allPredErrorsOther(linearPatchInds);
end

[bestMSEvals,bestPredsMSE] = min(predErrorsMSE);
[bestEMDvals,bestPredsEMD] = min(predErrorsEMD);

bestLinIndMSE = sub2ind(size(predErrorsMSE),bestPredsMSE,1:size(predErrorsMSE,2));
bestLinIndEMD = sub2ind(size(predErrorsEMD),bestPredsEMD,1:size(predErrorsEMD,2));

otherMSEvals = predErrorsMSE(:);
otherMSEvals = otherMSEvals(bestLinIndEMD)';
otherEMDvals = predErrorsEMD(:);
otherEMDvals = otherEMDvals(bestLinIndMSE)';

interestingPatchInds = find(bestPredsMSE~=bestPredsEMD);

%this gets MSE/EMD for the best patch by MSE/EMD
%   and then obtains the EMD/MSE value for the other patch
mseBests = bestMSEvals(interestingPatchInds);
mseOthers = otherMSEvals(interestingPatchInds);
emdBests = bestEMDvals(interestingPatchInds);
emdOthers = otherEMDvals(interestingPatchInds);

topRatio = 0.05;
numTopInds = floor(topRatio*length(mseBests));
indsFromPrimary = 1:numTopInds;
if(useEMD)    
    [topEMDvals,sortedIndsEMD] = sort(emdBests);
    topEMDvals = topEMDvals(indsFromPrimary);
    sortedIndsEMD = sortedIndsEMD(indsFromPrimary);
    mseWithTopEMD = mseOthers(sortedIndsEMD);
    interestingPatchInds = interestingPatchInds(sortedIndsEMD);
    comparisonRaw = mseWithTopEMD;
else
    [topMSEvals,sortedIndsMSE] = sort(mseBests);
    topMSEvals = topMSEvals(indsFromPrimary);
    sortedIndsMSE = sortedIndsMSE(indsFromPrimary);
    emdWithTopMSE = emdOthers(sortedIndsMSE);
    interestingPatchInds = interestingPatchInds(sortedIndsMSE);
    comparisonRaw = emdWithTopMSE;
end


[sortedCompare,displayInds] = sort(comparisonRaw,'descend');
searchRes = find(isnan(sortedCompare),1,'last');
if(isempty(searchRes))
   searchRes = 0; 
end
startInd = searchRes+1;
displayPatchInds = interestingPatchInds(displayInds(startInd:end)); %tells the patch numbers

%display patches in Order
linearEMDinds = sub2ind(size(predErrorsEMD),bestPredsEMD(displayPatchInds),displayPatchInds);
linearMSEinds = sub2ind(size(predErrorsEMD),bestPredsMSE(displayPatchInds),displayPatchInds);
dispPatches = cell(3,length(displayPatchInds));
dispPatches(1,:) = targetPatches(displayPatchInds);
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearEMDinds);
dispPatches(3,:) = dispPredPatches(linearMSEinds);

CURRENT_displaySlider