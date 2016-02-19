load('tc.mat');
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);
boostArgs.nIter = 1000;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5; 
%%
Jvals = 2.^(7:9);
rfVals = [0.8 0.9 1];
[jj,rff] = meshgrid(Jvals,rfVals);
jUse = jj(:); rfUse = rff(:);

testRMSEvals = zeros(length(jUse));
totalRuntimes = zeros(length(jUse));
for i = 1:length(jUse)
   J = jUse(i);
   rf = rfUse(i);
   fileStr = ['tc_NickDecTreeResult_J' num2str(J) 'rf' num2str(rf*10) '.mat'];
   
   t1 = clock;
    boostArgs.funargs = {rf J};
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSEvals(i) = boostStruct.perfTest(end).rmse;
    t2 = clock;
    numSeconds = etime(t2,t1);
    totalRuntimes(i) = numSeconds;
    save(fileStr)
end

save('tc_NickDecTreeTestResults.mat','totalRuntimes','testRMSEvals','jUse','rfUse');



