%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');

numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = sum(totalWorkEMD,2);

WORK1 = sort(totalWorkEMD(1,:));
WORK2 = sort(totalWorkEMD(2,:));

LOGWORK1 = sort(log(totalWorkEMD(1,:)));
LOGWORK2 = sort(log(totalWorkEMD(2,:)));

INDS = 1:length(LOGWORK1);
cdfVals = INDS./length(LOGWORK1);

%TODO: AUTOMATE THIS PART IN THE CODE
%{
Results using error function for model

General model:
     f(x) = 0.5+erf(b*(x-a))*0.5
Coefficients (with 95% confidence bounds):
       a =       5.191  (5.19, 5.192)
       b =     0.5037  (-0.5045, -0.5029)

Goodness of fit:
  SSE: 1.693
  R-square: 0.9979
  Adjusted R-square: 0.9979
  RMSE: 0.01327

%}
%%
%{
We will assume erf function
a=5.191
b=0.5037
%}
a=5.191;
b=0.5037;
mu = a;
sigma = 1/(b*sqrt(2));

%{
Using alternate form specified here:
https://en.wikipedia.org/wiki/Gaussian_integral#The_integral_of_a_Gaussian_function
%}

%gaussian function
xmin = min(LOGWORK1);
xmax = max(LOGWORK1);
%xx = linspace(xmin,xmax,length(LOGWORK1));
xx = LOGWORK1;
yy1 = normpdf(xx,mu,sigma);
yy2 = exp(xx).*yy1;
intVal = trapz(xx,yy2)
func2 = @(x)(exp(x).*normpdf(x,mu,sigma));
intVal2 = integral(func2,xmin,xmax)
indsRand = randperm(length(WORK1));
indsUse = indsRand(1:1800);
meanWorkEst = mean(WORK1(indsUse))
meanWork = mean(WORK1)

%%
figure
hold on
plot(xx,normcdf(xx,mu,sigma),'r-')
plot(LOGWORK1,cdfVals,'b--');
hold off
%%

[phatML,pciML] = mle(WORK1)



