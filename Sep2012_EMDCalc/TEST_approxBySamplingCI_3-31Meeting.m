%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');

numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = sum(totalWorkEMD,2);

WORK1 = sort(totalWorkEMD(1,:));
WORK2 = sort(totalWorkEMD(2,:));

LOGWORK1 = sort(log(totalWorkEMD(1,:)));
LOGWORK2 = sort(log(totalWorkEMD(2,:)));

INDS = 1:length(LOGWORK1);
cdfVals = INDS./length(LOGWORK1);
%%
%{
SHOW IHLER THESE RESULTS
%}

[phatML,pciML] = mle(WORK1,'distribution','lognormal');

mu = phatML(1);
sigma = phatML(2);
yFit = normcdf(LOGWORK1,mu,sigma);
figure
hold on
plot(LOGWORK1,cdfVals,'r-','LineWidth',2);
plot(LOGWORK1,yFit,'g-','LineWidth',2)
title('Cumulative Distribution of V = log(W) values');
xlabel('V');
ylabel('P( V <= v )')
legend('CDF for Original Data','CDF from MLE parameters');
hold off

rmseFit = sqrt(mean((yFit-cdfVals).^2))
nLogLike = normlike(phatML,LOGWORK1)/length(LOGWORK1)

%%
%numbers of samples that will be tried
startInd = 100;
indsNumTry = startInd:400:length(WORK1);
numTries = length(indsNumTry);
numPerms = 1;
upperMeanVal = zeros(numPerms,numTries);
lowerMeanVal = zeros(numPerms,numTries);
meanCurDist = zeros(numPerms,numTries);

resInd = 1;

for j = 1:numPerms
    inds = randperm(length(WORK1));
    resInd = 1;
    for i = indsNumTry
        curDataSet = WORK1(inds(1:i));

        [phatCur,pciCur] = mle(curDataSet,'distribution','lognormal');
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

%%

errorbar(indsNumTry,meanCurDist,lowerMeanVal,upperMeanVal);

%%

figure
hold on
for j= 1:numPerms
    plot(indsNumTry,nllValuesFinalDist(j,:),'r-');
    plot(indsNumTry,nllValuesCurDist(j,:),'b-');
end
legend('Final Distribution','Current Distribution');
hold off


figure
hold on
for j = 1:numPerms
    plot(indsNumTry,muIntervalSize(j,:));
end
hold off

figure
hold on
for j = 1:numPerms
    plot(indsNumTry,sigmaIntervalSize(j,:));
end
hold off

figure
hold on
for j = 1:numPerms
    plot(indsNumTry,meanDiff(j,:));
end
hold off

figure
hold on
for j = 1:numPerms
    plot(indsNumTry,sigmaDiff(j,:));
end
hold off