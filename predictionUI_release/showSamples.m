%clear all;
load('patchesSetData.mat');

numPatches = size(targetPatches,2);

numDisplay=100;
%numDisplay = length(patchIndsUse);
patchIndsUse = randperm(numPatches);
patchIndsUse = patchIndsUse(1:numDisplay);

numPred=4;
dispPatches = cell(numPred+1,numDisplay);

for j = 1:numDisplay
    
    curInd = patchIndsUse(j);
    
    targetP = targetPatches{curInd};
    maxPixel = max(targetP(:));
    
    dispPatches{1,j} = targetP;
    
    for i = 1:numPred
        dispPatches{i+1,j} = predPatches{i,curInd};
    end
    
    
end


displayPatchesRow(dispPatches,1);
%%

%RUN THIS AFTER POSTPROCESSSELECTIONS.M

%display patches in Order
linearEMDinds = sub2ind(size(predErrorsEMD),bestPredsEMD(displayPatchInds),displayPatchInds);
linearMSEinds = sub2ind(size(predErrorsEMD),bestPredsMSE(displayPatchInds),displayPatchInds);
dispPatches = cell(3,length(displayPatchInds));
dispPatches(1,:) = targetPatches(displayPatchInds);
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearEMDinds);
dispPatches(3,:) = dispPredPatches(linearMSEinds);

%11 is a good example of low end
curInd = 552;

displayPatchesRow(dispPatches,curInd);
