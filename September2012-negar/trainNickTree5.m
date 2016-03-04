

[~,XtePct,~] = XToPct(Xtr,Xte,256);
%%
preds = boostTreeVal3(boostStruct,boostArgs.nIter,uint8(XtePct),boostArgs.v);

%%

rmseTestVals = zeros(1,length(preds));
for ii = 1:length(preds)
    curYhat = preds{ii};
    rmseTestVals(ii) = sqrt(mean((curYhat-Yte).^2));
end


