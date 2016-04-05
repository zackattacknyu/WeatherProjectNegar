%{
Taken from the following:
https://en.wikipedia.org/wiki/Standard_error#Standard_error_of_the_mean

as well as this:
http://www.statlect.com/fundamentals-of-statistics/mean-estimation

TODO:
CONTRAST THE CONFIDENCE INTERVALS WITH THE ONES
    OBTAINED VIA LOG-NORMAL DISTRIBUTION
%}

%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');


numPatches = size(predErrorsEMD,2);
Wvalues = mean(totalWorkEMD,2);

numPred = size(totalWorkEMD,1);
numTrials = 10;

meanWbar = zeros(numPred,numTrials,size(predErrorsEMD,2));
varWbar = zeros(numPred,numTrials,size(predErrorsEMD,2));

meanWbar2 = zeros(numPred,numTrials,size(predErrorsEMD,2));
varWbar2 = zeros(numPred,numTrials,size(predErrorsEMD,2));

for trialN = 1:numTrials
    randPatches = randperm(numPatches);
    randPatches2 = ceil(rand(1,numPatches)*numPatches);
    for k = 1:numPatches
        randPatchesUse = randPatches(1:k);
        workSampled = totalWorkEMD(:,randPatchesUse);
        
        randPatchesUse2 = randPatches2(1:k);
        workSampled2 = totalWorkEMD(:,randPatchesUse2);
        
        meanWbar(:,trialN,k) = mean(workSampled,2);
        varWbar(:,trialN,k) = var(workSampled,[],2)./k;
 
        meanWbar2(:,trialN,k) = mean(workSampled2,2);
        varWbar2(:,trialN,k) = var(workSampled2,[],2)./k;
    end
    
    
end
%%

%find the multiplier
multiplierValues = 0:0.01:10;
areaRatioWithMultiplier = zeros(1,length(multiplierValues));
for ind = 1:length(multiplierValues)
    tt = multiplierValues(ind);
    areaRatioWithMultiplier(ind) = ...
        diff(normcdf([-tt tt],0,1));
end

desiredRatio = 0.999999;
indReq = find(areaRatioWithMultiplier>=desiredRatio,1,'first');
reqMultiplier = multiplierValues(indReq);

%%
%multiplier1 = 1.96; %for 95% confidence
multiplier1 = 2.58; %for 99% confidence
upperConfidence = meanWbar + multiplier1.*sqrt(varWbar);
lowerConfidence = meanWbar - multiplier1.*sqrt(varWbar);
upperConfidence2 = meanWbar2 + multiplier1.*sqrt(varWbar2);
lowerConfidence2 = meanWbar2 - multiplier1.*sqrt(varWbar2);

startColInd = 200;
endColInd = 2000;
dispRows = 1:10;
lineWidth=3;
lineWidth2=2;
predColors = {'b' 'r'};
predColors2 = {'c' 'm'};

minCI = min(reshape(lowerConfidence(:,dispRows,startColInd:endColInd),1,[]));
maxCI = max(reshape(upperConfidence(:,dispRows,startColInd:endColInd),1,[]));

minY = min(reshape(meanWbar(:,dispRows,startColInd:endColInd),1,[]));
maxY = max(reshape(meanWbar(:,dispRows,startColInd:endColInd),1,[]));

figure
title('CI For Mean without Replacement');
hold on
for pp = 1:numPred
    plot(permute(upperConfidence(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} '--']) 
    plot(permute(lowerConfidence(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} ':']) 
    plot(permute(meanWbar(pp,dispRows,:),[3 2 1]),...
        [predColors2{pp} '-'],'LineWidth',lineWidth2) 
    plot(Wvalues(pp).*ones(1,numPatches),...
        'k--','LineWidth',lineWidth);
end
axis([startColInd endColInd minCI maxCI]);
xlabel('k value');
ylabel('W_k value');
hold off


figure
title('CI For Mean with Replacement');
hold on
for pp = 1:numPred
    plot(permute(upperConfidence2(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} '--']) 
    plot(permute(lowerConfidence2(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} ':']) 
    plot(permute(meanWbar2(pp,dispRows,:),[3 2 1]),...
        [predColors2{pp} '-'],'LineWidth',lineWidth2) 
    plot(Wvalues(pp).*ones(1,numPatches),...
        'k--','LineWidth',lineWidth);
end
axis([startColInd endColInd minCI maxCI]);
xlabel('k value');
ylabel('W_k value');
hold off
%%
figure
title('Wbar values for Mean');
hold on
for pp = 1:numPred
    plot(permute(meanWbar(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} '-']) 
    plot(Wvalues(pp).*ones(1,numPatches),...
        'k--','LineWidth',lineWidth);
end
axis([startColInd numPatches minY maxY]);
xlabel('k value');
ylabel('W_k value');
hold off


