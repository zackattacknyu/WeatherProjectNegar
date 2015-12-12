dataSetNumber=2;

numString = num2str(dataSetNumber);
loadFileName = strcat('patchesSet11-23Data_',numString,'.mat');
loadResultsFileName = strcat('patchesSet11-23Data_',numString,'_results.mat');

load(loadFileName);
load(loadResultsFileName);

ccs_predictions_filterErrors


topRatio = 0.01;

errorMatrix = predErrorsEMD;
otherMatrix = predErrorsMSE;
[ dispPatches ] = ...
    getDisplayPatches_12_14Meeting( targetPatches,predPatches,errorMatrix,otherMatrix,topRatio );

errorMatrix = predErrorsMSE;
otherMatrix = predErrorsEMD;
[ dispPatches2 ] = ...
    getDisplayPatches_12_14Meeting( targetPatches,predPatches,errorMatrix,otherMatrix,topRatio );

numRow=5;
figure
for i = 1:numRow
    
    curTarget = dispPatches{1,i};
    maxP = max(curTarget(:));
    
    for j = 1:2
       subplot(numRow,4,4*(i-1) + j)
       curPatch = dispPatches{j,i};
       imagesc(curPatch,[0 maxP]);
       colorbar;
    end
    
    curTarget = dispPatches2{1,i};
    maxP = max(curTarget(:));
    
    for j = 1:2
       subplot(numRow,4,4*(i-1) + j + 2)
       curPatch = dispPatches2{j,i};
       imagesc(curPatch,[0 maxP]);
       colorbar;
    end
    
    
end

%CURRENT_displaySlider;


