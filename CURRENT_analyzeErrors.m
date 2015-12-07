load('patchesSet11-23Data_3_results.mat');
load('patchesSet11-23Data_3.mat');
%%

interestingThresh = 10; %max amount of precipitation required in patch to be considered
maxPixelValues = zeros(1,length(targetPatches));
for i = 1:length(targetPatches)
    curPatch = targetPatches{i};
    maxPixelValues(i) = max(curPatch(:));
end
interestingInds = find(maxPixelValues>interestingThresh);

targetPatches = targetPatches(interestingInds);
predPatches = predPatches(:,interestingInds);
predErrorsEMD = predErrorsEMD(:,interestingInds);
predErrorsMSE = predErrorsMSE(:,interestingInds);
%%
%MSE parameters for good ones
%primaryErrorThreshold = 2; %if error is less than this, then error function thinks it nailed it
%otherErrorThreshold = 1; %error for other one must be more than this to be considered
%useEMD=false; %order by EMD if true. MSE if false
%goodPatches = true;

%EMD parameters for good ones
%primaryErrorThreshold = 3; %if error is less than this, then error function thinks it nailed it
%otherErrorThreshold = 10; %error for other one must be more than this to be considered
%useEMD=true; %order by EMD if true. MSE if false
%goodPatches = true;

%MSE parameters for bad ones
%primaryErrorThreshold = 20; %if error is greater than this, error function says prediction is terrible
%otherErrorThreshold = 8; %error for other one must be less than this to be considered
%useEMD=false; %order by EMD if true. MSE if false
%goodPatches=false;

%EMD parameters for bad ones
primaryErrorThreshold = 60; %if error is greater than this, error function says prediction is terrible
otherErrorThreshold = 10; %error for other one must be less than this to be considered
useEMD=true; %order by EMD if true. MSE if false
goodPatches=false;

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


