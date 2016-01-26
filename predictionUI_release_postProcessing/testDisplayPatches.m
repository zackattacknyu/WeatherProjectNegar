load('patchesSetData.mat');

getDispPatchesScript;

load('sendThisToZach_736336_4323.mat');

[~,patchIndsOrder] = sort(displayPatchInds);
selectionsSortedOrder = selections(patchIndsOrder);

precipCutoff = 1; %below this means no rain
numPixels = numel(dispPatches{1,1});
numSamples = size(dispPatches,2);

mseCorrectProb = zeros(1,numSamples);
emdCorrectProb = zeros(1,numSamples);
selectedCorrectProb = zeros(1,numSamples);

for i = 1:size(dispPatches,2)
   curTarget = dispPatches{1,i};
   curMSEpred = dispPatches{2,i};
   curEMDpred = dispPatches{3,i};
      
   curMSErain = (curMSEpred(:)<precipCutoff);
   curEMDrain = (curEMDpred(:)<precipCutoff);
   curTargetRain = (curTarget(:)<precipCutoff);
   
   mseCorrectProb(i) = sum(curMSErain==curTargetRain)/numPixels;
   emdCorrectProb(i) = sum(curEMDrain==curTargetRain)/numPixels;
   
   if(selectionsSortedOrder(i)==1)
       selectedCorrectProb(i) = emdCorrectProb(i);
   elseif(selectionsSortedOrder(i)==2)
       selectedCorrectProb(i) = mseCorrectProb(i);
   else
       if(rand<0.5)
           selectedCorrectProb(i) = emdCorrectProb(i);
       else
           selectedCorrectProb(i) = mseCorrectProb(i);
       end
   end
   
end

mean(emdCorrectProb);
mean(mseCorrectProb);
mean(selectedCorrectProb);

[~,emdOrder] = sort(emdCorrectProb);
[~,mseOrder] = sort(mseCorrectProb);

curOrder = mseOrder;

figure
hold on
plot(emdCorrectProb(curOrder),'r-');
plot(mseCorrectProb(curOrder),'b-');
hold off
legend('EMD','MSE');