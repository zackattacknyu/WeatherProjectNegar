testingData = load('sep2012TestDataSet_every4thT.mat');
%%
rmseBaseline = std(testingData.YteSept);

xData = testingData.XteSept;
numData = size(xData,1);
xData = [xData ones(numData,1)];
yData = testingData.YteSept;
%%
rmseLinReg = zeros(1,13);
rmseLinReg2 = zeros(1,13);
rmseLinReg3 = zeros(1,13);
rmseExpReg = zeros(1,13);
rmseExpReg2 = zeros(1,13);
for kk = 1:13
    xx = xData(:,kk);
    [pp,ss,mu] = polyfit(xx,yData,1);
    [pp2,ss2,mu2] = polyfit(xx,yData,2);
    [pp3,ss3,mu3] = polyfit(xx,yData,3);
    yfit = polyval(pp,xx);
    yfit2 = polyval(pp2,xx);
    yfit3 = polyval(pp3,xx);
    rmseLinReg(kk) = sqrt(mean((yfit-yData).^2));
    rmseLinReg2(kk) = sqrt(mean((yfit2-yData).^2));
    rmseLinReg3(kk) = sqrt(mean((yfit3-yData).^2));
    
    fitFunc = fit(xx,yData,'exp1');
    fitFunc2 = fit(xx,yData,'exp2');
    rmseExpReg(kk) = sqrt(mean((fitFunc(xx)-yData).^2));
    rmseExpReg2(kk) = sqrt(mean((fitFunc2(xx)-yData).^2));
end

rmseBaselineLin = min(rmseLinReg);
rmseBaselineLin2 = min(rmseLinReg2);
rmseBaselineLin3 = min(rmseLinReg3);

[b,bint,r,rint,stats] = regress(yData,xData);

rmseMultipleLinear = sqrt(stats(4));
%%

figure
hold on
plot(rmseLinReg);
plot(rmseExpReg);
hold off
%%

figure
hold on
plot(rmseLinReg(2:13));
plot(rmseLinReg2(2:13));
plot(rmseLinReg3(2:13));
legend('Lin Reg','Quad Reg','Cubic Reg');
hold off


%%
vv=fit([xData(:,1) xData(:,2)],yData,'poly44');
res = sqrt(mean((vv(xData(:,1),xData(:,2))-yData).^2));