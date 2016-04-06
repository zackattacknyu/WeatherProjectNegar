%{
Taken from the following:
https://en.wikipedia.org/wiki/Standard_error#Standard_error_of_the_mean

as well as this:
http://www.statlect.com/fundamentals-of-statistics/mean-estimation

TODO:
CONTRAST THE CONFIDENCE INTERVALS WITH THE ONES
    OBTAINED VIA LOG-NORMAL DISTRIBUTION

NOTE: IT IS POSSIBLE TO HAVE NON-INTERSECTING
    CONFIDENCE INTERVALS BEFORE THE RIGHT CONCLUSION
    IS DRAWN FROM THE SAMPLE MEAN. THAT IS WHY
    I WILL ENFORCE A MIN OF 1000 SAMPLES OR 10% OF THE DATA

TODO: Estimate the std of the without replacement estimator using this:
    https://www.ma.utexas.edu/users/parker/sampling/woreplshort.htm
http://stattrek.com/survey-research/simple-random-sample-analysis.aspx
    I WILL USE THAT FOR CONFIDENCE BOUND
%}

%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');

%%
numPatches = size(predErrorsEMD,2);
Wvalues = mean(totalWorkEMD,2);

numPred = size(totalWorkEMD,1);
numTrials = 10;

meanWbar = zeros(numPred,numTrials,size(predErrorsEMD,2));
varWbar = zeros(numPred,numTrials,size(predErrorsEMD,2));

meanWbar2 = zeros(numPred,numTrials,size(predErrorsEMD,2));
varWbar2 = zeros(numPred,numTrials,size(predErrorsEMD,2));

for trialN = 1:numTrials
    trialN
    randPatches = randperm(numPatches);
    randPatches2 = ceil(rand(1,numPatches)*numPatches);
    
    totalWorkEMD_A = totalWorkEMD(:,randPatches);
    totalWorkEMD_B = totalWorkEMD(:,randPatches2);
    
    for k = 1:numPatches

        workSampled = totalWorkEMD_A(:,1:k);
        workSampled2 = totalWorkEMD_B(:,1:k);
        
        %without replacement multiplier for variance given k
        woReplaceMult = (numPatches-k)/(k*(numPatches-1));
        
        meanWbar(:,trialN,k) = mean(workSampled,2);
        varWbar(:,trialN,k) = var(workSampled,[],2).*woReplaceMult;
 
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
multiplier1 = 1.96; %for 95% confidence
%multiplier1 = 2.58; %for 99% confidence
upperConfidence = meanWbar + multiplier1.*sqrt(varWbar);
lowerConfidence = meanWbar - multiplier1.*sqrt(varWbar);
upperConfidence2 = meanWbar2 + multiplier1.*sqrt(varWbar2);
lowerConfidence2 = meanWbar2 - multiplier1.*sqrt(varWbar2);

startColInd = 400;
endColInd = 9610;
dispRows = 1:10;
lineWidth=1;
lineWidth2=1;
predColors = {'b' 'r'};
predColors2 = {'c' 'm'};
predColors3 = {'y' 'g'};

minCI = min(reshape(lowerConfidence(:,dispRows,startColInd:endColInd),1,[]));
maxCI = max(reshape(upperConfidence(:,dispRows,startColInd:endColInd),1,[]));

minY = min(reshape(meanWbar(:,dispRows,startColInd:endColInd),1,[]));
maxY = max(reshape(meanWbar(:,dispRows,startColInd:endColInd),1,[]));

figure
title('CI For Mean without Replacement');
hold on
for pp = 1:numPred
    upperCI = permute(upperConfidence(pp,dispRows,:),[3 2 1]);
    lowerCI = permute(lowerConfidence(pp,dispRows,:),[3 2 1]);
    
    if(pp==1) %only care about upper CI for lower pred
        plot(max(upperCI,[],2),[predColors{pp} '--'],'LineWidth',lineWidth2) 
        plot(min(upperCI,[],2),[predColors{pp} '--'],'LineWidth',lineWidth2) 
    end
    
    if(pp==2) %only care about lower CI for upper pred
        plot(min(lowerCI,[],2),[predColors3{pp} ':'],'LineWidth',lineWidth2) 
        plot(max(lowerCI,[],2),[predColors3{pp} ':'],'LineWidth',lineWidth2) 
    end
    
    wbarVals = permute(meanWbar(pp,dispRows,:),[3 2 1]);

    if(pp==1)
        plot(max(wbarVals,[],2),[predColors2{pp} '-'],'LineWidth',lineWidth2) 
    elseif(pp==2)
        plot(min(wbarVals,[],2),[predColors2{pp} '-'],'LineWidth',lineWidth2) 
    end
    
    plot(Wvalues(pp).*ones(1,numPatches),...
        'k--','LineWidth',lineWidth);
end
axis([startColInd endColInd minCI maxCI]);
legend('Max Upper CI for lower Pred',...
    'Min Upper CI for lower Pred',...
    'Maximal empiricial Mean for lower Pred',...
    'Population Mean',...
    'Min Lower CI for higher Pred',...
    'Max Lower CI for higher Pred',...
    'Minimial empiricial Mean for higher Pred',...
    'Population Mean');
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


