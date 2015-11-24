
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
    newPred2Errors = predErrorNew2MSE{i};
    oldPredErrorsEMD = predErrorOldEMD{i};
    newPredErrorsEMD = predErrorNewEMD{i}; 
    newPred2ErrorsEMD = predErrorNew2EMD{i};
    
    curPatchesT = patchesT{i};
    curPatchesOld = patchesOld{i};
    curPatchesNew = patchesNew{i};
    curPatchesNew2 = patchesNew2{i};
    
    for j = 1:length(oldPredErrors);
        curMSEerrors = [oldPredErrors(j) newPredErrors(j) newPred2Errors(j)];
        curEMDerrors = [oldPredErrorsEMD(j) newPredErrorsEMD(j) newPred2ErrorsEMD(j)];
        
        targetPatches{index} = curPatchesT{j};
        predPatches{index} = {curPatchesOld{j},curPatchesNew{j},curPatchesNew2{j}};
        
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
%%
interestingPatchInds = interestingPatchInds(1:(patchInd-1));
interestingEMDdiffs = maxEMDdiff(interestingPatchInds);
interestingMSEdiffs = maxMSEdiff(interestingPatchInds);
%[sortedEMDdiffs,orderedExamples] = sort(interestingEMDdiffs,'descend');
[sortedEMDdiffs,orderedExamples] = sort(interestingMSEdiffs,'descend');

patchIndsUse = interestingPatchInds(orderedExamples);

%%

%displays in multiple plots

%numDisplay = length(patchIndsUse);
numDisplay = 8;
numPerWindow = 4;
%displayInds = randperm(numCalc);
%displayInds = displayInds(randperm(length(displayInds)));

for j = 1:numDisplay
    
    if(mod(j-1,numPerWindow)==0)
       figure
       rowInd = 0;
    end
    rowInd = rowInd+1;
    
    curInd = patchIndsUse(j);
    curII = iValue(curInd);
    curJJ = jValue(curInd);
    
    targetP = targetPatches{curInd};
    maxPixel = max(targetP(:));
    
    curMSEerrors = predErrorMSE{curInd};
    curEMDerrors = predErrorEMD{curInd};
    [sortedMSE,mseOrder] = sort(curMSEerrors);
    [sortedEMD,emdOrder] = sort(curEMDerrors);
    
    curPredPatches = predPatches{curInd};
    
    usedInds = [emdOrder(1) mseOrder(1)];
    lastInd = setdiff(emdOrder,usedInds);
    
    leftP = curPredPatches{1};
    middleP = curPredPatches{2};
    rightP = curPredPatches{3};
    
    pInd = 4*(rowInd-1);
    subplot(numPerWindow,4,1+pInd);
    imagesc(targetP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,4,2+pInd);
    imagesc(leftP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,4,3+pInd);
    imagesc(middleP,[0 maxPixel]);
    colorbar;
    subplot(numPerWindow,4,4+pInd);
    imagesc(rightP,[0 maxPixel]);
    colorbar;
end

%%


numDisplay = length(patchIndsUse);
%numDisplay = 8;
%displayInds = randperm(numCalc);
%displayInds = displayInds(randperm(length(displayInds)));

leftPatches = cell(1,numDisplay);
middlePatches = cell(1,numDisplay);
rightPatches = cell(1,numDisplay);
indexOfNewest = zeros(1,numDisplay);

for j = 1:numDisplay
    
    curInd = patchIndsUse(j);
    
    targetP = targetPatches{curInd};
    
    curMSEerrors = predErrorMSE{curInd};
    curEMDerrors = predErrorEMD{curInd};
    [sortedMSE,mseOrder] = sort(curMSEerrors);
    [sortedEMD,emdOrder] = sort(curEMDerrors);
    
    curPredPatches = predPatches{curInd};
    
    usedInds = [emdOrder(1) mseOrder(1)];
    lastInd = setdiff(emdOrder,usedInds);
    
    locationOfNewest = find([emdOrder(1) mseOrder(1) lastInd]==3);
    indexOfNewest(j) = locationOfNewest(1);
    
    leftP = curPredPatches{1};
    middleP = curPredPatches{2};
    rightP = curPredPatches{3};
    
    leftPatches{j} = leftP;
    middlePatches{j} = middleP;
    rightPatches{j} = rightP;
    
    
end
%%

dispPatches = {targetPatches,leftPatches,middlePatches,rightPatches,indexOfNewest};


predCol1 = dispPatches{2};
numSlices = length(predCol1);
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
