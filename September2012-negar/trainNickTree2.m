load('tc_negar_nickJ128rf8_dataForTest.mat');
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);
 %{
%boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5; 
rf = 0.8; J = 32;
boostArgs.funargs = {rf J};

boostArgs.nIter = 300;
boostArgs.evaliter = 1:boostArgs.nIter;
totalTreesToTrain = 100;

for i = 1:totalTreesToTrain
    i
    
   fileStr = ['tc_NickJ32rf8_iter400_tree' num2str(i) '.mat'];

    
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);

    save(fileStr,'perfTrain','perfTest','boostStruct','boostArgs')
end
%}
boostArgs.v = 0.5; 
rf = 0.8; J = 128;
boostArgs.funargs = {rf J};

boostArgs.nIter = 100;
boostArgs.evaliter = 1:boostArgs.nIter;
totalTreesToTrain = 30;

for i = 1:totalTreesToTrain
    i
    
   fileStr = ['tc_NickJ128rf8_iter400_tree' num2str(i) '.mat'];

    
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);

    save(fileStr,'perfTrain','perfTest','boostStruct','boostArgs')
end
