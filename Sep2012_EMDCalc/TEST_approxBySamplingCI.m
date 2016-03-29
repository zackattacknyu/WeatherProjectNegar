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
[phatML,pciML] = mle(LOGWORK1);

mu=phatML(1);
sigma = phatML(2);
startInd = 10;
numTries = (length(LOGWORK1)-startInd);
muIntervalSize = zeros(1,numTries);
sigmaIntervalSize = zeros(1,numTries);
meanDiff = zeros(1,numTries);
sigmaDiff = zeros(1,numTries);
ztestVals = ones(1,numTries);
hValues = zeros(1,numTries);
inds = randperm(length(LOGWORK1));
resInd = 1;
for i = startInd:length(LOGWORK1)
    curDataSet = LOGWORK1(inds(1:i));
    [phatCur,pciCur] = mle(curDataSet);
    sizeVec = pciCur(2,:)-pciCur(1,:);
    muIntervalSize(resInd) = sizeVec(1);
    sigmaIntervalSize(resInd) = sizeVec(2);
    meanDiff(resInd) = abs(phatML(1)-phatCur(1));
    sigmaDiff(resInd) = abs(phatML(2)-phatCur(2));
    resInd = resInd+1;
end

figure
plot(startInd:length(LOGWORK1),muIntervalSize);

figure
plot(startInd:length(LOGWORK1),sigmaIntervalSize);

figure
plot(startInd:length(LOGWORK1),meanDiff);

figure
plot(startInd:length(LOGWORK1),sigmaDiff);

%%

%{
SHOW IHLER THESE RESULTS
%}

[phatML,pciML] = mle(WORK1,'distribution','lognormal');

mu=phatML(1);
sigma = phatML(2);

%numbers of samples that will be tried
startInd = 1500;
indsNumTry = startInd:100:length(WORK1);
%%
numTries = length(indsNumTry);
numPerms = 10;
muIntervalSize = zeros(numPerms,numTries);
sigmaIntervalSize = zeros(numPerms,numTries);
nllValuesFinalDist = zeros(numPerms,numTries);
nllValuesCurDist = zeros(numPerms,numTries);
rangeValues = zeros(numPerms,numTries);
meanDiff = zeros(numPerms,numTries);
sigmaDiff = zeros(numPerms,numTries);
meanCurData = zeros(numPerms,numTries);

resInd = 1;

for j = 1:numPerms
    inds = randperm(length(WORK1));
    resInd = 1;
    for i = indsNumTry
        curDataSet = WORK1(inds(1:i));
        
        meanCurData(j,resInd)=mean(log(curDataSet));
        
        [phatCur,pciCur] = mle(curDataSet,'distribution','lognormal');
        sizeVec = pciCur(2,:)-pciCur(1,:);

        nllValuesFinalDist(j,resInd) = normlike(phatML,log(curDataSet))/i;
        nllValuesCurDist(j,resInd) = normlike(phatCur,log(curDataSet))/i;
        
        muUpper = pciCur(2,1); muLower = pciCur(1,1);
        sigmaUpper = pciCur(2,2); sigmaLower = pciCur(1,2);
        meanUpper = exp(muUpper + sigmaUpper^2/2);
        meanLower = exp(muLower + sigmaLower^2/2);
        rangeValues(j,resInd)=meanUpper-meanLower;

        muIntervalSize(j,resInd) = sizeVec(1);
        sigmaIntervalSize(j,resInd) = sizeVec(2);

        meanDiff(j,resInd) = abs(phatML(1)-phatCur(1));
        sigmaDiff(j,resInd) = abs(phatML(2)-phatCur(2));

        resInd = resInd+1;
    end
end
%%
%expVal = exp(mu+sigma^2/2);
figure
hold on
for j = 1:numPerms
    curZscores = (meanCurData(j,:)-mu)/sigma;
    plot(indsNumTry,curZscores);
end
plot(indsNumTry,zeros(size(indsNumTry)),'k--','LineWidth',2);
hold off
%%

figure
hold on
for j= 1:numPerms
    plot(indsNumTry,rangeValues(j,:));
end
hold off

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