%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');
%%

numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = mean(predErrorsEMD,2);
LvaluesFunc2 = sum(totalWorkEMD,2)./sum(totalFlowEMD,2);

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


startColInd = 1000;
numEntries = numPatches-startColInd;
figure
title('L_k values for Dec Tree Prediction, Original L_k');
hold on
plot(LvaluesFunc1(1).*ones(1,numEntries),'r--');
for trialN = 1:numTrials
    plot(LkValuesF1pred1(trialN,startColInd:end))    
end
hold off

figure
title('L_k values for Dec Tree Prediction, New L_k');
hold on
plot(LvaluesFunc2(1).*ones(1,numEntries),'r--');
for trialN = 1:numTrials
    plot(LkValuesF2pred1(trialN,startColInd:end))    
end
hold off

figure
title('L_k values for CCS Prediction, Original L_k');
hold on
plot(LvaluesFunc1(2).*ones(1,numEntries),'r--');
for trialN = 1:numTrials
    plot(LkValuesF1pred2(trialN,startColInd:end))    
end
hold off

figure
title('L_k values for CCS Prediction, New L_k');
hold on
plot(LvaluesFunc2(2).*ones(1,numEntries),'r--');
for trialN = 1:numTrials
    plot(LkValuesF2pred2(trialN,startColInd:end))    
end
hold off
%%

%{
HERE WE MUST PUT VAR AND MAX
VAR WILL LIKELY WORK BETTER
IT IS SMOOTHER AND CLOSER TO WHAT WE WOULD WANT
    WITH REAL-WORLD TESTING
WE WILL THUS REPORT WHEN VAR(L_K)<EPSILON
THIS WILL GIVE US AN IDEA OF WHEN WE REACH THOSE EPSILON VALUES
%}

F1pred1diff = LkValuesF1pred1-LvaluesFunc1(1);
F2pred1diff = LkValuesF2pred1-LvaluesFunc2(1);
F1pred2diff = LkValuesF1pred2-LvaluesFunc1(2);
F2pred2diff = LkValuesF2pred2-LvaluesFunc2(2);
LkF1pred1var = var(F1pred1diff);
LkF2pred1var = var(F2pred1diff);
LkF1pred2var = var(F1pred2diff);
LkF2pred2var = var(F2pred2diff);
avgDiff_F1_pred1 = mean(F1pred1diff);
avgDiff_F2_pred1 = mean(F2pred1diff);
avgDiff_F1_pred2 = mean(F1pred2diff);
avgDiff_F2_pred2 = mean(F2pred2diff);

%%
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

startColInd = 1000;
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
axis([startColInd numPatches 0 inf]);

figure
title('Lowest Epsilon Value Possible');
hold on
plot(LkF2pred1var,'g-');
plot(LkF2pred2var,'k-');
legend('Function 2, Pred 1','Function 2, Pred 2');
hold off
axis([startColInd numPatches 0 inf]);