close all

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

if(goodPatches)
    indsFromPrimary = find(allPredErrors<primaryErrorThreshold);
else
    indsFromPrimary = find(allPredErrors>primaryErrorThreshold);
end
    
allPredErrors = allPredErrors(indsFromPrimary);
allPredErrorsOther = allPredErrorsOther(indsFromPrimary);
linearPatchInds = linearPatchInds(indsFromPrimary);

if(goodPatches)
    [otherError,otherErrorInds] = sort(allPredErrorsOther,'descend');
    indsFromOther = find(otherError>otherErrorThreshold);
else
    [otherError,otherErrorInds] = sort(allPredErrorsOther);
    indsFromOther = find(otherError<otherErrorThreshold);
end

linearPatchInds = linearPatchInds(indsFromOther);
otherErrorsSorted = allPredErrorsOther(otherErrorInds(indsFromOther))'

%display patches in Order
[predNumber,patchIndex] = ind2sub(size(predErrorsEMD),linearPatchInds);
dispPatches = cell(2,length(linearPatchInds));
dispPatches(1,:) = targetPatches(patchIndex);
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearPatchInds);

numSlices = length(linearPatchInds);
slideStep = 1/(numSlices-1);

hh = figure;
panel1 = uipanel('Parent',1);
panel2 = uipanel('Parent',panel1);
set(panel1,'Position',[0 0 0.95 1]);
set(panel2,'Position',[0 0 1 1]);
set(gca,'Parent',panel2);
fun1 = @(src,event) slider_patchesRow(src,event,dispPatches);
s = uicontrol('Style','Slider','Parent',1,...
    'Units','normalized','Position',[0.95 0 0.05 1],...
    'Value',1,'Min',1,'Max',numSlices,...
    'SliderStep',[slideStep slideStep],...
    'Callback',fun1);
fun2 = @(src,event) scrollWheel_patchesRow(src,event,dispPatches,s);
set(hh,'WindowScrollWheelFcn',fun2);
displayPatchesRow(dispPatches,1);
