dataSetNumber=3;

numString = num2str(dataSetNumber);
loadFileName = strcat('patchesSet11-23Data_',numString,'.mat');
loadResultsFileName = strcat('patchesSet11-23Data_',numString,'_results.mat');

load(loadFileName);
load(loadResultsFileName);

ccs_predictions_filterErrors

%CHANGE THIS TO CHANGE PERCENTAGE
topRatio = 0.01;

errorMatrix = predErrorsEMD;
otherMatrix = predErrorsMSE;
[ dispPatches,topPred,otherOnes ] = ...
    getDisplayPatches_12_14Meeting( targetPatches,predPatches,errorMatrix,...
    otherMatrix,topRatio );

otherSortedArray = sort(predErrorsMSE(:));
titleA = 'MSE Percentile for top 1% EMD predictions';
xlabelA = 'Patch Number sorted by EMD';
xlabelB = 'Patch Number sorted by MSE';
ylabelA = 'MSE Percentile';
otherOnesA = otherOnes;

displayTopPredCorrelations;

errorMatrix = predErrorsMSE;
otherMatrix = predErrorsEMD;
[ dispPatches2,topPred2,otherOnes2 ] = ...
    getDisplayPatches_12_14Meeting( targetPatches,predPatches,errorMatrix,...
    otherMatrix,topRatio );

otherSortedArray = sort(predErrorsEMD(:));
titleA = 'EMD Percentile for top 1% MSE predictions';
xlabelA = 'Patch Number sorted by MSE';
xlabelB = 'Patch Number sorted by EMD';
ylabelA = 'EMD Percentile';
otherOnesA = otherOnes2;

displayTopPredCorrelations;

display12_14Table;


%CURRENT_displaySlider;

%ccs_predictions_12_14_oldAttempt

