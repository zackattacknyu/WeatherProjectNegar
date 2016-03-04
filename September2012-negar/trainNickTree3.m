load('tc.mat');
%%
load('oct2012TestDataSetAll.mat');
%%
%XteAll = [Xte;XteOct];
%YteAll = [Yte;YteOct];



feaToUse = 1:size(Xtr,2);
[~,XTeOctPct,~] = XToPct(Xtr(:,feaToUse),XteOct(:,feaToUse), 256);
[XTrPct,XTePct,~] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTeOctPct = uint8(XTeOctPct);
XTePct = uint8(XTePct);
 
%boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5; 
rf = 0.8; J = 128;
boostArgs.funargs = {rf J};

boostArgs.nIter = 5;
boostArgs.evaliter = 1:boostArgs.nIter;

%{
[~,~,boostStruct] = ...
    BoostLS(XTrPct, Ytr, XTeAllPct, YteAll, @boostTreeFun, boostArgs, [], []);
%}

[~,~,boostStruct2] = ...
    BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);

%{
boostRMSEvals = zeros(1,length(boostStruct.perfTest));
for i = 1:length(boostStruct.perfTest)
    boostRMSEvals(i) = boostStruct.perfTest(i).rmse;
end
plot(boostRMSEvals)
[minRMSE,numIterAtMin] = min(boostRMSEvals)
%}
  
[~,XtePct,~] = XToPct(Xtr,XteOct,256);

YteOther = boostTreeVal2(boostStruct2,boostArgs.nIter,uint8(XTeOctPct),boostArgs.v);
%YteOther2 = boostTreeVal2(boostStruct2,boostArgs.nIter,uint8(XtePct),boostArgs.v);

rmseTest2 = sqrt(mean((YteOther-YteOct).^2))
%%

[~,XtePct,~] = XToPct(Xtr,Xte,256);
%%
preds = boostTreeVal3(boostStruct,boostArgs.nIter,uint8(XtePct),boostArgs.v);

%%

rmseTestVals = zeros(1,nn);
for ii = 1:length(preds)
    curYhat = preds{ii};
    rmseTestVals(ii) = sqrt(mean((curYhat-Yte).^2));
end

%%

save('boostValTest1_predsVars.mat','preds','-v7.3');

