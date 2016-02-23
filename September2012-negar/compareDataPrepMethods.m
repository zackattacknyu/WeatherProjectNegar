fprintf('Loading...\n');
load('tc_NickJ128rf8_iter5.mat');

fprintf('Converting Data...\n');
[~,XtePct,~] = XToPct(X,Xte,256);
[~,XtePct2,~] = XToPct(Xtr,Xte,256);

fprintf('evaluating Tree with Data binned by whole set...\n');
yhat1 = boostTreeVal2(boostStruct,boostArgs.nIter,uint8(XtePct),boostArgs.v);
fprintf('Done evaluating\n');
rmse1 = sqrt(mean((yhat1-boostStruct.FTest).^2))
mae1 = mean(abs(yhat1-boostStruct.FTest))

fprintf('evaluating Tree with Data binned by training set...\n');
yhat2 = boostTreeVal2(boostStruct,boostArgs.nIter,uint8(XtePct2),boostArgs.v);
fprintf('Done evaluating\n');
rmse2 = sqrt(mean((yhat2-boostStruct.FTest).^2))
mae2 = mean(abs(yhat2-boostStruct.FTest))

%MUST USE TRAINING SET FOR BINNING
     
fprintf('all evaluating done\n');