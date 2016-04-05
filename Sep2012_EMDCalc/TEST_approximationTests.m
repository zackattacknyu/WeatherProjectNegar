
numFiles = 9;
numMinutesArray = zeros(1,numFiles);
meanWarray = zeros(2,numFiles);
numSecPerPatch = zeros(1,numFiles);
for ii = 1:numFiles
    numSecondsFileNm = ['patchesSep2011DataTest3_rand' num2str(ii) '_numSeconds.mat'];
    resFileNm = ['patchesSep2011DataTest3_rand' num2str(ii) '_results.mat'];
    
    load(numSecondsFileNm,'numSeconds');
    load(resFileNm,'totalWorkEMD');
    
    numMinutesArray(ii) = numSeconds/60;
    meanWarray(:,ii) = mean(totalWorkEMD,2);
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