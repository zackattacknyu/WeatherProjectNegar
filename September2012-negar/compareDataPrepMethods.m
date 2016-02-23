
load('tc_NickJ128rf8_iter5.mat');

[~,XtePct,~] = XToPct(Xte,Xte,256);
[~,XtePct2,~] = XToPct(X,Xte,256);
yhat1 = boostTreeVal2(boostStruct,boostArgs.nIter,uint8(XtePct),boostArgs.v);
yhat2 = boostTreeVal2(boostStruct,boostArgs.nIter,uint8(XtePct2),boostArgs.v);
yhat3 = boostTreeVal2(boostStruct,boostArgs.nIter,uint8(Xte),boostArgs.v);

diff12 = sum(abs(yhat1-yhat2))
diff13 = sum(abs(yhat1-yhat3))
diff23 = sum(abs(yhat2-yhat3))

save('compareDataPrepRes.mat','yhat1','yhat2','yhat3','diff12','diff13','diff23');
     
