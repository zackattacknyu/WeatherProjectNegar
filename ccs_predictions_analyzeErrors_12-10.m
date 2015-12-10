load('patchesSet11-23Data_3_results.mat');
load('patchesSet11-23Data_3.mat');


%{
This block of code will compare the original CSS
    to the new 253 CSS prediction,
so block 1 and 2

Shows examples where MSE and EMD 
would have a difficult time choosing between predictions
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
displayPatchInds = mseOrderAbs;

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
