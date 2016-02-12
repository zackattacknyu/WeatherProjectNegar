%feaToUse = [1:6 23+(1:6)];%1:6;
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);
rf = 1; J=4; % J is number of leaf nodes in tree, rf is "random forest" parameter - # random features to choose at each iter
%boostArgs.nIter = 1000;  
boostArgs.nIter = 1000; 
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.1;     boostArgs.funargs = {rf J};
%boostStruct=[];
[boostStruct,F,FTest] = BoostLS2(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);