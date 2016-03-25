


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
%for d = 1:100
    
    %d = 23

%tc = treeRegress(Xtr,Ytr,0,d,-1,inf);
