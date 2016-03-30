testingData = load('sep2012TestDataSet_every4thT.mat');

rmseBaseline = std(testingData.YteSept);

xData = testingData.XteSept;
numData = size(xData,1);
xData = [xData ones(numData,1)];
yData = testingData.YteSept;
%%
[b,bint,r,rint,stats] = regress(yData,xData);

rmseMultipleLinear = sqrt(stats(4));

%[BETA,SIGMA,RESID,VARPARAM]=mvregress(xData,yData);
%rmseMultiNormal = sqrt(mean(RESID.^2));

%%

yDataPrime = log(yData+1);
[bPrime,bintPrime,rPrime,rintPrime,statsPrime] = regress(yDataPrime,xData);
computedXhat = xData*bPrime;
yfit = exp(computedXhat)-1;
rmseMultExp = sqrt(mean((yfit-yData).^2));
%%
numFeat = 14;
modelfun = @(b,x)(b(1)+exp(x*b(2:(numFeat+1))));
beta0 = [1;bPrime];

[BETA,R,J,COVB,MSE] = nlinfit(xData,yData,modelfun,beta0);

rmseMultExp2 = sqrt(MSE);

%%

modelfun = @(b,x)(b(1)+exp(x*b(2:end)));
beta0 = ones(size(xData,2)+1,1);

[BETA,R,J,COVB,MSE] = nlinfit(xData,yData,modelfun,beta0);

rmseMultExp4 = sqrt(MSE);

%%

modelfun = @(b,x)(exp(x*b));
[BETA2,R2,J2,COVB2,MSE2] = nlinfit(xData,yData,modelfun,bPrime);
%%
rmseMultExp3 = sqrt(MSE2);

%{
1.9391 is best RMSE for mult linear regression
1.9360 is best RMSE for mult exp regression

Due to only small improvement yet increased 
    computational complexity, I will stick 
    with mult linear regression
%}
