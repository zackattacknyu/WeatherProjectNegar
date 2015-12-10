load('patchesSet11-23Data_3_results.mat');
load('patchesSet11-23Data_3.mat');
%%
ccs_predictions_filterErrors

%%
%MSE parameters for good ones
primaryErrorThreshold = 2; %if error is less than this, then error function thinks it nailed it
otherErrorThreshold = 2; %error for other one must be more than this to be considered
useEMD=false; %order by EMD if true. MSE if false
goodPatches = true;
ccs_predictions_analyzeErrors_12_11

%%

%EMD parameters for good ones
primaryErrorThreshold = 3; %if error is less than this, then error function thinks it nailed it
otherErrorThreshold = 12; %error for other one must be more than this to be considered
useEMD=true; %order by EMD if true. MSE if false
goodPatches = true;
ccs_predictions_analyzeErrors_12_11

%%

%MSE parameters for bad ones
primaryErrorThreshold = 20; %if error is greater than this, error function says prediction is terrible
otherErrorThreshold = 8; %error for other one must be less than this to be considered
useEMD=false; %order by EMD if true. MSE if false
goodPatches=false;
ccs_predictions_analyzeErrors_12_11

%%

%EMD parameters for bad ones
primaryErrorThreshold = 40; %if error is greater than this, error function says prediction is terrible
otherErrorThreshold = 10; %error for other one must be less than this to be considered
useEMD=true; %order by EMD if true. MSE if false
goodPatches=false;
ccs_predictions_analyzeErrors_12_11


