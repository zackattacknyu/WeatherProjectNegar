
%{
Codes to use for aa:

-1 = save for later
0 = none selected

1 = middle selected
2 = right selected
-2 = ambiguous

%}
%%

dataSetNumber=1;

numString = num2str(dataSetNumber);
loadFileName = strcat('patchesSet11-23Data_',numString,'.mat');
loadResultsFileName = strcat('patchesSet11-23Data_',numString,'_results.mat');

getDispPatchesScript
%%
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
close all force
selections(selections==-1)=0;
%%
numEMD = length(find(selections==1));
numMSE = length(find(selections==2));
numAmbig = length(find(selections==-2));
names = {'EMD' 'MSE' 'Ambiguous'};
results = [numEMD numMSE numAmbig];
results = results./sum(results);
bar(results,names);



