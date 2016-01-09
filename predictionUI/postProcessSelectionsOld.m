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

binSize=40;
numBins = floor(length(resultVals)/binSize);
numInLastBin = length(resultVals)-numBins*binSize;
resultValsBinned = mat2cell(resultVals,1,[binSize*ones(1,numBins) numInLastBin]);

probEMD = zeros(1,length(resultValsBinned));
probMSE = zeros(1,length(resultValsBinned));
probAmb = zeros(1,length(resultValsBinned));
for i = 1:length(resultValsBinned)
   curBin = resultValsBinned{i};
   probEMD(i) = length(find(curBin==1))/length(curBin);
   probMSE(i) = length(find(curBin==2))/length(curBin);
   probAmb(i) = length(find(curBin==-2))/length(curBin);
end

figure
hold on
plot(probEMD,'g-');
plot(probMSE,'r-');
plot(probAmb,'b-');
legend('EMD Probablity','MSE Probability','Ambiguous Probability',...
    'location','eastoutside');
hold off

%%


emdResults = resultVals;
emdResults(emdResults~=1)=0;

mseResults = resultVals;
mseResults(mseResults~=2)=0;
mseResults = mseResults./2;

ambResults = resultVals;
ambResults(ambResults~=-2)=0;
ambResults = ambResults./-2;
%%
windowWidth = 20;
movingEMD = conv(emdResults,ones(1,windowWidth),'same');
movingMSE = conv(mseResults,ones(1,windowWidth),'same');
movingAmb = conv(ambResults,ones(1,windowWidth),'same');

movingEMD2 = conv(movingEMD,ones(1,windowWidth),'same');
%%

sortedCompare2 = sortedCompare;
sortedCompare2(emdResults==0)=0;
