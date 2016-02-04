load('mask_US.mat');
load('data_monthly1201.mat');
ccsUS = ccs_s(45:140,941:1172).*mask_US;
ccsAdjUS = ccsadj_s(45:140,941:1172).*mask_US;
pmwUS = pmw_s(45:140,941:1172).*mask_US;

ccsErrorArray = abs(ccsUS(:)-pmwUS(:));
ccsErrorArray(isnan(ccsErrorArray))=0;
ccsError = sqrt(mean(ccsErrorArray.^2));

ccsAdjErrorArray = abs(ccsAdjUS(:)-pmwUS(:));
ccsAdjErrorArray(isnan(ccsAdjErrorArray))=0;
ccsAdjError = sqrt(mean(ccsAdjErrorArray.^2));