close all


if(useEMD)
    errorMatrix = predErrorsEMD;
    otherMatrix = predErrorsMSE;
else
    errorMatrix = predErrorsMSE;
    otherMatrix = predErrorsEMD;
end

topRatio = 0.01;
[ dispPatches ] = ...
    getDisplayPatches_12_14Meeting( targetPatches,predPatches,errorMatrix,otherMatrix,topRatio );

numRow=5;
figure
for i = 1:numRow
    
    curTarget = dispPatches{1,i};
    maxP = max(curTarget(:));
    
    for j = 1:2
       subplot(numRow,2,2*(i-1) + j)
       curPatch = dispPatches{j,i};
       imagesc(curPatch,[0 maxP]);
       colorbar;
    end
end

%CURRENT_displaySlider;