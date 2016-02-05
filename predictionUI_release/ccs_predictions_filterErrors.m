interestingThresh = 5; %max amount of precipitation required in patch to be considered
maxPixelValues = zeros(size(predPatches,1)+1,length(targetPatches));
for i = 1:length(targetPatches)
    
    curPatch = targetPatches{i};
    maxPixelValues(1,i) = max(curPatch(:));
    
    for j = 1:size(predPatches,1)
        otherPatch = predPatches{j,i};
        maxPixelValues(j+1,i) = max(otherPatch(:));
    end
end

minRow = min(maxPixelValues);
interestingInds = find(minRow>interestingThresh);

targetPatches = targetPatches(interestingInds);
predPatches = predPatches(:,interestingInds);
predErrorsEMD = predErrorsEMD(:,interestingInds);
predErrorsMSE = predErrorsMSE(:,interestingInds);