load('tc.mat');
load('oct2012TestDataSetAll.mat');
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePctOct12,binLocs] = XToPct(Xtr(:,feaToUse),XteOct(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePctOct12 = uint8(XTePctOct12);
 
%boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5; 
rf = 0.8; J = 128;
boostArgs.funargs = {rf J};

boostArgs.nIter = 1000;
boostArgs.evaliter = 1:boostArgs.nIter;

[perfTrain,perfTest,boostStruct] = ...
    BoostLS(XTrPct, Ytr, XTePctOct12, YteOct, @boostTreeFun, boostArgs, [], []);

boostRMSEvals = zeros(1,length(boostStruct.perfTest));
for i = 1:length(boostStruct.perfTest)
    boostRMSEvals(i) = boostStruct.perfTest(i).rmse;
end
plot(boostRMSEvals)
[minRMSE,numIterAtMin] = min(boostRMSEvals)

save('oct2012ValidationSetRun.mat');

