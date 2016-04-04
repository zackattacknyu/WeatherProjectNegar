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

for trialN = 1:numTrials
    randPatches = randperm(numPatches);
    for k = 1:numPatches
        randPatchesUse = randPatches(1:k);
        workSampled = totalWorkEMD(:,randPatchesUse);
        
        meanWbar(:,trialN,k) = mean(workSampled,2);
        varWbar(:,trialN,k) = var(workSampled,[],2)./k;
 
    end
    
    
end
%%

multiplier1 = 3;
upperConfidence = meanWbar + multiplier1.*sqrt(varWbar);
lowerConfidence = meanWbar - multiplier1.*sqrt(varWbar);

startColInd = 1000;
dispRows = 1:10;
lineWidth=3;
lineWidth2=2;
predColors = {'b' 'r'};

minCI = min(reshape(lowerConfidence(:,dispRows,startColInd:end),1,[]));
maxCI = max(reshape(upperConfidence(:,dispRows,startColInd:end),1,[]));

minY = min(reshape(meanWbar(:,dispRows,startColInd:end),1,[]));
maxY = max(reshape(meanWbar(:,dispRows,startColInd:end),1,[]));

figure
title('CI For Mean');
hold on
for pp = 1:numPred
    plot(permute(upperConfidence(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} '--']) 
    plot(permute(lowerConfidence(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} ':']) 
    plot(permute(meanWbar(pp,dispRows,:),[3 2 1]),...
        [predColors{pp} '-'],'LineWidth',lineWidth2) 
    plot(Wvalues(pp).*ones(1,numPatches),...
        'k--','LineWidth',lineWidth);
end
axis([startColInd numPatches minCI maxCI]);
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


