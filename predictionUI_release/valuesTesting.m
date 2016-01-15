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
%%

[x,i1] = sort(emdDiffs);
[y,i2] = sort(mseDiffs);
results = zeros(length(i1),length(i1));
for i = 1:length(i1)
   row = i1(i);
   col = i2(i);
   results(row,col)=1;
end

size = 300;
sigma = 50;
kernal = fspecial('gaussian',[size size],sigma);
kernal = kernal./sum(kernal(:));
resultsAvg = conv2(results,kernal,'valid');
figure
imagesc(resultsAvg);
colorbar;

%scatter3(log(emdDiffs),log(mseDiffs),ones(1,length(emdDiffs)));
%%

%DO NOT USE BECAUSE LOW VALUES ARE OVER-REPRESENTED
emdAsInds = floor(1000*log((emdDiffs+1)))+1;
mseAsInds = floor(1000*log((mseDiffs+1)))+1;
goodInds = find(~isnan(emdAsInds));
emdAsInds = emdAsInds(goodInds);
mseAsInds = mseAsInds(goodInds);

results = zeros(max(emdAsInds),max(mseAsInds));
for i = 1:length(emdAsInds)
   row = emdAsInds(i);
   col = mseAsInds(i);
   results(row,col)=1;
end

size = 300;
sigma = 50;
kernal = fspecial('gaussian',[size size],sigma);
kernal = kernal./sum(kernal(:));
resultsAvg = conv2(results,kernal,'valid');
figure
imagesc(resultsAvg);
colorbar;

%%
figure
hold on
plot(comparisonRaw1(inds2)./max(comparisonRaw1),'r-')
plot(comparisonRaw2(inds2)./max(comparisonRaw2),'b-')
legend('EMD diff value scaled','MSE diff value scaled')
hold off
%%

comparisonRaw1scaled = comparisonRaw1(~isnan(comparisonRaw1));
comparisonRaw1scaled = (comparisonRaw1scaled-mean(comparisonRaw1scaled))./std(comparisonRaw1scaled);

comparisonRaw2scaled = comparisonRaw2(~isnan(comparisonRaw2));
comparisonRaw2scaled = (comparisonRaw2scaled-mean(comparisonRaw2scaled))./std(comparisonRaw2scaled);

%%

values = sort(randn(1,40));
%plot(values);
values2=(values-mean(values))./std(values);
plot(values2);

