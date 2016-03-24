%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');


numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = mean(predErrorsEMD,2);
LvaluesFunc2 = sum(totalWorkEMD,2)./sum(totalFlowEMD,2);
LvalF1pred1 = LvaluesFunc1(1);
LvalF1pred2 = LvaluesFunc1(2);
LvalF2pred1 = LvaluesFunc2(1);
LvalF2pred2 = LvaluesFunc2(2);

numTrials = 200;
LkValuesF1pred1 = zeros(numTrials,size(predErrorsEMD,2));
LkValuesF2pred1 = zeros(numTrials,size(predErrorsEMD,2));
LkValuesF1pred2 = zeros(numTrials,size(predErrorsEMD,2));
LkValuesF2pred2 = zeros(numTrials,size(predErrorsEMD,2));

for trialN = 1:numTrials
    randPatches = randperm(numPatches);
    for k = 1:numPatches
        randPatchesUse = randPatches(1:k);
        predErrorsSampled = predErrorsEMD(:,randPatchesUse);
        workSampled = totalWorkEMD(:,randPatchesUse);
        flowSampled = totalFlowEMD(:,randPatchesUse);
        
        f1Vals = mean(predErrorsSampled,2);
        f2Vals = sum(workSampled,2)./sum(flowSampled,2);
        
        LkValuesF1pred1(trialN,k) = f1Vals(1);
        LkValuesF2pred1(trialN,k) = f2Vals(1);
        
        LkValuesF1pred2(trialN,k) = f1Vals(2);
        LkValuesF2pred2(trialN,k) = f2Vals(2);
    end
    
    
end

%%
startColInd = 1000;
lineWidth=3;
numEntries = numPatches-startColInd;
figure
title('L_k values for Dec Tree Prediction, Original L_k');
hold on
plot(LkValuesF1pred1(:,startColInd:end)') 
plot(LvalF1pred1.*ones(1,numEntries),'k--','LineWidth',lineWidth);
hold off

figure
title('L_k values for Dec Tree Prediction, New L_k');
hold on
plot(LkValuesF2pred1(:,startColInd:end)')
plot(LvalF2pred1.*ones(1,numEntries),'k--','LineWidth',lineWidth);
hold off

figure
title('L_k values for CCS Prediction, Original L_k');
hold on
plot(LkValuesF1pred2(:,startColInd:end)')  
plot(LvalF1pred2.*ones(1,numEntries),'k--','LineWidth',lineWidth);
hold off

figure
title('L_k values for CCS Prediction, New L_k');
hold on
plot(LkValuesF2pred2(:,startColInd:end)')  
plot(LvalF2pred2.*ones(1,numEntries),'k--','LineWidth',lineWidth);
hold off


F1pred1diff = LkValuesF1pred1-LvalF1pred1;
F2pred1diff = LkValuesF2pred1-LvalF2pred1;
F1pred2diff = LkValuesF1pred2-LvalF1pred2;
F2pred2diff = LkValuesF2pred2-LvalF2pred2;
LkF1pred1result = max(abs(F1pred1diff));
LkF2pred1result = max(abs(F2pred1diff));
LkF1pred2result = max(abs(F1pred2diff));
LkF2pred2result = max(abs(F2pred2diff));

 
%{
figure
title('Lowest Epsilon Value Possible');
hold on
plot(LkF1pred1var,'r-');
plot(LkF2pred1var,'g-');
plot(LkF1pred2var,'b-');
plot(LkF2pred2var,'k-');
legend('Function 1, Pred 1','Function 2, Pred 1',...
    'Function 1, Pred 2','Function 2, Pred 2');
hold off
%}
%%

LkF1pred1disp = LkF1pred1result;
LkF2pred1disp = LkF2pred1result;
LkF1pred2disp = LkF1pred2result;
LkF2pred2disp = LkF2pred2result;

startColInd = 2000;
endColInd = numPatches;
maxY = max([LkF1pred1disp(startColInd:endColInd) ...
    LkF2pred1disp(startColInd:endColInd) ...
    LkF1pred2disp(startColInd:endColInd) ...
    LkF2pred2disp(startColInd:endColInd)]);
maxY2 = max([LkF2pred1disp(startColInd:endColInd) ...
    LkF2pred2disp(startColInd:endColInd)]);
figure
title('Lowest Epsilon Value Possible');
hold on
plot(LkF1pred1disp,'r-');
plot(LkF2pred1disp,'g-');
plot(LkF1pred2disp,'b-');
plot(LkF2pred2disp,'k-');
legend('Function 1, Pred 1','Function 2, Pred 1',...
    'Function 1, Pred 2','Function 2, Pred 2');
hold off
axis([startColInd endColInd 0 maxY]);

figure
title('Lowest Epsilon Value Possible');
hold on
plot(LkF2pred1disp,'g-');
plot(LkF2pred2disp,'k-');
legend('Function 2, Pred 1','Function 2, Pred 2');
hold off
axis([startColInd endColInd 0 maxY2]);