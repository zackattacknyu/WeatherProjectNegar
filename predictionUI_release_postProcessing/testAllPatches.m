load('patchesSetData.mat');

[bestMSEvals,bestPredsMSE] = min(predErrorsMSE);
[bestEMDvals,bestPredsEMD] = min(predErrorsEMD);

linearMSEinds = sub2ind(size(predErrorsMSE),bestPredsMSE,1:size(predErrorsMSE,2));
linearEMDinds = sub2ind(size(predErrorsEMD),bestPredsEMD,1:size(predErrorsEMD,2));
dispPatches = cell(7,size(predErrorsMSE,2));
dispPatches(1,:) = targetPatches;
dispPredPatches = predPatches(:);
dispPatches(2,:) = dispPredPatches(linearEMDinds);
dispPatches(3,:) = dispPredPatches(linearMSEinds);

dispPatches(4,:)=predPatches(1,:);
dispPatches(5,:)=predPatches(2,:);
dispPatches(6,:)=predPatches(3,:);
dispPatches(7,:)=predPatches(4,:);


precipCutoff = 1; %below this means no rain
numPixels = numel(dispPatches{1,1});
numSamples = size(dispPatches,2);

probModel = zeros(6,numSamples);
weightedProbModel = zeros(6,numSamples);

coeffModel = zeros(6,numSamples);
weightedCoeffModel = zeros(6,numSamples);

targetAccum = zeros(1,numSamples);

for i = 1:size(dispPatches,2)
   curTarget = dispPatches{1,i};
   curTargetArray = curTarget(:);
   curTargetRain = (curTargetArray<precipCutoff);
   curTargetAccum = sum(curTargetArray);
   
   for j = 2:7
      curPred = dispPatches{j,i};
      curPredRain = (curPred(:)<precipCutoff);
      
      k = j-1;
      probModel(k,i) = getMeasure(curTargetRain,curPredRain);
      weightedProbModel(k,i) = probModel(k,i)*curTargetAccum;
      
      coeffModel(k,i) = getCoeff(curTargetArray,curPred(:));
      weightedCoeffModel(k,i) = coeffModel(k,i)*curTargetAccum;
   end
      
   
   targetAccum(i) = curTargetAccum;
   
end

totalAccumulation = sum(targetAccum);
probSumVector = sum(probModel,2);
coeffSumVector = sum(coeffModel,2);

overallProbs = probSumVector./numSamples;
overallProbsWeighted = probSumVector./totalAccumulation;

overallCoeffs = coeffSumVector./numSamples;
overallCoeffsWeighted = coeffSumVector./totalAccumulation;
