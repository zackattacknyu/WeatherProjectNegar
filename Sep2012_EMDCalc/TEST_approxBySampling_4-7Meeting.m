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
%load('patchesSep2011Data_results_allT_new1.mat');
%load('patchesSep2011Data_allT_new1.mat');

load('patchesSep2011DataTest4_results.mat');
%load('patchesSep2011DataTest3_results.mat');
%load('patchesSep2011DataTest7_results.mat');
%load('patchesOct2012Data_results_all4.mat');

%%
numPatches = size(predErrorsEMD,2);
Wvalues = mean(totalWorkEMD,2);

numPred = size(totalWorkEMD,1);
numTrials = 10;

meanWbar = zeros(numPred,numTrials,size(predErrorsEMD,2));
varWbar = zeros(numPred,numTrials,size(predErrorsEMD,2));


for trialN = 1:numTrials
    trialN
    randPatches = randperm(numPatches);
    %randPatches2 = ceil(rand(1,numPatches)*numPatches);
    
    totalWorkEMD_A = totalWorkEMD(:,randPatches);
    
    for k = 1:numPatches

        workSampled = totalWorkEMD_A(:,1:k);
        
        %without replacement multiplier for variance given k
        woReplaceMult = (numPatches-k)/(k*(numPatches-1));
        
        meanWbar(:,trialN,k) = mean(workSampled,2);
        varWbar(:,trialN,k) = var(workSampled,[],2).*woReplaceMult;

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

desiredRatio = 0.9999;
indReq = find(areaRatioWithMultiplier>=desiredRatio,1,'first');
reqMultiplier = multiplierValues(indReq);

%%
%multiplier1 = 1.96; %for 95% confidence
%multiplier1 = 2.58; %for 99% confidence
multiplier1 = 3.9; %for 99.99% confidence
upperConfidence = meanWbar + multiplier1.*sqrt(varWbar);
lowerConfidence = meanWbar - multiplier1.*sqrt(varWbar);

meanDiff2 = meanWbar(2,:,:)-meanWbar(1,:,:);
diffStdFactor = multiplier1.*sqrt(varWbar(2,:,:)+varWbar(1,:,:));

upper2 = meanDiff2 + diffStdFactor;
lower2 = meanDiff2 - diffStdFactor;

startColInd = 50;
endColInd = 3000;
dispRows = 1:10;
lineWidth=1;
lineWidth2=1;
predColors = {'b' 'r'};
predColors2 = {'c' 'm'};
predColors3 = {'y' 'g'};

goodIndex = zeros(numTrials,numPatches);
goodIndex2 = zeros(numTrials,numPatches); %with diff definition of mean difference
for ii = 1:numTrials
   for jj = 1:numPatches
       curUpperCI = upperConfidence(:,ii,jj);
       curLowerCI = lowerConfidence(:,ii,jj);
       intervalVals = zeros(1,2*numPred);
       [~,sorting] = sort(curLowerCI);
       intervalVals(1:2:end) = curLowerCI(sorting);
       intervalVals(2:2:end) = curUpperCI(sorting);
       goodIndex(ii,jj) = all(diff(intervalVals)>0);
       goodIndex2(ii,jj) = (lower2(1,ii,jj)>0);
   end
end

lowerPredInd = 1; upperPredInd = 2;
lowerPredUpperCIvals = upperConfidence(lowerPredInd,:,:);
upperPredLowerCIvals = lowerConfidence(upperPredInd,:,:);

firstGoodInd = zeros(1,numTrials);
firstGoodInd2 = zeros(1,numTrials);

ciIntersectFirstGoodUpper = zeros(1,numTrials);
ciLowerFirstGood = zeros(1,numTrials);
for ii = 1:numTrials

    %curTrial2 = reshape(goodInds(1,ii,:),[1 numPatches]);
    curTrial3 = goodIndex(ii,startColInd:endColInd);
    curTrial4 = goodIndex2(ii,startColInd:endColInd);
    
    firstGoodInd(ii) = find(curTrial3,1,'first')+startColInd;
    firstGoodInd2(ii) = find(curTrial4,1,'first')+startColInd;
    

    ciIntersectFirstGoodUpper(ii) = upperPredLowerCIvals(1,ii,firstGoodInd(ii));
    ciLowerFirstGood(ii) = lower2(1,ii,firstGoodInd2(ii))+Wvalues(1);
end

%{
minCI = min(reshape(lowerConfidence(:,dispRows,startColInd:endColInd),1,[]));
maxCI = max(reshape(upperConfidence(:,dispRows,startColInd:endColInd),1,[]));

minY = min(reshape(meanWbar(:,dispRows,startColInd:endColInd),1,[]));
maxY = max(reshape(meanWbar(:,dispRows,startColInd:endColInd),1,[]));
%}
margin=20;
figure
title('Estimating Mean using Sampling Without Replacement Results');
hold on
plot(firstGoodInd,ciIntersectFirstGoodUpper,'r.');
plot(firstGoodInd2,ciLowerFirstGood,'kx');
for pp = 1:numPred
    wbarVals = permute(meanWbar(pp,dispRows,:),[3 2 1]);

    if(pp==1)
        plot(max(wbarVals,[],2),[predColors2{pp} '-'],'LineWidth',lineWidth2) 
        plot(Wvalues(pp).*ones(1,numPatches),...
            'k--','LineWidth',lineWidth);
    elseif(pp==2)
        plot(min(wbarVals,[],2),[predColors2{pp} '-'],'LineWidth',lineWidth2) 
        plot(Wvalues(pp).*ones(1,numPatches),...
            'k:','LineWidth',lineWidth);
    end
    
    
end
axis([startColInd endColInd Wvalues(1)-margin Wvalues(2)+margin]);
legend('Potential Stopping Points with nonoverlapping CIs',...
    'Potential Stopping Points with positive CI for mean difference',...
    'Maximal Sample Mean with lower Prediction Value',...
    'Population Mean with lower Prediction Value',...
    'Minimial Sample Mean with upper Prediction Value',...
    'Population Mean with upper Prediction Value');
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
%%

vUpper = [4 6 2];
vLower = [3 5 1];

[~,ii] = sort(vLower);

endPtsTest2 = zeros(1,length(vLower)*2);
endPtsTest2(1:2:end)=vLower(ii);
endPtsTest2(2:2:end)=vUpper(ii);

isGood2 = all(diff(endPtsTest2)>0);
