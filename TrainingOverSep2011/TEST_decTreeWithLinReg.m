


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
%%
d=4;

tc = treeRegressWithLinReg(Xtr,Ytr,'maxdepth',d,'minparent',50,'minscore',1);
tc2 = treeRegress(Xtr,Ytr,'maxdepth',d,'minparent',50,'minscore',1);

trainingRMSE = rmse(tc,Xtr,Ytr);
validRMSE = rmse(tc,Xte,Yte);
testRMSE = rmse(tc,XteSept,YteSept);

trainingRMSE2 = sqrt(mse(tc2,Xtr,Ytr));
validRMSE2 = sqrt(mse(tc2,Xte,Yte));
testRMSE2 = sqrt(mse(tc2,XteSept,YteSept));