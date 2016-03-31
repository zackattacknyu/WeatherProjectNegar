
load('Sep2011SetupDataZach_decTreeLinReg.mat','Xtr','Xte','Ytr','Yte');
load('sep2012TestDataSet_every4thT.mat','XteSept','YteSept');
Xtr = [Xtr ones(size(Xtr,1),1)];
Xte = [Xte ones(size(Xte,1),1)];
XteSept = [XteSept ones(size(XteSept,1),1)];

d=15;
minPar = 30;
minScore=0.5;

maxDepthVals = 1:10;

trainingRMSEwithLin = zeros(1,length(maxDepthVals));
validRMSEwithLin = zeros(1,length(maxDepthVals));
testRMSEwithLin = zeros(1,length(maxDepthVals));

trainingRMSEconst = zeros(1,length(maxDepthVals));
validRMSEconst = zeros(1,length(maxDepthVals));
testRMSEconst = zeros(1,length(maxDepthVals));

numTrees=10;

for ind = 1:length(maxDepthVals)
    
    dd = maxDepthVals(ind);
    
    
    YtrHat = zeros(size(Ytr));
    YteHat = zeros(size(Yte));
    YteSeptHat = zeros(size(YteSept));
    
    YtrHat2 = zeros(size(Ytr));
    YteHat2 = zeros(size(Yte));
    YteSeptHat2 = zeros(size(YteSept));
    
    for jj=1:numTrees
        
        fprintf(['Now Training with maxDepth=' num2str(dd) ', Tree ' num2str(jj) '\n']);
        
        tc = treeRegressWithLinReg(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);
        tc2 = treeRegress(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);
        
        YtrHat = YtrHat + predict(tc,Xtr);
        YteHat = YteHat + predict(tc,Xte);
        YteSeptHat = YteSeptHat + predict(tc,XteSept);
        
        YtrHat2 = YtrHat2 + predict(tc2,Xtr);
        YteHat2 = YteHat2 + predict(tc2,Xte);
        YteSeptHat2 = YteSeptHat2 + predict(tc2,XteSept);
    end
    
    YtrHat = YtrHat./numTrees;
    YteHat = YteHat./numTrees;
    YteSeptHat = YteSeptHat./numTrees;

    YtrHat2 = YtrHat2./numTrees;
    YteHat2 = YteHat2./numTrees;
    YteSeptHat2 = YteSeptHat2./numTrees;

    trainingRMSEwithLin(ind) = sqrt(mean((YtrHat-Ytr).^2));
    validRMSEwithLin(ind) = sqrt(mean((YteHat-Yte).^2));
    testRMSEwithLin(ind) = sqrt(mean((YteSeptHat-YteSept).^2));

    trainingRMSEconst(ind) = sqrt(mean((YtrHat2-Ytr).^2));
    validRMSEconst(ind) = sqrt(mean((YteHat2-Yte).^2));
    testRMSEconst(ind) = sqrt(mean((YteSeptHat2-YteSept).^2));
end

save('randForestWithLinRegResults.mat');

%{
indsDisp = 1:12;

load('regressionData_3-23.mat','rmseMultipleLinear');

figure
hold on
plot(maxDepthVals(indsDisp),testRMSEwithLin(indsDisp),'r-');
plot(maxDepthVals(indsDisp),testRMSEconst(indsDisp),'g--');
plot(maxDepthVals(indsDisp),rmseMultipleLinear.*ones(size(indsDisp)),'b:','LineWidth',2)
legend('Dec Tree With Linear Regression',...
    'Dec Tree Without Linear Regression',...
    'Baseline: Linear Regression on Test Data');
hold off
title('Test RMSE vs Max Depth');
xlabel('Max Depth Value');
ylabel('RMSE');

figure
hold on
plot(maxDepthVals(indsDisp),validRMSEwithLin(indsDisp),'r-');
plot(maxDepthVals(indsDisp),validRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Validation RMSE vs Max Depth');
xlabel('Max Depth Value');
ylabel('RMSE');

figure
hold on
plot(maxDepthVals(indsDisp),trainingRMSEwithLin(indsDisp),'r-');
plot(maxDepthVals(indsDisp),trainingRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Training RMSE vs Max Depth');
xlabel('Max Depth Value');
ylabel('RMSE');

%}
