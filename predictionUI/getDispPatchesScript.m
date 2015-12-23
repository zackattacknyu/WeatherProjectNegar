load(loadFileName);
load(loadResultsFileName);

%ccs_predictions_filterErrors


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

linearEMDinds = sub2ind(size(predErrorsEMD),bestPredsEMD(interestingPatchInds),interestingPatchInds);
linearMSEinds = sub2ind(size(predErrorsEMD),bestPredsMSE(interestingPatchInds),interestingPatchInds);
dispPatches = cell(3,length(interestingPatchInds));
dispPatches(1,:) = targetPatches(interestingPatchInds);
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearEMDinds);
dispPatches(3,:) = dispPredPatches(linearMSEinds);

selections = zeros(1,size(dispPatches,2));