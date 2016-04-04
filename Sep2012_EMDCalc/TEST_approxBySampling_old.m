%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');


numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = mean(totalWorkEMD,2);
Lpred1 = LvaluesFunc1(1);
Lpred2 = LvaluesFunc1(2);

numTrials = 10;
LkPred1 = zeros(numTrials,size(predErrorsEMD,2));
LkPred2 = zeros(numTrials,size(predErrorsEMD,2));

for trialN = 1:numTrials
    randPatches = randperm(numPatches);
    %randPatchesUse = [];
    for k = 1:numPatches
        randPatchesUse = randPatches(1:k);
        %randPatchesUse = [randPatchesUse ceil(numPatches*rand(1,1))];
        workSampled = totalWorkEMD(:,randPatchesUse);
        
        f1Vals = mean(workSampled,2);
        
        LkPred1(trialN,k) = f1Vals(1);      
        LkPred2(trialN,k) = f1Vals(2);
        
    end
    
    
end
%%

[workVals,~] = sort(totalWorkEMD(1,:));
percentage = 0.1;
numVals = ceil(percentage*length(workVals));
inds = (1:length(workVals))./length(workVals);
curYLower = inds(1:numVals);
curYUpper = inds(end-numVals+1:end);
curXLower = log(workVals(1:numVals));
curXHigher = log(workVals(end-numVals+1:end));

%Equation of fitting
%0.5*(1+erf((x-a)/b))

%{
Here are the stats(nothing too promising of the approach
    of assuming 10% of the data is on the highest or lowest
    end of the distribution)

Stats for XLower&YLower:
General model:
     f(x) = 0.5*(1+erf((x-a)/b))
Coefficients (with 95% confidence bounds):
       a =       5.528  (5.52, 5.536)
       b =       2.633  (2.625, 2.64)
Goodness of fit:
  SSE: 0.0008409
  R-square: 0.9989
  Adjusted R-square: 0.9989
  RMSE: 0.0009364

Stats for XLower&YHigher:
General model:
     f(x) = 0.5*(1+erf((x-a)/b))
Coefficients (with 95% confidence bounds):
       a =      -3.446  (-3.627, -3.265)
       b =       4.862  (4.696, 5.028)
Goodness of fit:
  SSE: 0.1757
  R-square: 0.7806
  Adjusted R-square: 0.7804
  RMSE: 0.01353

Stats for XHigher&YLower:
General model:
     f(x) = 0.5*(1+erf((x-a)/b))
Coefficients (with 95% confidence bounds):
       a =      0.1739
       b =      0.9253
Goodness of fit:
  SSE: 868
  R-square: -1083
  Adjusted R-square: -1084
  RMSE: 0.9514

Stats for XLower&YUpper:
General model:
     f(x) = 0.5*(1+erf((x-a)/b))
Coefficients (with 95% confidence bounds):
       a =      -3.446  (-3.627, -3.265)
       b =       4.862  (4.696, 5.029)
Goodness of fit:
  SSE: 0.1757
  R-square: 0.7806
  Adjusted R-square: 0.7804
  RMSE: 0.01353

Stats for XHigher&YUpper:
General model:
     f(x) = 0.5*(1+erf((x-a)/b))
Coefficients (with 95% confidence bounds):
       a =     0.09544
       b =      0.6199

Goodness of fit:
  SSE: 3.198
  R-square: -2.994
  Adjusted R-square: -2.998
  RMSE: 0.05775

Warning: A negative R-square is possible if the model does not contain a constant term and the fit is poor (worse than just fitting the mean). Try changing the model or using a different StartPoint.

%}





%%
startColInd = 500;
dispRows = 1:10;
lineWidth=3;

minYf1p1 = min(min(LkPred1(dispRows,startColInd:end)));
maxYf1p1 = max(max(LkPred1(dispRows,startColInd:end)));

minYf1p2 = min(min(LkPred2(dispRows,startColInd:end)));
maxYf1p2 = max(max(LkPred2(dispRows,startColInd:end)));

minY = min([minYf1p1 minYf1p2]);
maxY = max([maxYf1p1 maxYf1p2]);

figure
title('L_k values for Predictions');
hold on
plot(LkPred1(dispRows,:)','b') 
plot(LkPred2(dispRows,:)','r')  
plot(Lpred1.*ones(1,numPatches),'k--','LineWidth',lineWidth);
plot(Lpred2.*ones(1,numPatches),'k--','LineWidth',lineWidth);
axis([startColInd numPatches minY maxY]);
xlabel('k value');
ylabel('L_k value');
hold off
%%

%{
Taken from the following:
https://en.wikipedia.org/wiki/Standard_error#Standard_error_of_the_mean
%}
pred1sampleStandardDev = std(LkPred1);
pred2sampleStandardDev = std(LkPred2);
SEx_pred1=pred1sampleStandardDev./sqrt(1:numPatches);
SEx_pred2=pred2sampleStandardDev./sqrt(1:numPatches);

figure
hold on
plot(SEx_pred1,'r');
plot(SEx_pred2,'b');
hold off

%%


[orderedVals1,orderedInds1] = sort(LkPred1);
[orderedVals2,orderedInds2] = sort(LkPred2);

numOrd = 2000;
mean1Low = zeros(1,numOrd);
mean1High = zeros(1,numOrd);
mean2Low = zeros(1,numOrd);
mean2High = zeros(1,numOrd);

for NN=1:numOrd

    mean1Low(NN) = mean(orderedVals1(1,1:NN));
    mean1High(NN) = mean(orderedVals1(1,end-NN:end));

    mean2Low(NN) = mean(orderedVals2(1,1:NN));
    mean2High(NN) = mean(orderedVals2(1,end-NN:end));

end

figure
hold on
plot(mean1Low,'r-');
plot(mean1High,'r-');
plot(mean2Low,'b-');
plot(mean2High,'b-');
hold off