
%{
Codes to use for aa:

-1 = save for later
0 = none selected

1 = middle selected
2 = right selected
-2 = ambiguous

%}
%%

dataSetNumber=2;

numString = num2str(dataSetNumber);
loadFileName = strcat('patchesSet11-23Data_',numString,'.mat');
loadResultsFileName = strcat('patchesSet11-23Data_',numString,'_results.mat');

getDispPatchesScript
%%
try
    load('currentResultData.mat');
catch
    selections = zeros(1,size(dispPatches,2));
end

remainingPatches = 1;

while(~isempty(remainingPatches))

    remainingPatches = find(selections==0); %-1 values are changed to zero so we don't need to care here
    remainingPatches = remainingPatches(randperm(length(remainingPatches)));
    for i = 1:length(remainingPatches)
        j = remainingPatches(i);
        patchSet = dispPatches(:,j);
        if(rand>0.5) %flip order of them
            patchSet2 = {patchSet{1},patchSet{3},patchSet{2}};
            aa = bestPredUI(patchSet2);
            if(aa==1)
                aa=2;
            elseif(aa==2) 
                aa=1;
            end
        else
            aa = bestPredUI(patchSet);
        end
        selections(j) = aa;
        if(aa == 0)
            break;
        end
        %uiwait
    end
    
    selections(selections==-1)=0;
    
    
    if(aa==0)
       break; 
    end
    
end
close all force

if(isempty(remainingPatches))
    saveFileName = strcat('resultData_',num2str(floor(now)),'_',num2str(floor(rem(now,1)*10000)));
else
    saveFileName = 'currentResultData.mat';
end

save(saveFileName,'selections');

%%
numEMD = length(find(selections==1));
numMSE = length(find(selections==2));
numAmbig = length(find(selections==-2));
results = [numEMD numMSE numAmbig];
results = results./sum(results);
figure
bar(results);
title('Frequency of each patch choice option');
xlabel('Option Chosen: 1-EMD 2-MSE 3-Ambiguous');
ylabel('Fraction of Choices');
%%
resultEntries = find(selections~=0);
resultVals = selections(resultEntries);

binSize=20;
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






