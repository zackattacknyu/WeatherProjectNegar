
numFiles = 9;
testNum=4;
numMinutesArray = zeros(1,numFiles);
meanWarray = zeros(2,numFiles);
numSecPerPatch = zeros(1,numFiles);
for ii = 1:numFiles
    numSecondsFileNm = ['patchesSep2011DataTest' num2str(testNum) '_rand' num2str(ii) '_numSeconds.mat'];
    resFileNm = ['patchesSep2011DataTest' num2str(testNum) '_rand' num2str(ii) '_results.mat'];
    
    load(numSecondsFileNm,'numSeconds');
    load(resFileNm,'totalWorkEMD');
    
    numMinutesArray(ii) = numSeconds/60;
    meanWarray(:,ii) = mean(totalWorkEMD,2);
    numSecPerPatch(ii) = numSeconds/numel(totalWorkEMD);
end

load(['patchesSep2011DataTest' num2str(testNum) '_numSeconds.mat']);
load(['patchesSep2011DataTest' num2str(testNum) '_results.mat']);
numMinutesAll = numSeconds/60;
meanWall = mean(totalWorkEMD,2);
numSecPerPatchAll = numSeconds/numel(totalWorkEMD);

figure
plot(numMinutesArray);
xlabel('Trial Num');
ylabel('Number Minutes');
title(['Number of Minutes versus Trial ('...
    num2str(numMinutesAll) ' Minutes without Sampling)']);

figure
hold on
plot(numSecPerPatch);
plot(numSecPerPatchAll.*ones(1,length(numSecPerPatch)),'r');
hold off
xlabel('Trial Num');
ylabel('Average Number Seconds');
legend('Trials','Without Sampling');
title('Avg Number of Seconds for Each Patch (with multithreading)');

figure
hold on
plot(meanWarray(1,:),'r-');
plot(meanWarray(2,:),'b-');
plot(meanWall(1).*ones(1,size(meanWarray,2)),'r--');
plot(meanWall(2).*ones(1,size(meanWarray,2)),'b--');
hold off
title('Mean W versus Trial');
legend('Prediction 1','Prediction 2','Pred 1 All','Pred 2 All');
xlabel('Trial Num');
ylabel('Mean W');

