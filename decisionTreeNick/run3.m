feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);

rf = 0.1; J = 4; % J is number of leaf nodes in tree, rf is "random forest" parameter - # random features to choose at each iter
boostArgs.nIter = 1000;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.1;     
boostArgs.funargs = {rf J};
%%
[perfTrain,perfTest,boostStruct] = ...
    BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);

%%
trainF = boostStruct.F;
funF = boostTreeVal2(boostStruct,boostArgs.nIter,XTrPct,boostArgs.v);

%%

%Jvals = [2 4 8 16 32 64];
Jvals = [128 256 512 1024 2048];
testRMSE = zeros(1,length(Jvals));
rf = 0.1;
boostArgs.nIter = 400;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.1;     
for jj = 1:length(Jvals)
    J = Jvals(jj);
    J
    boostArgs.funargs = {rf J};
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSE(jj) = boostStruct.perfTest(end).rmse;
end
%%
J = 64;
boostArgs.v = 0.1;
rfVals = [0.1 0.2 0.25 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
testRMSErf = zeros(1,length(rfVals));
boostArgs.nIter = 300;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
for jj = 1:length(rfVals)
    rf = rfVals(jj);
    rf
    boostArgs.funargs = {rf J};
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSErf(jj) = boostStruct.perfTest(end).rmse;
end

J = 64;
vVals = [0.1 0.2 0.25 0.4 0.5 0.7 0.9 0.8 1.0 1.25 1.5 1.75 2.0];
testRMSEv = zeros(1,length(vVals));
rf = 0.1;
boostArgs.nIter = 300;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.funargs = {rf J};
for jj = 1:length(vVals)
    boostArgs.v = vVals(jj);     
    boostArgs.v
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSEv(jj) = boostStruct.perfTest(end).rmse;
end
%%

figure 
plot(rfVals,testRMSErf);

figure
plot(vVals,testRMSEv);





