

timeVals = [435 437 440 481 485];
numFiles = length(timeVals);

numMinutesArray = zeros(1,numFiles);
meanWarray = zeros(2,numFiles);
rmseArray = zeros(2,numFiles);
numSecPerPatch = zeros(1,numFiles);
for ii = 1:numFiles
    timeV = timeVals(ii);
    numSecondsFileNm = ['patchesSep2011DataTest2_time'...
        num2str(timeV) '_numSeconds.mat'];
    resFileNm = ['patchesSep2011DataTest2_time'...
        num2str(timeV) '_results.mat'];
    rmseFileNm = ['patchesSep2011DataTest2_time'...
        num2str(timeV) '_rmse.mat'];
    
    load(numSecondsFileNm,'numSeconds');
    load(resFileNm,'totalWorkEMD');
    load(rmseFileNm);
    
    numMinutesArray(ii) = numSeconds/60;
    meanWarray(:,ii) = mean(totalWorkEMD,2);
    rmseArray(:,ii) = [decTreeRMSE;ccsRMSE];
    numSecPerPatch(ii) = numSeconds/numel(totalWorkEMD);
end

figure
plot(numMinutesArray);
xlabel('Trial Num');
ylabel('Number Minutes');
title('Number of Minutes versus Trial');

figure
plot(numSecPerPatch);
xlabel('Trial Num');
ylabel('Average Number Seconds');
title('Avg Number of Seconds for Each Patch (with multithreading)');

figure
hold on
plot(meanWarray(1,:),'r-');
plot(meanWarray(2,:),'b-');
hold off
title('Mean W versus Trial');
legend('Prediction 1','Prediction 2');
xlabel('Trial Num');
ylabel('Mean W');

figure
hold on
plot(rmseArray(1,:),'r-');
plot(rmseArray(2,:),'b-');
hold off
title('RMSE versus Trial');
legend('Prediction 1','Prediction 2');
xlabel('Trial Num');
ylabel('RMSE');