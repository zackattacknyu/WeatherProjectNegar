


%load('prepdata.mat')
load('Sep2011PrepData.mat','FDATA');

X = FDATA(:,1:13);
Y = FDATA(:,14);

[Nx,Mx] = size(X);
pi = randperm(Nx);

save('Sep2011SetupData_randOrdering.mat','pi');
%for d = 1:100
    
    %d = 23

%tc = treeRegress(Xtr,Ytr,0,d,-1,inf);
