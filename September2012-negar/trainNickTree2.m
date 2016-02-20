load('tc.mat');
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);
 
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5; 
rf = 0.8; J = 128;
boostArgs.funargs = {rf J};

iterVals = [1 5 10 20 50 100 200 500 700 800 1000];

testRMSEvals = zeros(length(iterVals));
totalRuntimes = zeros(length(iterVals));

save('tmpPreLoopValues.mat');
save('tmpResults.mat','testRMSEvals','totalRuntimes');

for i = 1:length(iterVals)
    load('tmpPreLoopValues.mat');
    load('tmpResults.mat');
    boostArgs.nIter = iterVals(i);
   fileStr = ['tc_NickJ128rf8_iter' num2str(iterVals(i)) '.mat'];
   
   t1 = clock;
    
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSEvals(i) = boostStruct.perfTest(end).rmse;
    t2 = clock;
    numSeconds = etime(t2,t1);
    totalRuntimes(i) = numSeconds;
    save('tmpResults.mat','testRMSEvals','totalRuntimes');
    save(fileStr)
    clear all;
end

save('tc_NickDecTreeTestResults2.mat','totalRuntimes',...
    'testRMSEvals','iterVals');



