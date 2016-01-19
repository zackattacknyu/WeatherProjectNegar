mseDiffs = mseOthers-mseBests;
emdDiffs = emdOthers-emdBests;
mseDiffs(isnan(emdDiffs))=NaN;

mseQuots = mseOthers./mseBests;
emdQuots = emdOthers./emdBests;
mseQuots(isnan(mseQuots))=NaN;

comparisonRaw1 = emdDiffs;
comparisonRaw2 = mseDiffs;

%emdDiffs(emdDiffs>20)=20;
comparisonRaw3 = emdDiffs./max(emdDiffs)+mseDiffs./max(mseDiffs);
%comparisonRaw3 = emdDiffs+mseDiffs;

comparisonRaw4 = emdDiffs-mseDiffs;
comparisonRaw5 = emdDiffs.*mseDiffs;
comparisonRaw6 = emdQuots.*mseQuots;


[sortedCompare1,inds1] = sort(comparisonRaw1);
[sortedCompare2,inds2] = sort(comparisonRaw2);
[sortedCompare3,inds3] = sort(comparisonRaw3);
[sortedCompare5,inds5] = sort(comparisonRaw5);

figure
hold on
plot(comparisonRaw3(inds3)./max(comparisonRaw3),'r-')
plot(comparisonRaw5(inds3)./max(comparisonRaw5),'b-')
legend('H values','H prime values')
hold off






