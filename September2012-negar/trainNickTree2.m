load('tc_negar_nickJ128rf8_dataForTest.mat');
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);
 
%boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5; 
rf = 0.8; J = 128;
boostArgs.funargs = {rf J};

iterVals = [120 130 133 140 150 160];

testRMSEvals = zeros(length(iterVals));
totalRuntimes = zeros(length(iterVals));

for i = 1:length(iterVals)
    i
    boostArgs.nIter = iterVals(i);
    boostArgs.evaliter = 1:boostArgs.nIter;
   fileStr = ['tc_NickJ128rf8_iter' num2str(iterVals(i)) '.mat'];
   
   t1 = clock;
    
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSEvals(i) = boostStruct.perfTest(end).rmse;
    t2 = clock;
    numSeconds = etime(t2,t1);
    totalRuntimes(i) = numSeconds;
    save(fileStr)
end

save('tc_NickDecTreeTestResults3.mat','totalRuntimes',...
    'testRMSEvals','iterVals');

%%

boostRMSEvals = zeros(1,length(boostStruct.perfTest));
for i = 1:length(boostStruct.perfTest)
    boostRMSEvals(i) = boostStruct.perfTest(i).rmse;
end
plot(boostRMSEvals)
[minRMSE,numIterAtMin] = min(boostRMSEvals)

%IDEAL NUMBER OF ITERATIONS IS ABOUT 140