clear all;
load('patches11-22_partialResults2.mat');

numPatches = 0;
for i = 1:43
    numPatches = numPatches + length(patchesT{i});
end

targetPatches = cell(1,numPatches);
predPatches = cell(1,numPatches);
predErrorMSE = cell(1,numPatches);
predErrorEMD = cell(1,numPatches);
predErrorOrderMSE = cell(1,numPatches);
predErrorOrderEMD = cell(1,numPatches);
maxMSEdiff = zeros(1,numPatches);
maxEMDdiff = zeros(1,numPatches);
iValue = zeros(1,numPatches); %timestep val
jValue = zeros(1,numPatches); %index in timestep
interestingPatchInds = zeros(1,numPatches);
patchInd = 1;
index = 1;
for i = 1:43
   
    oldPredErrors = predErrorOldMSE{i};
    newPredErrors = predErrorNewMSE{i};
    oldPredErrorsEMD = predErrorOldEMD{i};
    newPredErrorsEMD = predErrorNewEMD{i}; 
    
    curPatchesT = patchesT{i};
    curPatchesOld = patchesOld{i};
    curPatchesNew = patchesNew{i};
    curPatchesNew2 = patchesNew2{i};
    
    for j = 1:length(oldPredErrors);
        curMSEerrors = [oldPredErrors(j) newPredErrors(j)];
        curEMDerrors = [oldPredErrorsEMD(j) newPredErrorsEMD(j)];
        
        targetPatches{index} = curPatchesT{j};
        predPatches{index} = {curPatchesOld{j},curPatchesNew{j}};
        
        predErrorMSE{index} = curMSEerrors;
        predErrorEMD{index} = curEMDerrors;
        
        [sortedMSE,mseOrder] = sort(curMSEerrors);
        [sortedEMD,emdOrder] = sort(curEMDerrors);
        
        if(mseOrder(1)~=emdOrder(1) && ~isnan(sortedEMD(1)))
            interestingPatchInds(patchInd) = index;
            patchInd = patchInd + 1;
        end
        
        maxMSEdiff(index) = sortedMSE(2)-sortedMSE(1);
        maxEMDdiff(index) = sortedEMD(2)-sortedEMD(1);
        iValue(index) = i;
        jValue(index) = j;
        index = index+1;
    end
    
end

interestingPatchInds = interestingPatchInds(1:(patchInd-1));
interestingEMDdiffs = maxEMDdiff(interestingPatchInds);
interestingMSEdiffs = maxMSEdiff(interestingPatchInds);
%[sortedEMDdiffs,orderedExamples] = sort(interestingEMDdiffs,'descend');
[sortedEMDdiffs,orderedExamples] = sort(interestingMSEdiffs,'descend');

patchIndsUse = interestingPatchInds(orderedExamples);
%%patchIndsUse = patchIndsUse(randperm(length(patchIndsUse)));

numDisplay = length(patchIndsUse);


maxPixel = zeros(1,numDisplay);

numPred=2;
dispPatches = cell(numPred+1,numDisplay);

for j = 1:numDisplay
    
    curInd = patchIndsUse(j);
    
    targetP = targetPatches{curInd};
    maxPixel = max(targetP(:));
    
    dispPatches{1,j} = targetP;
    
    curMSEerrors = predErrorMSE{curInd};
    curEMDerrors = predErrorEMD{curInd};
    [sortedMSE,mseOrder] = sort(curMSEerrors);
    [sortedEMD,emdOrder] = sort(curEMDerrors);
    
    curPredPatches = predPatches{curInd};
    
    leftP = curPredPatches{emdOrder(1)};
    middleP = curPredPatches{mseOrder(1)};
    
    dispPatches{2,j} = leftP;
    dispPatches{3,j} = middleP;
    
    
end

%%

numSlices = size(dispPatches,2);
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
