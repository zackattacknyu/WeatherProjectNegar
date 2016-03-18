


feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,~] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
[~,XTeSeptPct,~] = XToPct(Xtr(:,feaToUse),XteSept(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTeSeptPct = uint8(XTeSeptPct);


rmseTestVals = boostTreeVal4(boostStruct,boostArgs.nIter,uint8(XTeSeptPct),boostArgs.v,YteSept);


