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

%{
Results for plotting LOGWORK1 vs cdfVals:
General model:
     f(x) = 1/(1+exp(-b*(x-c)))
Coefficients (with 95% confidence bounds):
       b =       1.185  (1.184, 1.187)
       c =       5.194  (5.193, 5.195)

Goodness of fit:
  SSE: 1.489
  R-square: 0.9981
  Adjusted R-square: 0.9981
  RMSE: 0.01245
%}

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

aa = 1/(2*sigma^2);
bb = 2*(mu+sigma^2);
const1=1/(sigma*sqrt(2*pi));
const2=exp(-mu^2/(2*sigma^2));
integralResult = sqrt(pi/aa)*exp(bb^2/(4*aa));
finalResult = integralResult*const1*const2;

%%

%gaussian function
xmin = min(LOGWORK1);
xmax = max(LOGWORK2);
xx = xmin:0.01:xmax;
yy1 = normpdf(xx,mu,sigma);
yy2 = exp(xx).*yy1;
intVal = trapz(xx,yy2);

%%

%logistic function
%DOES NOT WORK RIGHT NOW. DO NOT USE
b2 =  1.185;
c2 =  5.194;
yy3 = 1./(1+exp(-b2.*(xx-c2)));
yy4 = exp(c2)*b2*exp(xx).*yy3.*(1-yy3);
intVal2 = trapz(xx,yy4);


