ccs_predictions_filterErrors


%{
This block of code finds the predictions that MSE and EMD will use for each
    target and singles out the examples where those predictions are
    different
%}

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

%{
As an attempt to quantify performance of emd vs mse,
the following sorting will be done:
1) H_1
2) H_2
3) H
4) other H

comparisonRaw is the variable that will be sorted by
%}
mseDiffs = mseOthers-mseBests;
emdDiffs = emdOthers-emdBests;
mseDiffs(isnan(emdDiffs))=NaN;

if(compareMethod==1)
    comparisonRaw = emdDiffs;
elseif(compareMethod==2)
    comparisonRaw = mseDiffs;
elseif(compareMethod==3)
    comparisonRaw = emdDiffs-mseDiffs;
else
    comparisonRaw = mseDiffs-emdDiffs;
end

[sortedCompare,displayInds] = sort(comparisonRaw,'descend');
searchRes = find(isnan(sortedCompare),1,'last');
if(isempty(searchRes))
   searchRes = 0; 
end
startInd = searchRes+1;
displayPatchInds = interestingPatchInds(displayInds(startInd:end)); %tells the patch numbers