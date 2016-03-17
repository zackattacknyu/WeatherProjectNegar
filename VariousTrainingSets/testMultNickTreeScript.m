numToUse = 9;
numTotalTrees = 9;
treeNums = randperm(numTotalTrees);
boostStructArray = cell(1,numToUse);

rfVal = 5;

for ii = 1:numToUse
   curFile = ['SepOct2012Training_J' num2str(JVALUE) 'rf' num2str(rfVal) '_tree' num2str(treeNums(ii)) '.mat'];
   curFile
   curData = load(curFile,'boostStruct','boostArgs');
   boostStructArray{ii} = curData.boostStruct;
end


feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,~] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
[~,XTeOctPct,~] = XToPct(Xtr(:,feaToUse),XteOct(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTeOctPct = uint8(XTeOctPct);

boostArgs = curData.boostArgs;
rmseTestVals = boostTreeVal5(boostStructArray,boostArgs.nIter,...
        uint8(XTeOctPct),boostArgs.v,YteOct,1:length(YteOct));
