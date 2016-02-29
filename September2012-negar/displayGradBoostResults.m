load('tc_testRunOtherValues.mat')
%%

[~,ii]=sort(vVals);
plot(vVals(ii),testRMSEv(ii));
title('Learning Rate vs test RMSE for Sep 2012 Data Set');
xlabel('Learning Rate (v)');
ylabel('Test RMSE');

%%

[~,ii]=sort(rfVals);
plot(rfVals(ii),testRMSErf(ii));
title('Random Forest Param vs test RMSE for Sep 2012 Data Set');
xlabel('Feature Ratio (rf)');
ylabel('Test RMSE');

%%

plot(testRMSEj);
title('Number Leaf Nodes vs test RMSE for Sep 2012 Data Set');
xlabel('log_2(Leaf Nodes)');
ylabel('Test RMSE');

%%
%load('tc_NickDecTreeResult_J128rf8');
boostRMSEvals = zeros(1,length(boostStruct.perfTest));
for i = 1:length(boostStruct.perfTest)
    boostRMSEvals(i) = boostStruct.perfTest(i).rmse;
end
plot(boostArgs.evaliter,boostRMSEvals)
title('Number of Iterations vs test RMSE for Sep 2012 Data Set');
xlabel('Number of Iterations');
ylabel('test RMSE');
%[minRMSE,numIterAtMin] = min(boostRMSEvals)