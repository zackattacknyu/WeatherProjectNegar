
%RUN POSTPROCESSELECTIONS.M FIRST BEFORE RUNNING THIS
%   MAKE THE COMPAREMETHOD=14

%the sum of accumulation
patchesSum = sortedCompare;

emdAccumArray = patchesSum.*emdResults;
mseAccumArray = patchesSum.*mseResults;
ambAccumArray = patchesSum.*ambResults;

totalEMDaccum = sum(emdAccumArray);
totalMSEaccum = sum(mseAccumArray);
totalAmbAccum = sum(ambAccumArray);

totalEMDaccum/sum(patchesSum)
totalMSEaccum/sum(patchesSum)
totalAmbAccum/sum(patchesSum)

figure
hold on
plot(sortedCompare./max(sortedCompare))
plot(indexValues,movingEMD,'r-');
plot(indexValues,emdAvgArray,'r--');
plot(indexValues,movingMSE,'g-');
plot(indexValues,mseAvgArray,'g--');
plot(indexValues,movingAmb,'b-');
plot(indexValues,ambAvgArray,'b--');
hold off
xlabel('Ranking in List');
ylabel('Probability Of Selection in Window');
legend('Accumulation Amount Relative to Max','EMD Prob','Avg EMD Prob','MSE Prob','Avg MSE Prob',...
    'Amb Prob','Avg Amb Prob','Location','eastoutside');