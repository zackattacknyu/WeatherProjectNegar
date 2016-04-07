

%timeVals = [435 437 440 481 485]; %test 2
%timeVals = [2 3 5:9 44:52 57 61 95 107:111 138:148 157]; %test 5
timeVals = [111   147   157   146   140   145   141   110]; %test 6
testNum=6;

numFiles = length(timeVals);

numMinutesArray = zeros(1,numFiles);
meanWarray = zeros(2,numFiles);
rmseArray = zeros(2,numFiles);
numSecPerPatch = zeros(1,numFiles);
for ii = 1:numFiles
    timeV = timeVals(ii);
    numSecondsFileNm = ['patchesSep2011DataTest' num2str(testNum) '_time'...
        num2str(timeV) '_numSeconds.mat'];
    resFileNm = ['patchesSep2011DataTest' num2str(testNum) '_time'...
        num2str(timeV) '_results.mat'];
    rmseFileNm = ['patchesSep2011DataTest' num2str(testNum) '_time'...
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

%%

%+1 if pred 2 better. -1 otherwise
betterPredByMeanW = sign(meanWarray(2,:)-meanWarray(1,:));
betterPredByRMSE = sign(rmseArray(2,:)-rmseArray(1,:));
predictionDifference = betterPredByMeanW-betterPredByRMSE;
predsDiffer = (abs(predictionDifference)>0);
predsDifferTimes = timeVals(predsDiffer);

%go from -1 or 1 to 1 or 2
preferredPredByW = (betterPredByMeanW(predsDiffer).*0.5)+1.5;
wDifference = abs(meanWarray(2,predsDiffer)-meanWarray(1,predsDiffer));
rDifference = abs(rmseArray(2,predsDiffer)-rmseArray(1,predsDiffer));
[largestDiffsW,predsDifferI] = sort(wDifference,'descend');
predsDifferOrdered = predsDifferTimes(predsDifferI);
rValInLargestDiffsW = rDifference(predsDifferI);


%%


for ii = 1:length(targetPatches)
   curP = targetPatches{ii};
   numBad = length(find(curP>0 & curP<1));
   if(numBad>0)
      numBad 
   end
end