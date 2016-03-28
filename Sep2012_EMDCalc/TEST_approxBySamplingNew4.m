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

[phatML,pciML] = mle(LOGWORK1)
%%
[phatML2,pciML2] = mle(WORK1)

%%
mu = phatML(1);
sigma = phatML(2);
figure
hold on
plot(xx,normcdf(xx,mu,sigma),'r-')
plot(LOGWORK1,cdfVals,'b--');
hold off


%gaussian function
xmin = min(LOGWORK1);
xmax = max(LOGWORK1);
xx = linspace(xmin,xmax,length(LOGWORK1));
%xx = LOGWORK1;
yy1 = normpdf(xx,mu,sigma);
yy2 = exp(xx).*yy1;
intVal = trapz(xx,yy2)
func2 = @(x)(exp(x).*normpdf(x,mu,sigma));
intVal2 = integral(func2,xmin,xmax)
indsRand = randperm(length(WORK1));
indsUse = indsRand(1:1800);
meanWorkEst = mean(WORK1(indsUse))
meanWork = mean(WORK1)








