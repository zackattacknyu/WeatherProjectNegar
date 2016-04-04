%{
Taken from the following:
https://en.wikipedia.org/wiki/Standard_error#Standard_error_of_the_mean

as well as this:
http://www.statlect.com/fundamentals-of-statistics/mean-estimation
%}

%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_new1.mat');
load('patchesSep2011Data_results_allT_new1.mat');
load('patchesSep2011Data_allT_new1.mat');


numPatches = size(predErrorsEMD,2);
Wvalues = mean(totalWorkEMD,2);
Wpred1 = Wvalues(1);
Wpred2 = Wvalues(2);

numTrials = 10;
meanWbar1 = zeros(numTrials,size(predErrorsEMD,2));
meanWbar2 = zeros(numTrials,size(predErrorsEMD,2));

varWbar1 = zeros(numTrials,size(predErrorsEMD,2));
varWbar2 = zeros(numTrials,size(predErrorsEMD,2));

for trialN = 1:numTrials
    randPatches = randperm(numPatches);
    %randPatchesUse = [];
    for k = 1:numPatches
        randPatchesUse = randPatches(1:k);
        %randPatchesUse = [randPatchesUse ceil(numPatches*rand(1,1))];
        workSampled = totalWorkEMD(:,randPatchesUse);
        
        meanVals = mean(workSampled,2);
        varVals = var(workSampled,[],2)./k;
        
        
        meanWbar1(trialN,k) = meanVals(1);      
        meanWbar2(trialN,k) = meanVals(2);
        
        varWbar1(trialN,k) = varVals(1);      
        varWbar2(trialN,k) = varVals(2);
    end
    
    
end
%%
startColInd = 1000;
dispRows = 1:10;
lineWidth=3;

minYp1 = min(min(meanWbar1(dispRows,startColInd:end)));
maxYp1 = max(max(meanWbar1(dispRows,startColInd:end)));

minYp2 = min(min(meanWbar2(dispRows,startColInd:end)));
maxYp2 = max(max(meanWbar2(dispRows,startColInd:end)));

minY = min([minYp1 minYp2]);
maxY = max([maxYp1 maxYp2]);

minVar1 = min(min(varWbar1(dispRows,startColInd:end)));
maxVar1 = max(max(varWbar1(dispRows,startColInd:end)));

minVar2 = min(min(varWbar2(dispRows,startColInd:end)));
maxVar2 = max(max(varWbar2(dispRows,startColInd:end)));

minVar = min([minVar1 minVar2]);
maxVar = max([maxVar1 maxVar2]);

figure
title('Wbar values for Mean');
hold on
plot(meanWbar1(dispRows,:)','b') 
plot(meanWbar2(dispRows,:)','r')  
plot(Wpred1.*ones(1,numPatches),'k--','LineWidth',lineWidth);
plot(Wpred2.*ones(1,numPatches),'k--','LineWidth',lineWidth);
axis([startColInd numPatches minY maxY]);
xlabel('k value');
ylabel('W_k value');
hold off

figure
title('Wbar Variance');
hold on
plot(varWbar1(dispRows,:)','b') 
plot(varWbar2(dispRows,:)','r')  
axis([startColInd numPatches minVar maxVar]);
xlabel('k value');
ylabel('Variance value');
hold off

