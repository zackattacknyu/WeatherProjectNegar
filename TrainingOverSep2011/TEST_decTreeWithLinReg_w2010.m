%%

load('Sep2010PrepData.mat','FDATA');

randInds = randperm(size(FDATA,1));
ratio = 0.95;
numDataPoints = ceil(ratio*size(FDATA,1));
indsUse = randInds(1:numDataPoints);

X = FDATA(indsUse,1:13);
Y = FDATA(indsUse,14);

[x y] = shuffleData(X,Y);

[Xtr Xte Ytr Yte] = splitData(x,y,0.8);

save('Sep2010SetupData.mat');
%%

data2010 = load('Sep2010SetupData.mat','Xtr','Xte','Ytr','Yte');
data2011 = load('Sep2011SetupDataZach_decTreeLinReg.mat','Xtr','Xte','Ytr','Yte');
load('sep2012TestDataSet_every4thT.mat','XteSept','YteSept');

Xtr1 = data2010.Xtr;
Xtr2 = data2011.Xtr;

Xte1 = data2010.Xte;
Xte2 = data2011.Xte;

Ytr1 = data2010.Ytr;
Ytr2 = data2011.Ytr;

Yte1 = data2010.Yte;
Yte2 = data2011.Yte;

Xtr = [Xtr1;Xtr2];
Xte = [Xte1;Xte2];

Ytr = [Ytr1;Ytr2];
Yte = [Yte1;Yte2];

Xtr = [Xtr ones(size(Xtr,1),1)];
Xte = [Xte ones(size(Xte,1),1)];
XteSept = [XteSept ones(size(XteSept,1),1)];


%%
%based on previous graphs, set maxDepth to 5
dd=5;
minPar = 100;
minScore=2;

paramVals = [1 2 3 5 6 7];

trainingRMSEwithLin = zeros(1,length(paramVals));
validRMSEwithLin = zeros(1,length(paramVals));
testRMSEwithLin = zeros(1,length(paramVals));

trainingRMSEconst = zeros(1,length(paramVals));
validRMSEconst = zeros(1,length(paramVals));
testRMSEconst = zeros(1,length(paramVals));

for ind = 1:length(paramVals)
    
    dd = paramVals(ind);
    dd
    %minPar = paramVals(ind);
    %minScore = paramVals(ind);
    
    tc = treeRegressWithLinReg(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);
    tc2 = treeRegress(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);


    trainingRMSEwithLin(ind) = rmse(tc,Xtr,Ytr);
    validRMSEwithLin(ind) = rmse(tc,Xte,Yte);
    testRMSEwithLin(ind) = rmse(tc,XteSept,YteSept);

    trainingRMSEconst(ind) = sqrt(mse(tc2,Xtr,Ytr));
    validRMSEconst(ind) = sqrt(mse(tc2,Xte,Yte));
    testRMSEconst(ind) = sqrt(mse(tc2,XteSept,YteSept));
end

save('decTreeWithLinReg_maxDepthTestRun2.mat');
%%
load('decTreeWithLinReg_maxDepthTestRun2.mat');
%load('decTreeWithLinReg_minScoreTestRun.mat');
%%
indsDisp = 1:length(paramVals);
%load('regressionData_3-23.mat','rmseMultipleLinear');
figure
hold on
plot(paramVals(indsDisp),testRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),testRMSEconst(indsDisp),'g--');
%plot(paramVals(indsDisp),rmseMultipleLinear.*ones(size(indsDisp)),'b:','LineWidth',2)
legend('With Linear Regression','Without Linear Regression');
hold off
title('Test RMSE vs Max Depth');
xlabel('Max Depth Value');
ylabel('RMSE');

figure
hold on
plot(paramVals(indsDisp),validRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),validRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Validation RMSE vs Max Depth');
xlabel('Max Depth Value');
ylabel('RMSE');

figure
hold on
plot(paramVals(indsDisp),trainingRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),trainingRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Training RMSE vs Max Depth');
xlabel('Max Depth Value');
ylabel('RMSE');

%IDEAL MIN SCORE IS 0.8 FROM THESE TESTS

