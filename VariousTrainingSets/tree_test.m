

clear all
close all

load('prepdata.mat')

X = FDATA(:,1:13);
Y = FDATA(:,14);

[x y] = shuffleData(X,Y);

[Xtr Xte Ytr Yte] = splitData(x,y,0.8);

%for d = 1:100
    
    d = 23

tc = treeRegress(Xtr,Ytr,0,d,-1,inf);

err(d) = mse(tc,Xte,Yte);


%end