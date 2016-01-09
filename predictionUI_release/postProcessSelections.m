%the array selections tells what has been selected
%   each index corresponds to what's in displayPatchInds

%this gets the current result data
%   using the compare method of 3
load('patchesSetData.mat');
compareMethod=3;
getDisplayPatchInds;
displayPatchIndsOld = displayPatchInds;
%load('currentResultData.mat');
load('sendThisToZach_736336_4323.mat');

[~,patchIndsOrderOld] = sort(displayPatchIndsOld);
selectionsSortedOrder = selections(patchIndsOrderOld);

%THIS WILL CHANGE DEPENDING ON WHICH METHOD WE CARE ABOUT
compareMethod=1;

getDisplayPatchInds;

[xx,patchIndsOrderNew] = sort(displayPatchInds);
[~,rearrangingInds] = sort(patchIndsOrderNew);
selectionsNewOrder = selectionsSortedOrder(rearrangingInds);
selections = selectionsNewOrder;

resultEntries = find(selections~=0);
resultVals = selections(resultEntries);
%%

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


%{
NOTE: 
NOT SURE IF KSDENSITY REALLY TELLS US ANYTHING
WORK ON IT LATER AFTER CONV HAS BEEN DONE BETTER

emdIndices = find(resultVals==1);
%mseIndices = find(resultVals==2);
%ambIndices = find(resultVals==-2);

[emdF,emdXi] = ksdensity(emdIndices);
%[mseF,mseXi] = ksdensity(mseIndices);
%[ambF,ambXi] = ksdensity(ambIndices);

emdIndsToShowA = find(emdXi>=1);
emdIndsToShowB = find(emdXi<=length(resultVals));
emdIndsToShow = intersect(emdIndsToShowA,emdIndsToShowB);

xVals = emdXi(emdIndsToShow);
pVals = emdF(emdIndsToShow);
pVals = pVals./max(pVals);

figure
plot(xVals,pVals);
xlabel('Ranking in List');
ylabel('Probability of Selecting EMD');
%}

emdResults = resultVals;
emdResults(emdResults~=1)=0;

mseResults = resultVals;
mseResults(mseResults~=2)=0;
mseResults = mseResults./2;

ambResults = resultVals;
ambResults(ambResults~=-2)=0;
ambResults = ambResults./-2;

windowWidth = 80;
kernal = ones(1,windowWidth)./windowWidth;
movingEMD = conv(emdResults,kernal,'same');
movingMSE = conv(mseResults,kernal,'same');
movingAmb = conv(ambResults,kernal,'same');

movingEMD2 = conv(movingEMD,kernal,'same');
movingMSE2 = conv(movingMSE,kernal,'same');
movingAmb2 = conv(movingAmb,kernal,'same');

figure
hold on
plot(movingEMD2,'r-');
plot(movingMSE2,'g-');
plot(movingAmb2,'b-');
hold off
xlabel('Ranking in List');
ylabel('Probability Of Selection in Window');
legend('EMD Prob','MSE Prob','Amb Prob');
