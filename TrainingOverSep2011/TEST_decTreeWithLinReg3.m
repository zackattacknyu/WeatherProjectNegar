
bad=true;
while(bad)
    try
        load('Sep2011SetupDataZach_decTreeLinReg.mat','Xtr','Xte','Ytr','Yte');
        load('sep2012TestDataSet_every4thT.mat','XteSept','YteSept');
        Xtr = [Xtr ones(size(Xtr,1),1)];
        Xte = [Xte ones(size(Xte,1),1)];
        XteSept = [XteSept ones(size(XteSept,1),1)];
        bad = false;
    catch
        bad=true;
        fprintf('File not found. Waiting 30 seconds...\n');
        pause(30);
        
    end
end



%based on previous graphs, set maxDepth to 5
dd=5;
minPar = 50;
minScore=1;

paramVals = [100 50 20 10 8 7 5 4 3 2 1 ...
    0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.25 0.1...
    0.005 0.001];

trainingRMSEwithLin = zeros(1,length(paramVals));
validRMSEwithLin = zeros(1,length(paramVals));
testRMSEwithLin = zeros(1,length(paramVals));

trainingRMSEconst = zeros(1,length(paramVals));
validRMSEconst = zeros(1,length(paramVals));
testRMSEconst = zeros(1,length(paramVals));

for ind = 1:length(paramVals)
    
    %dd = paramVals(ind);
    %minPar = paramVals(ind);
    minScore = paramVals(ind);
    
    tc = treeRegressWithLinReg(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);
    tc2 = treeRegress(Xtr,Ytr,'maxdepth',dd,'minparent',minPar,'minscore',minScore);


    trainingRMSEwithLin(ind) = rmse(tc,Xtr,Ytr);
    validRMSEwithLin(ind) = rmse(tc,Xte,Yte);
    testRMSEwithLin(ind) = rmse(tc,XteSept,YteSept);

    trainingRMSEconst(ind) = sqrt(mse(tc2,Xtr,Ytr));
    validRMSEconst(ind) = sqrt(mse(tc2,Xte,Yte));
    testRMSEconst(ind) = sqrt(mse(tc2,XteSept,YteSept));
end

save('decTreeWithLinReg_minScoreTestRun.mat');
%%

load('decTreeWithLinReg_minScoreTestRun.mat');
indsDisp = 5:22;
load('regressionData_3-23.mat','rmseMultipleLinear');
figure
hold on
plot(paramVals(indsDisp),testRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),testRMSEconst(indsDisp),'g--');
plot(paramVals(indsDisp),rmseMultipleLinear.*ones(size(indsDisp)),'b:','LineWidth',2)
legend('With Linear Regression','Without Linear Regression');
hold off
title('Test RMSE vs Max Depth');
xlabel('Min Score Value');
ylabel('RMSE');

figure
hold on
plot(paramVals(indsDisp),validRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),validRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Validation RMSE vs Max Depth');
xlabel('Min Score Value');
ylabel('RMSE');

figure
hold on
plot(paramVals(indsDisp),trainingRMSEwithLin(indsDisp),'r-');
plot(paramVals(indsDisp),trainingRMSEconst(indsDisp),'g--');
legend('With Linear Regression','Without Linear Regression');
hold off
title('Training RMSE vs Max Depth');
xlabel('Min Score Value');
ylabel('RMSE');

%IDEAL MIN SCORE IS 0.8 FROM THESE TESTS

