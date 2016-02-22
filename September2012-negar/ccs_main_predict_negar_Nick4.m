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

%files = dir('goes/bghrus1209*');
files = dir('matFiles/data1210*');
load('tc_NickJ128rf8_iter10.mat');
ccs_main_predict_negar_Nick_script;
save('oct2012predictions_iter10_allInfo.mat','negarPredictionArray',...
    'nickPredictionArray','targetArray','negarTreeRMSE','nickTreeRMSE',...
    'negarBias','nickBias','negarBiasCoeff','nickBiasCoeff');



files = dir('matFiles/data1210*');
load('tc_NickJ128rf8_iter20.mat');
ccs_main_predict_negar_Nick_script;
save('oct2012predictions_iter20_allInfo.mat','negarPredictionArray',...
    'nickPredictionArray','targetArray','negarTreeRMSE','nickTreeRMSE',...
    'negarBias','nickBias','negarBiasCoeff','nickBiasCoeff');



files = dir('matFiles/data1210*');
load('tc_NickJ128rf8_iter50.mat');
ccs_main_predict_negar_Nick_script;
save('oct2012predictions_iter50_allInfo.mat','negarPredictionArray',...
    'nickPredictionArray','targetArray','negarTreeRMSE','nickTreeRMSE',...
    'negarBias','nickBias','negarBiasCoeff','nickBiasCoeff');

ccs_main_predict_negar_Nick_script;




%%
files = dir('matFiles/data1210*');
load('tc_NickJ128rf8_iter1.mat');
ccs_main_predict_negar_Nick_script;
save('oct2012predictions_iter1_allInfo.mat','negarPredictionArray',...
    'nickPredictionArray','targetArray','negarTreeRMSE','nickTreeRMSE',...
    'negarBias','nickBias','negarBiasCoeff','nickBiasCoeff');



files = dir('matFiles/data1210*');
load('tc_NickJ128rf8_iter2.mat');
ccs_main_predict_negar_Nick_script;
save('oct2012predictions_iter2_allInfo.mat','negarPredictionArray',...
    'nickPredictionArray','targetArray','negarTreeRMSE','nickTreeRMSE',...
    'negarBias','nickBias','negarBiasCoeff','nickBiasCoeff');



files = dir('matFiles/data1210*');
load('tc_NickJ128rf8_iter5.mat');
ccs_main_predict_negar_Nick_script;
save('oct2012predictions_iter5_allInfo.mat','negarPredictionArray',...
    'nickPredictionArray','targetArray','negarTreeRMSE','nickTreeRMSE',...
    'negarBias','nickBias','negarBiasCoeff','nickBiasCoeff');

ccs_main_predict_negar_Nick_script;