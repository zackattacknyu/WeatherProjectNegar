load('patchesSet11-23Data_3_results.mat');
load('patchesSet11-23Data_3.mat');

%%
%{
This section of code allows scrolling through target and predictions
    by EMD and MSE values. 
This showcases that the best and worst by EMD make more sense than
    the best and worst by MSE
%}

useEMD=true; %order by EMD if true. MSE if false
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

%display patches in Order
[predNumber,patchIndex] = ind2sub(size(predErrorsEMD),linearPatchInds);
dispPatches = cell(2,length(linearPatchInds));
dispPatches(1,:) = targetPatches(patchIndex);
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearPatchInds);

numSlices = length(linearPatchInds);
slideStep = 1/(numSlices-1);

hh = figure(1);
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

%%

%{
This block of code finds the predictions that MSE and EMD will use for each
    target and singles out the examples where those predictions are
    different

Let A be best by EMD, B be best patch by MSE
The EMD and MSE values for A and B are compared and the comparison
    is used for sorting
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
I will compute the following comparison

IMPORTANT. THERE ARE 4 I WANT TO CONSIDER:
1) High EMD difference, low MSE difference
2) High MSE difference, low EMD difference
3) Both are low
4) Both are high

comparisonRaw is the variable that will be sorted by
%}
mseDiffs = mseOthers-mseBests;
emdDiffs = emdOthers-emdBests;
%comparisonRaw = emdDiffs - mseDiffs;
%comparisonRaw = mseDiffs - emdDiffs;
comparisonRaw = mseDiffs;

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

numSlices = length(displayPatchInds);
slideStep = 1/(numSlices-1);

hh = figure(1);
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

%%

%figure out how many frequently each prediction was chosen
tabulate(bestPredsEMD)
tabulate(bestPredsMSE)

%%


%{
This block of code will compare the original CSS
    to the new 253 CSS prediction,
so block 1 and 2
%}

origCSSmse = predErrorsMSE(1,:);
newCSSmse = predErrorsMSE(2,:);
origCSSemd = predErrorsEMD(1,:);
newCSSemd = predErrorsEMD(2,:);

mseDiffs = origCSSmse-newCSSmse;
emdDiffs = origCSSemd-newCSSemd;

mseAbsDiff = abs(mseDiffs);
mseSignDiff = sign(mseDiffs);
emdAbsDiff = abs(emdDiffs);
emdSignDiff = sign(emdDiffs);

[sortedMSE,mseOrder] = sort(mseDiffs);
[sortedEMD,emdOrder] = sort(emdDiffs);
[sortedMSEabs,mseOrderAbs] = sort(mseAbsDiff);
[sortedEMDabs,emdOrderAbs] = sort(emdAbsDiff);

endInd = find(isnan(sortedEMD),1)-1;
emdOrder = emdOrder(1:endInd);
mseOrder = mseOrder(1:endInd);
emdOrderAbs = emdOrderAbs(1:endInd);
mseOrderAbs = mseOrderAbs(1:endInd);

%TO CHANGE FOR EMD VERSUS MSE
displayPatchInds = emdOrderAbs;

dispPatches = cell(3,length(displayPatchInds));
dispPatches(1,:) = targetPatches(displayPatchInds);
dispPatches(2,:) = predPatches(1,displayPatchInds);
dispPatches(3,:) = predPatches(2,displayPatchInds);

numSlices = length(displayPatchInds);
slideStep = 1/(numSlices-1);

hh = figure(1);
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
