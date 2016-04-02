%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');


numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = mean(totalWorkEMD,2);
Lpred1 = LvaluesFunc1(1);
Lpred2 = LvaluesFunc1(2);

numTrials = 10;
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

msePatches = zeros(1,numPatches);
sumTarget = zeros(1,numPatches);
sumPred1 = zeros(1,numPatches);
sumPred2 = zeros(1,numPatches);
for k = 1:numPatches
    curTarget = targetPatches{k};
    curPred1 = predPatches{1,k};
    curPred2 = predPatches{1,k};
    sumTarget(k) = sum(curTarget(:));
    sumPred1(k) = sum(curPred1(:));
    sumPred2(k) = sum(curPred2(:));
    msePatches(k) = mean((curTarget(:)-curPred1(:)).^2);
end
plot(msePatches,LkPred1(1,:),'r.');

figure
hold on
plot(sort(log(sumTarget)))
plot(sort(log(sumPred1)))
plot(sort(log(sumPred2)))
hold off
%%
startColInd = 500;
dispRows = 1:10;
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

%{
Taken from the following:
https://en.wikipedia.org/wiki/Standard_error#Standard_error_of_the_mean
%}
pred1sampleStandardDev = std(LkPred1);
pred2sampleStandardDev = std(LkPred2);
SEx_pred1=pred1sampleStandardDev./sqrt(1:numPatches);
SEx_pred2=pred2sampleStandardDev./sqrt(1:numPatches);

figure
hold on
plot(SEx_pred1,'r');
plot(SEx_pred2,'b');
hold off

%%


[orderedVals1,orderedInds1] = sort(LkPred1);
[orderedVals2,orderedInds2] = sort(LkPred2);

numOrd = 2000;
mean1Low = zeros(1,numOrd);
mean1High = zeros(1,numOrd);
mean2Low = zeros(1,numOrd);
mean2High = zeros(1,numOrd);

for NN=1:numOrd

    mean1Low(NN) = mean(orderedVals1(1,1:NN));
    mean1High(NN) = mean(orderedVals1(1,end-NN:end));

    mean2Low(NN) = mean(orderedVals2(1,1:NN));
    mean2High(NN) = mean(orderedVals2(1,end-NN:end));

end

figure
hold on
plot(mean1Low,'r-');
plot(mean1High,'r-');
plot(mean2Low,'b-');
plot(mean2High,'b-');
hold off

%%

%{
Gives bounds to the means
%}

workArray = {WORK1,WORK2};
loopInd = 1;
AlphaVal = 0.05;
displaySpecs = {'r','b'};

meanArray = cell(1,length(workArray));
upperMeanArray = cell(1,length(workArray));
lowerMeanArray = cell(1,length(workArray));

startInd = 100;
indsNumTry = startInd:50:length(WORK1);
indsNumTry = [indsNumTry length(WORK1)];
numTries = length(indsNumTry);

for ii=1:length(workArray)
    
    WORKCURRENT = workArray{ii};
    LOGWORKCURRENT = log(WORKCURRENT);
    

    %numbers of samples that will be tried

    numPerms = 1;
    upperMeanVal = zeros(numPerms,numTries);
    lowerMeanVal = zeros(numPerms,numTries);
    meanCurDist = zeros(numPerms,numTries);

    resInd = 1;


    for j = 1:numPerms
        [orderedWork,inds] = sort(WORKCURRENT);
        resInd = 1;
        for i = indsNumTry
            curDataSet = orderedWork(end-i+1:end);

            [phatCur,pciCur] = mle(curDataSet,'distribution','lognormal','Alpha',AlphaVal);
            sizeVec = pciCur(2,:)-pciCur(1,:);

            muCur = phatCur(1); sigmaCur = phatCur(2);
            muUpper = pciCur(2,1); muLower = pciCur(1,1);
            sigmaUpper = pciCur(2,2); sigmaLower = pciCur(1,2);

            meanCurDist(j,resInd)=exp(muCur + sigmaCur^2/2);
            upperMeanVal(j,resInd) = exp(muUpper + sigmaUpper^2/2);
            lowerMeanVal(j,resInd) = exp(muLower + sigmaLower^2/2);

            resInd = resInd+1;
        end
    end
    
    meanArray{loopInd} = meanCurDist;
    upperMeanArray{loopInd} = upperMeanVal;
    lowerMeanArray{loopInd} = lowerMeanVal;
    
    loopInd = loopInd + 1;
end


figure
hold on
title('Range of expected values for W_1 (blue) and W_2 (red) vs Number of Samples');
for jj = 1:length(meanArray)
    spec1 = [displaySpecs{jj} '-'];
    spec2 = [displaySpecs{jj} '--'];
    
    plot(indsNumTry,meanArray{jj},spec1,'LineWidth',2);
    plot(indsNumTry,lowerMeanArray{jj},spec2);
    plot(indsNumTry,upperMeanArray{jj},spec2);
end
xlabel('Number of Samples used in MLE estimation');
ylabel('Expected Value via MLE parameters');
hold off