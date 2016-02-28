%{
NOTE ABOUT TC.MAT
It was trained over every 4th timestep (every 2 hours)
    with the radar and ir data
    for Sep 2012
Every 4th timestep was used, they were NOT accumulated
%}

% PERSIANN-CCS decision tree added
% Negar Karbalaee
% February 2016

% First of all we should load tc which is an object for
% model predi

%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

load('tc_NickJ128rf8_iter500_treeOnly.mat');
ccs_main_predict_negar_Nick_script_2011_v2;
save('sep2011predictions_iter500_allInfo.mat','negarPredictionArray',...
    'nickPredictionArray','targetArray','negarTreeRMSE','nickTreeRMSE',...
    'negarBias','nickBias','negarBiasCoeff','nickBiasCoeff');
