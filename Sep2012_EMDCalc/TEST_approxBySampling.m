%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');

numPatches = size(predErrorsEMD,2);
randPatches = randperm(numPatches);


patchSum = zeros(1,numPatches);
for k = 1:numPatches
   curPatch = targetPatches{k};
   patchSum(k) = sum(curPatch(:));
end

%%
%numRandPatches = floor(numPatches*0.6);
emd1Array = zeros(1,numPatches);
emd2Array = zeros(1,numPatches);
emdOtherArray = zeros(1,numPatches);
emdOther2Array = zeros(1,numPatches);
varemd1 = ones(1,numPatches);
varemd2 = ones(1,numPatches);
varemdOther = ones(1,numPatches);
varemd2Other = ones(1,numPatches);
numCompare = 400;
minFlow = min(totalFlowEMD(:));
for ii = 1:numPatches
    randPatchesUse = randPatches(1:ii);
    predErrorsSampled = predErrorsEMD(:,randPatchesUse);
    workSampled = totalWorkEMD(:,randPatchesUse);
    flowSampled = totalFlowEMD(:,randPatchesUse);
    patchSumSampled = [patchSum(randPatchesUse);patchSum(randPatchesUse)];
    res = mean(predErrorsSampled,2);
    res2 = sum(workSampled,2)./sum(flowSampled,2);
    %res2 = sum(predErrorsSampled.*log(flowSampled/minFlow),2)./sum(log(flowSampled/minFlow),2);
    %res2 = sum(workSampled.*patchSumSampled,2)./sum(patchSumSampled,2);
    %res2 = sum(workSampled.*flowSampled,2)./sum(patchSumSampled,2);
    emd1Array(ii) = res(1);
    emdOtherArray(ii) = res2(1);
    
    emd2Array(ii) = res(2);
    emdOther2Array(ii) = res2(2);
    
    if(ii>numCompare)
        varemd1(ii) = var(emd1Array(ii-numCompare:ii));
        varemd2(ii) = var(emd2Array(ii-numCompare:ii));
        varemdOther(ii) = var(emdOtherArray(ii-numCompare:ii));
        varemd2Other(ii) = var(emdOther2Array(ii-numCompare:ii));
    end
end

figure
hold on
plot(emd1Array);
plot(emd2Array);
legend('Dec Tree','CCS Prediction');
title('Average EMD Loss Function Value');
xlabel('Number of Random Samples Averaged');
ylabel('Average EMD');
hold off

figure
hold on
plot(varemd1);
plot(varemd2);
legend('Dec Tree','CCS Prediction');
title('Average EMD Variance of Last 20 values');
xlabel('Number of Random Samples Averaged');
ylabel('Variance of Avg EMD values');
hold off

figure
hold on
plot(emdOtherArray);
plot(emdOther2Array);
legend('Dec Tree','CCS Prediction');
title('Average EMD Loss Function Value With Weighting');
xlabel('Number of Random Samples Averaged');
ylabel('Average EMD Weighted');
hold off

figure
hold on
plot(varemdOther);
plot(varemd2Other);
legend('Dec Tree','CCS Prediction');
title('Average Weighted EMD Variance of Last 20 values');
xlabel('Number of Random Samples Averaged');
ylabel('Variance of Avg Weighted EMD values');
hold off

%%


load('patchesSep2011Data_new1.mat');
%%

patchesSum = zeros(1,length(targetPatches));
for ii = 1:length(targetPatches)
    curPatch = targetPatches{ii};
    patchesSum(ii) = sum(curPatch(:));
end

%{

NO CORRELATION BETWEEN 
    SINGLE PATCH CHARACTERISTICS
    AND EMD FOUND

patchesDiff = zeros(1,length(targetPatches));
patchesEMD = predErrorsEMD(1,:);
for jj = 1:length(targetPatches)
    curPatch = targetPatches{jj};
    curPatchPred = predPatches{1,jj};
    %patchesDiff(jj) = sum((curPatch(:)-curPatchPred(:)).^2);
    %patchesDiff(jj) = sum(abs(curPatch(:)-curPatchPred(:)));
    patchesDiff(jj) = abs(sum(curPatch(:))-sum(curPatchPred(:)));
end

plot(patchesDiff,patchesEMD,'r.');

%}