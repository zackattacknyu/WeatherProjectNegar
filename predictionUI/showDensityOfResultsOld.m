%[x,i1] = sort(emdDiffs);
%[y,i2] = sort(mseDiffs);

[x,i1] = sort(emdQuots);
[y,i2] = sort(mseQuots);

%[x,i1] = sort(emdBests);
%[y,i2] = sort(emdOthers);

%[x,i1] = sort(mseBests);
%[y,i2] = sort(mseOthers);

resultsEMD = zeros(length(i1),length(i1));
resultsMSE = zeros(length(i1),length(i1));
resultsAmb = zeros(length(i1),length(i1));
resultsBase = zeros(length(i1),length(i1));
for i = 1:length(selectionsSortedOrder)
   row = i1(i);
   col = i2(i);
   resultsBase(row,col)=1;
   if(selectionsSortedOrder(i)==1)
       resultsEMD(row,col)=1;
   else
       %resultsEMD(row,col)=-1;
   end
   
   if(selectionsSortedOrder(i)==2)
       resultsMSE(row,col)=1;
   else
       %resultsMSE(row,col)=-1;
   end
   
   if(selectionsSortedOrder(i)==-2)
       resultsAmb(row,col)=1;
   else
       %resultsAmb(row,col)=-1;
   end
end

size = 300;
sigma = 50;

%gaussian used here to ensure smoothness
kernal = fspecial('gaussian',[size size],sigma);

kernal = kernal./sum(kernal(:));
resultsAvgEMD = conv2(resultsEMD,kernal,'valid');
resultsAvgMSE = conv2(resultsMSE,kernal,'valid');
resultsAvgAmb = conv2(resultsAmb,kernal,'valid');
resultsAvgBase = conv2(resultsBase,kernal,'valid');

%make sure no div by zero
resultsAvgBase(resultsAvgBase<1e-5)=1e-5;

figure
imagesc(resultsAvgEMD./resultsAvgBase);
title('EMD result density compared with normal density');
xlabel('MSE difference value');
ylabel('EMD difference value');
colorbar;

figure
imagesc(resultsAvgMSE./resultsAvgBase);
title('MSE result density compared with normal density');
xlabel('MSE difference value');
ylabel('EMD difference value');
colorbar;

figure
imagesc(resultsAvgAmb./resultsAvgBase);
title('Amb result density compared with normal density');
xlabel('MSE difference value');
ylabel('EMD difference value');
colorbar;
