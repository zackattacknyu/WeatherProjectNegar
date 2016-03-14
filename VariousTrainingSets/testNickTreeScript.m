


feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,~] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
[~,XTeOctPct,~] = XToPct(Xtr(:,feaToUse),XteOct(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTeOctPct = uint8(XTeOctPct);


rmseTestVals = boostTreeVal4(boostStruct,boostArgs.nIter,uint8(XTeOctPct),boostArgs.v,YteOct);


