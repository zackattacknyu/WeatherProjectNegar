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
[phatML,pciML] = mle(LOGWORK1)
%%
startInd = 1000;
numTries = (length(LOGWORK1)-startInd);
muVals = zeros(1,numTries);
sigmaVals = zeros(1,numTries);
muValsUpperBound = zeros(1,numTries);
muValsLowerBound = zeros(1,numTries);
sigmaValsUpperBound = zeros(1,numTries);
sigmaValsLowerBound = zeros(1,numTries);
logLikelihood = zeros(1,numTries);
inds = randperm(length(LOGWORK1));
resInd = 1;
for i = startInd:length(LOGWORK1)
    curDataSet = LOGWORK1(inds(1:i));
    [phatML,pciML] = mle(curDataSet);
    muValsUpperBound(resInd) = pciML(2,1);
    muValsLowerBound(resInd) = pciML(1,1);
    sigmaValsUpperBound(resInd) = pciML(2,2);
    sigmaValsLowerBound(resInd) = pciML(1,2);
    muVals(resInd) = phatML(1);
    sigmaVals(resInd) = phatML(2);
    logLikelihood(resInd) = normlike(phatML,LOGWORK1);
    resInd = resInd+1;
end

figure
hold on
plot(startInd:length(LOGWORK1),muVals)
plot(startInd:length(LOGWORK1),muValsUpperBound,'r--')
plot(startInd:length(LOGWORK1),muValsLowerBound,'g--')
hold off
%%
figure
hold on
plot(startInd:length(LOGWORK1),sigmaVals)
plot(startInd:length(LOGWORK1),sigmaValsUpperBound,'r--')
plot(startInd:length(LOGWORK1),sigmaValsLowerBound,'g--')
hold off
%%
figure
plot(startInd:length(LOGWORK1),logLikelihood)

%%
mu = phatML(1);
sigma = phatML(2);
figure
hold on
plot(xx,normcdf(xx,mu,sigma),'r-')
plot(LOGWORK1,cdfVals,'b--');
hold off

%%
%gaussian function
xmin = min(LOGWORK1);
xmax = max(LOGWORK1);
%xx = linspace(xmin,xmax,length(LOGWORK1));
xx = LOGWORK1;
yy1 = normpdf(xx,mu,sigma);
yy2 = exp(xx).*yy1;
intVal = trapz(xx,yy2)
indsRand = randperm(length(WORK1));
indsUse = indsRand(1:500);
meanWorkEst = mean(WORK1(indsUse))
meanWork = mean(WORK1)








