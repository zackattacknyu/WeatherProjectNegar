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
startInd = 10;
numTries = (length(WORK1)-startInd);
muIntervalSize = zeros(1,numTries);
sigmaIntervalSize = zeros(1,numTries);
meanDiff = zeros(1,numTries);
sigmaDiff = zeros(1,numTries);
inds = randperm(length(WORK1));
resInd = 1;
for i = startInd:length(WORK1)
    curDataSet = WORK1(inds(1:i));
    [phatCur,pciCur] = mle(curDataSet,'distribution','lognormal');
    sizeVec = pciCur(2,:)-pciCur(1,:);
    muIntervalSize(resInd) = sizeVec(1);
    sigmaIntervalSize(resInd) = sizeVec(2);
    meanDiff(resInd) = abs(phatML(1)-phatCur(1));
    sigmaDiff(resInd) = abs(phatML(2)-phatCur(2));
    resInd = resInd+1;
end

figure
plot(startInd:length(WORK1),muIntervalSize);

figure
plot(startInd:length(WORK1),sigmaIntervalSize);

figure
plot(startInd:length(WORK1),meanDiff);

figure
plot(startInd:length(WORK1),sigmaDiff);