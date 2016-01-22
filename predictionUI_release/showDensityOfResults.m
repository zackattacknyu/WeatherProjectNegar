option=3;

if(option==1)
    [x,i1] = sort(emdDiffs);
    [y,i2] = sort(mseDiffs);
    yName = 'Rank of EMD Difference Value';
    xName = 'Rank of MSE Difference Value';
elseif(option==2)
    [x,i1] = sort(emdBests);
    [y,i2] = sort(emdOthers);
    yName = 'Rank of EMD Best Value';
    xName = 'Rank of EMD Other Value';
elseif(option==3)
    [x,i1] = sort(mseBests);
    [y,i2] = sort(mseOthers);
    yName = 'Rank of MSE Best Value';
    xName = 'Rank of MSE Other Value';
elseif(option==4)
    [x,i1] = sort(emdBests);
    [y,i2] = sort(mseOthers);
    yName = 'Rank of EMD Best Value';
    xName = 'Rank of MSE Other Value';
elseif(option==5)
    [x,i1] = sort(emdOthers);
    [y,i2] = sort(mseBests);
    yName = 'Rank of EMD Other Value';
    xName = 'Rank of MSE Best Value';
else
    [x,i1] = sort(emdQuots);
    [y,i2] = sort(mseQuots);
    yName = 'Rank of EMD Quotient Value';
    xName = 'Rank of MSE Quotient Value';
end


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
   end
   
   if(selectionsSortedOrder(i)==2)
       resultsMSE(row,col)=1;
   end
   
   if(selectionsSortedOrder(i)==-2)
       resultsAmb(row,col)=1;
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
title('EMD Patch Chosen Probability in Neighborhood');
xlabel(xName);
ylabel(yName);
colorbar;

figure
imagesc(resultsAvgMSE./resultsAvgBase);
title('MSE Patch Chosen Probability in Neighborhood');
xlabel(xName);
ylabel(yName);
colorbar;

figure
imagesc(resultsAvgAmb./resultsAvgBase);
title('Amb Chosen Probability in Neighborhood');
xlabel(xName);
ylabel(yName);
colorbar;
