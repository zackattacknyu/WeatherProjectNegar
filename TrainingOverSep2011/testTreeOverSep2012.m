
load('Sep2011SetupDataZach.mat');

load('sep2012TestDataSet_every4thT.mat');

rfVals = [5 9 10];
Jvals = [2 3 4];

for rf = rfVals
    rf
   for j = Jvals
       j
        load(['Sep2011Training_J' num2str(j) 'rf' num2str(rf) '_tree1.mat']);
        testNickTreeScript;

        save(['rmseValidationSep2012_J' num2str(j) 'rf' num2str(rf) '.mat'],'rmseTestVals');
   end
end


%%
ind = 1;

rfVals = [9];
Jvals = [2 3 4];
data = cell(1,prod([length(rfVals) length(Jvals)]));
param = cell(1,length(data)+4);
for rf = rfVals
    %rf
   for j = Jvals
       %j
       
       data{ind} = load(['rmseValidationSep2012_J' num2str(j) 'rf' num2str(rf) '.mat'],'rmseTestVals');
       param{ind} = ['rf=' num2str(rf) ' J=' num2str(j)];
       ind = ind+1;
   end
end

rmseExp = min(rmseExpReg);
dispInds = 1:10;
baseline = rmseBaseline.*ones(size(dispInds));
baseline2 = rmseBaselineLin.*ones(size(dispInds));
baseline3 = rmseMultipleLinear.*ones(size(dispInds));
baseline4 = rmseExp.*ones(size(dispInds));
figure
hold on
for i = 1:length(data)
    plot(data{i}.rmseTestVals(dispInds));
end
param{ind} = 'Best RMSE if Constant Predictor';
param{ind+1} = 'Best RMSE if Single Linear Regression';
param{ind+2} = 'Best RMSE if Multiple Linear Regression';
param{ind+3} = 'Best RMSE if Single Exponential Regression';
plot(baseline,'--');
plot(baseline2,':','LineWidth',2);
plot(baseline3,'--','LineWidth',3);
plot(baseline4,':','LineWidth',2);
title('Gradient Boosting RMSE and comparison with baselines');
ylabel('RMSE');
xlabel('Iteration Number');
legend(param,'Location','eastoutside')
hold off

