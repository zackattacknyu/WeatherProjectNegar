testingData = load('sep2012TestDataSet_every4thT.mat');

rmseBaseline = std(testingData.YteSept);

xData = testingData.XteSept;
numData = size(xData,1);
xData = [xData ones(numData,1)];
yData = testingData.YteSept;

rmseLinReg = zeros(1,13);
rmseExpReg = zeros(1,13);
for kk = 1:13
    xx = xData(:,kk);
    [pp,ss,mu] = polyfit(xx,yData,1);

    yfit = polyval(pp,xx);

    rmseLinReg(kk) = sqrt(mean((yfit-yData).^2));
    
    fitFunc = fit(xx,yData,'exp1');

    rmseExpReg(kk) = sqrt(mean((fitFunc(xx)-yData).^2));

end

%%
figure
hold on
plot(2:13,rmseLinReg(2:13));
plot(1:13,rmseExpReg(1:13));
legend('Linear Regression RMSE','Exponential Regression RMSE');
xlabel('Feature Number');
ylabel('RMSE for Regression on that Feature');
hold off

%%

[b,bint,r,rint,stats] = regress(yData,xData);

rmseMultipleLinear = sqrt(stats(4));
%%

varFeatures = var(xData);
figure
hold on
errorbar(1:14,b,bint(:,1),bint(:,2),'r--')
%plot(2:13,varFeatures(2:13).*10)
%legend('Coeffients with each feature','Variance of each feature(*10)',...
%    'Location','eastoutside');
xlabel('Feature Number');
ylabel('Coefficient with Feature');
title('Coefficients in Mult Lin Reg Model for each feature');
hold off

%%

numPts = size(xData,1);
ratioDisp = 0.01;
randInds = randperm(numPts);
randIndsDisp = randInds(1:ceil(ratioDisp*numPts));
figure
xlabel('Feature 2 Value');
ylabel('Y Value');
plot(xData(randIndsDisp,2),yData(randIndsDisp),'r.');
title('Feature 2 vs Y for random 1% of Test Data');
%%
figure
scatter3(xData(randIndsDisp,1),xData(randIndsDisp,2),yData(randIndsDisp));