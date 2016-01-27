load('patchesSetData.mat');

getDispPatchesScript;


%load('sendThisToZach_736336_4323.mat');
load('sendThisToZach_736354_8829.mat');

[~,patchIndsOrder] = sort(displayPatchInds);
selectionsSortedOrder = selections(patchIndsOrder);

precipCutoff = 1; %below this means no rain
numPixels = numel(dispPatches{1,1});
numSamples = size(dispPatches,2);

mseProb = zeros(1,numSamples);
emdProb = zeros(1,numSamples);
mseWeightedProb = zeros(1,numSamples);
emdWeightedProb = zeros(1,numSamples);

mseCoeff = zeros(1,numSamples);
emdCoeff = zeros(1,numSamples);
mseWeightedCoeff = zeros(1,numSamples);
emdWeightedCoeff = zeros(1,numSamples);

targetAccum = zeros(1,numSamples);
selectedCorrectProb = zeros(1,numSamples);

for i = 1:size(dispPatches,2)
   curTarget = dispPatches{1,i};
   curMSEpred = dispPatches{2,i};
   curEMDpred = dispPatches{3,i};
   
   curMSErain = (curMSEpred(:)<precipCutoff);
   curEMDrain = (curEMDpred(:)<precipCutoff);
   curTargetRain = (curTarget(:)<precipCutoff);
   
   curTargetAccum = sum(curTarget(:));
   targetAccum(i) = curTargetAccum;
   
   mseProb(i) = getMeasure(curTargetRain,curMSErain);
   emdProb(i) = getMeasure(curTargetRain,curEMDrain);
   
   mseWeightedProb(i) = mseProb(i)*curTargetAccum;
   emdWeightedProb(i) = emdProb(i)*curTargetAccum;
   
   mseCoeff(i) = getCoeff(curTarget(:),curMSEpred(:));
   emdCoeff(i) = getCoeff(curTarget(:),curEMDpred(:));
   
   mseWeightedCoeff(i) = mseCoeff(i)*curTargetAccum;
   emdWeightedCoeff(i) = emdCoeff(i)*curTargetAccum;
   
   if(selectionsSortedOrder(i)==1)
       selectedCorrectProb(i) = emdProb(i);
   elseif(selectionsSortedOrder(i)==2)
       selectedCorrectProb(i) = mseProb(i);
   else
       if(rand<0.5)
           selectedCorrectProb(i) = emdProb(i);
       else
           selectedCorrectProb(i) = mseProb(i);
       end
   end
   
end

mseTotalWeighted = sum(mseWeightedProb)/sum(targetAccum);
emdTotalWeighted = sum(emdWeightedProb)/sum(targetAccum);

mseTotalWeightedCoeff = sum(mseWeightedCoeff)/sum(targetAccum);
emdTotalWeightedCoeff = sum(emdWeightedCoeff)/sum(targetAccum);

[~,emdOrder] = sort(emdProb);
[~,mseOrder] = sort(mseProb);
[~,selectedOrder]=sort(selectedCorrectProb);

curOrder = emdOrder;

figure
hold on
plot(emdProb(curOrder),'r-');
plot(mseProb(curOrder),'b-');
hold off
legend('EMD','MSE','Location','eastoutside');