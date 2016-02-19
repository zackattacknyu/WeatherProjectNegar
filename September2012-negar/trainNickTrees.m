load('tc.mat');

Jvals = 2.^(8:10);
rfVals = [0.8 0.9 1];
[jj,rff] = meshgrid(Jvals,rfVals);
jUse = jj(:); rfUse = rff(:);

for i = 1:length(jUse)
   J = jUse(i)
   rf = rfUse(i)
end


feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);
%%
rf = 0.1; J = 4; % J is number of leaf nodes in tree, rf is "random forest" parameter - # random features to choose at each iter
boostArgs.nIter = 1000;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.1;     
boostArgs.funargs = {rf J};
%%
[perfTrain,perfTest,boostStruct] = ...
    BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);

%%
trainF = boostStruct.F;
funF = boostTreeVal2(boostStruct,boostArgs.nIter,XTrPct,boostArgs.v);

%%

Jvals = 2.^(1:15);
%testRMSEj = zeros(1,length(Jvals));
%totalRuntimes = zeros(1,length(Jvals));
rf = 0.4;
boostArgs.nIter = 800;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.v = 0.5;     
for jj = 11:length(Jvals)
    t1 = clock;
    J = Jvals(jj);
    J
    boostArgs.funargs = {rf J};
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSEj(jj) = boostStruct.perfTest(end).rmse;
    t2 = clock;
    numSeconds = etime(t2,t1)
    totalRuntimes(jj) = numSeconds;
    save('tc_jValsTimeTest_current.mat')
end

save('tc_jValsTimeTest.mat');
%%


xx = Jvals(1:10);
yy = totalRuntimes(1:10);
coeffs = polyfit(xx,yy,1);
aa = coeffs(1); bb = coeffs(2);
yy2 = aa.*xx + bb;

figure;
hold on
plot(xx,yy,'b-');
plot(xx,yy2,'r-');
hold off

%{
A is approximately 8 seconds
B is abbroximately 15 minutes

So it takes at least 22 minutes to do 800 iterations 
    and each leaf node adds 7 seconds to total run time

At the low end, it takes a shorter time

testRMSEj was minimized at J=2^5, so we will stick with that

%}

%%
J = 64;
boostArgs.v = 0.1;
rfVals = [0.1 0.2 0.25 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
testRMSErf = zeros(1,length(rfVals));
boostArgs.nIter = 300;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
for jj = 1:length(rfVals)
    rf = rfVals(jj);
    rf
    boostArgs.funargs = {rf J};
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSErf(jj) = boostStruct.perfTest(end).rmse;
end

J = 64;
vVals = [0.1 0.2 0.25 0.4 0.5 0.7 0.9 0.8 1.0 1.25 1.5 1.75 2.0];
testRMSEv = zeros(1,length(vVals));
rf = 0.1;
boostArgs.nIter = 300;  
boostArgs.evaliter = unique([1:10:boostArgs.nIter boostArgs.nIter]);
boostArgs.funargs = {rf J};
for jj = 1:length(vVals)
    boostArgs.v = vVals(jj);     
    boostArgs.v
    [perfTrain,perfTest,boostStruct] = ...
        BoostLS(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);
    testRMSEv(jj) = boostStruct.perfTest(end).rmse;
end
%%

figure 
plot(rfVals,testRMSErf);

figure
plot(vVals,testRMSEv);





