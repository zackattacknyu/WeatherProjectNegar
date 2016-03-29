
load('Sep2011SetupDataZach_decTreeLinReg.mat','Xtr','Xte','Ytr','Yte');
load('sep2012TestDataSet_every4thT.mat','XteSept','YteSept');
Xtr = [Xtr ones(size(Xtr,1),1)];
Xte = [Xte ones(size(Xte,1),1)];
XteSept = [XteSept ones(size(XteSept,1),1)];



%based on previous graphs, set maxDepth to 5
dd=5;
minPar = 30;
minScore=0.8;

%paramVals = [1000 900 800 700 600 500 450 400 300 250 200 150 100 ...
%    75 60 50 40 20 15 10];
paramVals = 1:20;

trainingRMSEwithLin = zeros(1,length(paramVals));
validRMSEwithLin = zeros(1,length(paramVals));
testRMSEwithLin = zeros(1,length(paramVals));

trainingRMSEconst = zeros(1,length(paramVals));
validRMSEconst = zeros(1,length(paramVals));
testRMSEconst = zeros(1,length(paramVals));

for ind = 1:length(paramVals)
    
    %dd = paramVals(ind);
    minPar = paramVals(ind);
    
    tc = treeRegressWithLinReg(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);
    tc2 = treeRegress(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);


    trainingRMSEwithLin(ind) = rmse(tc,Xtr,Ytr);
    validRMSEwithLin(ind) = rmse(tc,Xte,Yte);
    testRMSEwithLin(ind) = rmse(tc,XteSept,YteSept);

    trainingRMSEconst(ind) = sqrt(mse(tc2,Xtr,Ytr));
    validRMSEconst(ind) = sqrt(mse(tc2,Xte,Yte));
    testRMSEconst(ind) = sqrt(mse(tc2,XteSept,YteSept));
end

save('decTreeWithLinReg_minParentTestRun.mat');
%%


load('decTreeWithLinReg_minParentTestRun.mat');

indsDisp = 1:20;

figure
hold on
plot(paramVals(indsDisp),testRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),testRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Test RMSE vs Min Parent');
xlabel('Min Parent Value');
ylabel('RMSE');

figure
hold on
plot(paramVals(indsDisp),validRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),validRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Validation RMSE vs Min Parent');
xlabel('Min Parent Value');
ylabel('RMSE');

figure
hold on
plot(paramVals(indsDisp),trainingRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),trainingRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Training RMSE vs Min Parent');
xlabel('Min Parent Value');
ylabel('RMSE');

%MINPARENT HAS LITTLE TO NO EFFECT ON RMSE
