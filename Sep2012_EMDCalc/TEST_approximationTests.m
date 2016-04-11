
numFiles = 15;
testNum=3;
%testNum=4;
%testNum=7;

numMinutesArray = zeros(1,numFiles);
meanWarray = zeros(2,numFiles);
numSecPerPatch = zeros(1,numFiles);
for ii = 1:numFiles
    %numSecondsFileNm = ['patchesSep2011DataTest' num2str(testNum) '_rand' num2str(ii) '_numSeconds.mat'];
    %resFileNm = ['patchesSep2011DataTest' num2str(testNum) '_rand' num2str(ii) '_results.mat'];
    
    numSecondsFileNm = ['patchesSep2011DataTest' num2str(testNum) '_samplingTest' num2str(ii) '_numSeconds.mat'];
    resFileNm = ['patchesSep2011DataTest' num2str(testNum) '_samplingTest' num2str(ii) '_results.mat'];
    
    %numSecondsFileNm = ['patchesOct2012Data_all4_samplingTest' num2str(ii) '_numSeconds.mat'];
    %resFileNm = ['patchesOct2012Data_all4_samplingTest' num2str(ii) '_results.mat'];
    
    
    
    load(numSecondsFileNm,'numSeconds');
    
    load(resFileNm,'totalWorkFound');
    numMinutesArray(ii) = numSeconds/60;
    meanWarray(:,ii) = mean(totalWorkFound,2);
    numSecPerPatch(ii) = numSeconds/numel(totalWorkFound);
    
    %{
    load(resFileNm,'totalWorkEMD');
    numMinutesArray(ii) = numSeconds/60;
    meanWarray(:,ii) = mean(totalWorkEMD,2);
    numSecPerPatch(ii) = numSeconds/numel(totalWorkEMD);
    %}
end

load(['patchesSep2011DataTest' num2str(testNum) '_numSeconds.mat']);
load(['patchesSep2011DataTest' num2str(testNum) '_results.mat']);

%load('patchesOct2012Data_results_all4.mat');
%load('patchesOct2012Data_numSeconds_all3.mat');

numMinutesAll = numSeconds/60
[min(numMinutesArray) max(numMinutesArray) mean(numMinutesArray)]
meanWall = mean(totalWorkEMD,2);
numSecPerPatchAll = numSeconds/numel(totalWorkEMD);
%{
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
%}
figure
hold on
plot(1:numFiles,meanWarray(1,:),'r-');
plot(1:numFiles,meanWarray(2,:),'b-');
plot(1:numFiles,meanWall(1).*ones(1,size(meanWarray,2)),'r--');
plot(1:numFiles,meanWall(2).*ones(1,size(meanWarray,2)),'b--');
hold off
title('Mean W value for each prediction vs Trial Run Number');
legend('Prediction 1, from Sample Mean','Prediction 2, from Sample Mean',...
    'Prediction 1, from Population Mean','Prediction 2, from Population Mean');
xlabel('Trial Num');
ylabel('Mean W');

