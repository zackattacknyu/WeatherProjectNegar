%the array selections tells what has been selected
%   each index corresponds to what's in displayPatchInds

%this gets the current result data
%   using the compare method of 4
load('patchesSetData.mat');
compareMethod=4;
getDisplayPatchInds;
displayPatchIndsOld = displayPatchInds;
%load('currentResultData.mat');
%load('sendThisToZach_736336_4323.mat');
load('sendThisToZach_736354_8829.mat');

[~,patchIndsOrderOld] = sort(displayPatchIndsOld);
selectionsSortedOrder = selections(patchIndsOrderOld);

%THIS WILL CHANGE DEPENDING ON WHICH METHOD WE CARE ABOUT
compareMethod=14;

getDisplayPatchInds;

[xx,patchIndsOrderNew] = sort(displayPatchInds);
[~,rearrangingInds] = sort(patchIndsOrderNew);
selectionsNewOrder = selectionsSortedOrder(rearrangingInds);
selections = selectionsNewOrder;

resultEntries = find(selections~=0);
resultVals = selections(resultEntries);


%{
If I plot sortedCompare vs index, there is an exponential plot
    as many of the values are at the low end
Thus I need to do the ranking of probabilities by 
    sortedCompare index instead of sortedCompare value itself
This is due to the fact that there is a density
    of sortedCompare values at the low end but we really
    care about the patch's ranking in a list when
    deciding the probability that EMD is best
%}

emdResults = resultVals;
emdResults(emdResults~=1)=0;

mseResults = resultVals;
mseResults(mseResults~=2)=0;
mseResults = mseResults./2;

ambResults = resultVals;
ambResults(ambResults~=-2)=0;
ambResults = ambResults./-2;


windowWidth = 150;
kernal = gausswin(windowWidth);
kernal = kernal./sum(kernal);

%kernal2 = ones(1,windowWidth)./windowWidth;

movingEMD = conv(emdResults,kernal,'valid');
movingMSE = conv(mseResults,kernal,'valid');
movingAmb = conv(ambResults,kernal,'valid');

totalValues = length(emdResults);
totalEMD = length(find(emdResults==1));
totalMSE = length(find(mseResults==1));
totalAmb = length(find(ambResults==1));

indexValues = (windowWidth/2):(length(movingEMD)+windowWidth/2-1);

emdAvg = totalEMD/totalValues;
mseAvg = totalMSE/totalValues;
ambAvg = totalAmb/totalValues;

emdAvgArray = emdAvg.*ones(1,length(indexValues));
mseAvgArray = mseAvg.*ones(1,length(indexValues));
ambAvgArray = ambAvg.*ones(1,length(indexValues));

figure
hold on
plot(indexValues,movingEMD,'r-');
plot(indexValues,emdAvgArray,'r--');
plot(indexValues,movingMSE,'g-');
plot(indexValues,mseAvgArray,'g--');
plot(indexValues,movingAmb,'b-');
plot(indexValues,ambAvgArray,'b--');
hold off
xlabel('Ranking in List');
ylabel('Probability Of Selection in Window');
legend('EMD Prob','Avg EMD Prob','MSE Prob','Avg MSE Prob',...
    'Amb Prob','Avg Amb Prob','Location','eastoutside');
%%
results = [emdAvg mseAvg ambAvg];
figure
bar(results);
title('Global Probability of each Option Chosen');
xlabel('Option Chosen: 1-EMD 2-MSE 3-Ambiguous');
ylabel('Probability');