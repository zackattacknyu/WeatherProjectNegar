load('patchesSetData.mat');

getDispPatchesScript

selections = zeros(1,size(dispPatches,2));

remainingPatches = find(selections==0);

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

saveFileName = strcat('sendThisToZach_',num2str(floor(now)),'_',num2str(floor(rem(now,1)*10000)));
save(saveFileName,'selections');

numEMD = length(find(selections==1));
numMSE = length(find(selections==2));
numAmbig = length(find(selections==-2));
results = [numEMD numMSE numAmbig];
results = results./sum(results);
figure
bar(results);
title('Frequency of each option');
xlabel('Option Chosen: 1-EMD 2-MSE 3-Ambiguous');
ylabel('Fraction of Choices');



