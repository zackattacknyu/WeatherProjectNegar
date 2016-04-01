%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');


numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = mean(totalWorkEMD,2);
Lpred1 = LvaluesFunc1(1);
Lpred2 = LvaluesFunc1(2);

numTrials = 100;
LkPred1 = zeros(numTrials,size(predErrorsEMD,2));
LkPred2 = zeros(numTrials,size(predErrorsEMD,2));

for trialN = 1:numTrials
    randPatches = randperm(numPatches);
    %randPatchesUse = [];
    for k = 1:numPatches
        randPatchesUse = randPatches(1:k);
        %randPatchesUse = [randPatchesUse ceil(numPatches*rand(1,1))];
        workSampled = totalWorkEMD(:,randPatchesUse);
        
        f1Vals = mean(workSampled,2);
        
        LkPred1(trialN,k) = f1Vals(1);      
        LkPred2(trialN,k) = f1Vals(2);
        
    end
    
    
end
%%
startColInd = 500;
dispRows = 1:100;
lineWidth=3;

minYf1p1 = min(min(LkPred1(dispRows,startColInd:end)));
maxYf1p1 = max(max(LkPred1(dispRows,startColInd:end)));

minYf1p2 = min(min(LkPred2(dispRows,startColInd:end)));
maxYf1p2 = max(max(LkPred2(dispRows,startColInd:end)));

minY = min([minYf1p1 minYf1p2]);
maxY = max([maxYf1p1 maxYf1p2]);

figure
title('L_k values for Predictions');
hold on
plot(LkPred1(dispRows,:)','b') 
plot(LkPred2(dispRows,:)','r')  
plot(Lpred1.*ones(1,numPatches),'k--','LineWidth',lineWidth);
plot(Lpred2.*ones(1,numPatches),'k--','LineWidth',lineWidth);
axis([startColInd numPatches minY maxY]);
xlabel('k value');
ylabel('L_k value');
hold off
%%



