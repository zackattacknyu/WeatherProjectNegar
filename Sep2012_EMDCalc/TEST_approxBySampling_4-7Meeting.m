%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');


numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = mean(totalWorkEMD,2);
LvalF1pred1 = LvaluesFunc1(1);
LvalF1pred2 = LvaluesFunc1(2);

numTrials = 50;
LkValuesF1pred1 = zeros(numTrials,size(predErrorsEMD,2));
LkValuesF1pred2 = zeros(numTrials,size(predErrorsEMD,2));

for trialN = 1:numTrials
    randPatches = randperm(numPatches);
    for k = 1:numPatches
        randPatchesUse = randPatches(1:k);
        workSampled = totalWorkEMD(:,randPatchesUse);
        
        f1Vals = mean(workSampled,2);
        
        LkValuesF1pred1(trialN,k) = f1Vals(1);      
        LkValuesF1pred2(trialN,k) = f1Vals(2);
        
    end
    
    
end

%%
startColInd = 500;
dispRows = 1:50;
lineWidth=3;

minYf1p1 = min(min(LkValuesF1pred1(dispRows,startColInd:end)));
maxYf1p1 = max(max(LkValuesF1pred1(dispRows,startColInd:end)));

minYf1p2 = min(min(LkValuesF1pred2(dispRows,startColInd:end)));
maxYf1p2 = max(max(LkValuesF1pred2(dispRows,startColInd:end)));

minY = min([minYf1p1 minYf1p2]);
maxY = max([maxYf1p1 maxYf1p2]);

figure
title('L_k values for Predictions');
hold on
plot(LkValuesF1pred1(dispRows,:)','b') 
plot(LkValuesF1pred2(dispRows,:)','r')  
plot(LvalF1pred1.*ones(1,numPatches),'k--','LineWidth',lineWidth);
plot(LvalF1pred2.*ones(1,numPatches),'k--','LineWidth',lineWidth);
axis([startColInd numPatches minY maxY]);
xlabel('k value');
ylabel('L_k value');
hold off


%%
F1pred1diff = LkValuesF1pred1-LvalF1pred1;
F2pred1diff = LkValuesF2pred1-LvalF2pred1;
F1pred2diff = LkValuesF1pred2-LvalF1pred2;
F2pred2diff = LkValuesF2pred2-LvalF2pred2;
LkF1pred1result = max(abs(F1pred1diff));
LkF2pred1result = max(abs(F2pred1diff));
LkF1pred2result = max(abs(F1pred2diff));
LkF2pred2result = max(abs(F2pred2diff));
%%
LkF1pred1bias = mean(F1pred1diff);
LkF2pred1bias = mean(F2pred1diff);
LkF1pred2bias = mean(F1pred2diff);
LkF2pred2bias = mean(F2pred2diff);
 
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

startColInd = 1000;
endColInd = numPatches;
maxY = max([LkF1pred1disp(startColInd:endColInd) ...
    LkF2pred1disp(startColInd:endColInd) ...
    LkF1pred2disp(startColInd:endColInd) ...
    LkF2pred2disp(startColInd:endColInd)]);
maxY2 = max([LkF2pred1disp(startColInd:endColInd) ...
    LkF2pred2disp(startColInd:endColInd)]);
figure
hold on
plot(LkF1pred1disp,'r-');
plot(LkF2pred1disp,'g-');
plot(LkF1pred2disp,'b-');
plot(LkF2pred2disp,'k-');
legend('Function 1, Pred 1','Function 2, Pred 1',...
    'Function 1, Pred 2','Function 2, Pred 2');
hold off
axis([startColInd endColInd 0 maxY]);
xlabel('k value');
ylabel('epsilon value required');

prefEpsilon = (LvalF2pred2-LvalF2pred1)/2;

figure
hold on
plot(LkF2pred1disp,'g-');
plot(LkF2pred2disp,'k-');
plot(prefEpsilon.*ones(1,length(LkF2pred2disp)),'r--');
legend('Function 2, Pred 1','Function 2, Pred 2','(L_2-L_1)/2');
hold off
axis([startColInd endColInd 0 maxY2]);
xlabel('k value');
ylabel('epsilon value required');
%%
numKneeded = find(LkF2pred2disp>prefEpsilon,1,'last')