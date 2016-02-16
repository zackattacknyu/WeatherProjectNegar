%{
From testing, I found the following:
Optimal J=128
v = 0.5
rf = 0.9
%}

feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);

tic
rf = 0.9; J = 128; % J is number of leaf nodes in tree, rf is "random forest" parameter - # random features to choose at each iter
boostArgs.nIter = 1000;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5;     
boostArgs.funargs = {rf J};

[perfTrain,perfTest,boostStruct] = ...
    BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
J
save('tc_J128result.mat');
toc

tic
rf = 0.9; J = 128; % J is number of leaf nodes in tree, rf is "random forest" parameter - # random features to choose at each iter
boostArgs.nIter = 1000;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5;     
boostArgs.funargs = {rf J};
[perfTrain,perfTest,boostStruct] = ...
    BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
J
save('tc_J256result.mat');
toc