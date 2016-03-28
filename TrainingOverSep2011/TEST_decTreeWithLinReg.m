


load('Sep2011PrepData_FDATA_arrayOnly.mat','FDATA');

randInds = randperm(size(FDATA,1));
ratio = 0.25;
numDataPoints = ceil(ratio*size(FDATA,1));
indsUse = randInds(1:numDataPoints);

X = FDATA(indsUse,1:13);
Y = FDATA(indsUse,14);

[x y] = shuffleData(X,Y);

[Xtr Xte Ytr Yte] = splitData(x,y,0.8);

save('Sep2011SetupDataZach_decTreeLinReg.mat');
%%
load('Sep2011SetupDataZach_decTreeLinReg.mat','Xtr','Xte','Ytr','Yte');
load('sep2012TestDataSet_every4thT.mat','XteSept','YteSept');
Xtr = [Xtr ones(size(Xtr,1),1)];
Xte = [Xte ones(size(Xte,1),1)];
XteSept = [XteSept ones(size(XteSept,1),1)];

d=15;
minPar = 30;
minScore=0.5;

maxDepthVals = 1:20;

trainingRMSEwithLin = zeros(1,length(maxDepthVals));
validRMSEwithLin = zeros(1,length(maxDepthVals));
testRMSEwithLin = zeros(1,length(maxDepthVals));

trainingRMSEconst = zeros(1,length(maxDepthVals));
validRMSEconst = zeros(1,length(maxDepthVals));
testRMSEconst = zeros(1,length(maxDepthVals));

for ind = 1:length(maxDepthVals)
    
    dd = maxDepthVals(ind);
    
    tc = treeRegressWithLinReg(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);
    tc2 = treeRegress(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);


    trainingRMSEwithLin(ind) = rmse(tc,Xtr,Ytr);
    validRMSEwithLin(ind) = rmse(tc,Xte,Yte);
    testRMSEwithLin(ind) = rmse(tc,XteSept,YteSept);

    trainingRMSEconst(ind) = sqrt(mse(tc2,Xtr,Ytr));
    validRMSEconst(ind) = sqrt(mse(tc2,Xte,Yte));
    testRMSEconst(ind) = sqrt(mse(tc2,XteSept,YteSept));
end
%%

figure
hold on
plot(maxDepthVals,testRMSEwithLin);
plot(maxDepthVals,testRMSEconst);
legend('With Linear Regression','Without Linear Regression');
hold off

figure
hold on
plot(maxDepthVals,validRMSEwithLin);
plot(maxDepthVals,validRMSEconst);
legend('With Linear Regression','Without Linear Regression');
hold off

figure
hold on
plot(maxDepthVals,trainingRMSEwithLin);
plot(maxDepthVals,trainingRMSEconst);
legend('With Linear Regression','Without Linear Regression');
hold off
%%
save('decTreeWithLinReg_testRunData.mat')
