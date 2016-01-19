useEMD=true;

[x,i1] = sort(emdDiffs,'descend');
[y,i2] = sort(mseDiffs,'descend');

ratio = 0.05;
numInds = floor(length(i1)*ratio);

if(useEMD)
    goodInds = i2(1:numInds);
    otherVals = emdDiffs(goodInds);
    [~,newEMDorder] = sort(otherVals);
    newOrder = goodInds(newEMDorder);
    newSelections = selectionsSortedOrder(newOrder);
else
    goodInds = i1(1:numInds);
    otherMSEvals = mseDiffs(goodInds);
    [~,newMSEorder] = sort(otherMSEvals);
    newOrder = goodInds(newMSEorder);
    newSelections = selectionsSortedOrder(newOrder);
end

emdResults = newSelections;
emdResults(emdResults~=1)=0;

mseResults = newSelections;
mseResults(mseResults~=2)=0;
mseResults = mseResults./2;

ambResults = newSelections;
ambResults(ambResults~=-2)=0;
ambResults = ambResults./-2;

windowWidth = 15;
kernal = gausswin(windowWidth);
kernal = kernal./sum(kernal);

movingEMD = conv(emdResults,kernal,'valid');
movingMSE = conv(mseResults,kernal,'valid');
movingAmb = conv(ambResults,kernal,'valid');

totalValues = length(emdResults);
totalEMD = length(find(emdResults==1));
totalMSE = length(find(mseResults==1));
totalAmb = length(find(ambResults==1));

indexValues = (windowWidth/2):(length(movingEMD)+windowWidth/2-1);

emdAvgArray = (totalEMD/totalValues).*ones(1,length(indexValues));
mseAvgArray = (totalMSE/totalValues).*ones(1,length(indexValues));
ambAvgArray = (totalAmb/totalValues).*ones(1,length(indexValues));

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