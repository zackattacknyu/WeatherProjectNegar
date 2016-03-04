


feaToUse = 1:size(Xtr,2);
[~,XTeOctPct,~] = XToPct(Xtr(:,feaToUse),XteOct(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTeOctPct = uint8(XTeOctPct);


preds = boostTreeVal3(boostStruct,boostArgs.nIter,uint8(XTeOctPct),boostArgs.v);

rmseTestVals = zeros(1,length(preds));
for ii = 1:length(preds)
    curYhat = preds{ii};
    rmseTestVals(ii) = sqrt(mean((curYhat-YteOct).^2));
end

