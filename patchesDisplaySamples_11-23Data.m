clear all;
load('patchesSet11-23Data_1.mat');

numPatches = 0;
for i = 1:length(patchesT)
    numPatches = numPatches + length(patchesT{i});
end


numPred=4;
targetPatches = cell(1,numPatches);
predPatches = cell(numPred,numPatches);
index = 1;
for i = 1:length(patchesT)
    
    curPatchesT = patchesT{i};
    curPredPatches = patchesPred{i};
    
    for j = 1:length(curPatchesT);
        
        targetPatches{index} = curPatchesT{j};
        predPatches(:,index) = curPredPatches(:,j);
       
        index = index+1;
    end
    
end
%%
numDisplay=100;
%numDisplay = length(patchIndsUse);
patchIndsUse = randperm(numPatches);
patchIndsUse = patchIndsUse(1:numDisplay);

numPred=4;
dispPatches = cell(numPred+1,numDisplay);
%%
for j = 1:numDisplay
    
    curInd = patchIndsUse(j);
    
    targetP = targetPatches{curInd};
    maxPixel = max(targetP(:));
    
    dispPatches{1,j} = targetP;
    
    for i = 1:numPred
        dispPatches{i+1,j} = predPatches{i,curInd};
    end
    
    
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
