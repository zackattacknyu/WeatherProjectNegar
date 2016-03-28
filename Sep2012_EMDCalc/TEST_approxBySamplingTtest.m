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

%[phatML,pciML] = mle(LOGWORK1)
%%
startInd = 1000;
numTries = (length(LOGWORK1)-startInd);
meanVals = zeros(1,numTries);
inds = randperm(length(LOGWORK1));
resInd = 1;
for i = startInd:length(LOGWORK1)
    curDataSet = LOGWORK1(inds(1:i));
    meanVals(resInd) = mean(exp(curDataSet));
    resInd = resInd+1;
end


figure
plot(startInd:length(LOGWORK1),meanVals)
%%
xmin = min(LOGWORK1);
xmax = max(LOGWORK1);
xx = linspace(xmin,xmax,length(LOGWORK1));

figure
hold on
plot(LOGWORK1,tpdf(LOGWORK1,1000),'r-')
plot(LOGWORK1,tpdf(LOGWORK1,20),'g-')
plot(LOGWORK1,tpdf(LOGWORK1,5000),'b-')
hold off

%{
TODO: USE THE T-DISTRIBUTION TO FIND OUT WHAT
SAMPLING ERROR WE CAN EXPECT

MIGHT ALSO WANT TO USE CHI SQUARED DISTRIBUTION
%}








