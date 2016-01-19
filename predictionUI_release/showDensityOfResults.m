[x,i1] = sort(emdDiffs);
[y,i2] = sort(mseDiffs);
resultsEMD = zeros(length(i1),length(i1));
resultsMSE = zeros(length(i1),length(i1));
resultsAmb = zeros(length(i1),length(i1));
resultsBase = zeros(length(i1),length(i1));
for i = 1:length(selectionsSortedOrder)
   row = i1(i);
   col = i2(i);
   resultsBase(row,col)=1;
   resultsEMD(row,col)=(selectionsSortedOrder(i)==1);
   resultsMSE(row,col)=(selectionsSortedOrder(i)==2);
   resultsAmb(row,col)=(selectionsSortedOrder(i)==-2);
end

size = 300;
sigma = 50;
kernal = fspecial('gaussian',[size size],sigma);
kernal = kernal./sum(kernal(:));
resultsAvgEMD = conv2(resultsEMD,kernal,'valid');
resultsAvgMSE = conv2(resultsMSE,kernal,'valid');
resultsAvgAmb = conv2(resultsAmb,kernal,'valid');
resultsAvgBase = conv2(resultsBase,kernal,'valid');

figure
imagesc(resultsAvgEMD-resultsAvgBase);
title('EMD result density compared with normal density');
xlabel('MSE difference value');
ylabel('EMD difference value');
colorbar;

figure
imagesc(resultsAvgMSE-resultsAvgBase);
title('MSE result density compared with normal density');
xlabel('MSE difference value');
ylabel('EMD difference value');
colorbar;

figure
imagesc(resultsAvgAmb-resultsAvgBase);
title('Amb result density compared with normal density');
xlabel('MSE difference value');
ylabel('EMD difference value');
colorbar;
