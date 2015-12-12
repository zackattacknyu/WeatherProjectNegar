dataSetNumber=3;

numString = num2str(dataSetNumber);
loadFileName = strcat('patchesSet11-23Data_',numString,'.mat');
loadResultsFileName = strcat('patchesSet11-23Data_',numString,'_results.mat');

load(loadFileName);
load(loadResultsFileName);
%%
ccs_predictions_filterErrors

%%
%MSE parameters for good ones
primaryErrorThreshold = 2; %if error is less than this, then error function thinks it nailed it
otherErrorThreshold = 2; %error for other one must be more than this to be considered
useEMD=false; %order by EMD if true. MSE if false
goodPatches = true;
ccs_predictions_analyzeErrors_CURRENT

%%

%EMD parameters for good ones
primaryErrorThreshold = 3; %if error is less than this, then error function thinks it nailed it
otherErrorThreshold = 12; %error for other one must be more than this to be considered
useEMD=true; %order by EMD if true. MSE if false
goodPatches = true;
ccs_predictions_analyzeErrors_CURRENT



