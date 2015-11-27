
numPatches = size(predErrorsEMDpartial,2);
badInds = find(isnan(predErrorsEMDpartial));
[badPreds,badPatches] = ind2sub(size(predErrorsEMDpartial),badInds);
goodPatches = setdiff(1:numPatches,badPatches');

predErrorsEMDgood = predErrorsEMDpartial(:,goodPatches);
predErrorsMSEgood = predErrorsMSEpartial(:,goodPatches);