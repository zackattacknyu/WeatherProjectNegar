dataSetNumber=1;

numString = num2str(dataSetNumber);
loadFileName = strcat('patchesSet11-23Data_',numString,'.mat');
loadResultsFileName = strcat('patchesSet11-23Data_',numString,'_results.mat');

load(loadFileName);
load(loadResultsFileName);

ccs_predictions_filterErrors


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
the following sorting will be done:
1) H_1
2) H_2
3) H
4) other H

comparisonRaw is the variable that will be sorted by
%}
mseDiffs = mseOthers-mseBests;
emdDiffs = emdOthers-emdBests;

%comparisonRaw = emdDiffs;
%comparisonRaw = mseDiffs;
comparisonRaw = emdDiffs-mseDiffs;
%comparisonRaw = mseDiffs-emdDiffs;

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
