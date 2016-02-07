%{
Jan 2012:
CCS RMSE - 9.6839
CCS Adj RMSE - 3.7307

July 2012:
CCS RMSE - 11.5094
CCS Adj RMSE - 10.4060
%}

load('mask_US.mat');

%load('data_monthly1207.mat');
%files = dir('./daily/data_daily*');
files = dir('./data/data_hrly*');

l = length(files);

ccsErrors = zeros(1,l);
ccsAdjErrors = zeros(1,l);

for i = 1:l
    i
    
    %load(strcat('daily/',files(i).name));
    load(strcat('data/',files(i).name));

    %ccsUS = ccs_s(45:140,941:1172).*mask_US;
    %ccsAdjUS = ccsadj_s(45:140,941:1172).*mask_US;
    %pmwUS = pmw_s(45:140,941:1172).*mask_US;
    
    ccsUS = ccs(45:140,941:1172).*mask_US;
    ccsAdjUS = ccsadj(45:140,941:1172).*mask_US;
    pmwUS = pmw(45:140,941:1172).*mask_US;

    ccsErrorArray = abs(ccsUS(:)-pmwUS(:));
    ccsErrorArray(isnan(ccsErrorArray))=0;
    ccsErrors(i) = sqrt(mean(ccsErrorArray.^2));

    ccsAdjErrorArray = abs(ccsAdjUS(:)-pmwUS(:));
    ccsAdjErrorArray(isnan(ccsAdjErrorArray))=0;
    ccsAdjErrors(i) = sqrt(mean(ccsAdjErrorArray.^2));

end

%%


figure
hold on
plot(ccsErrors,'g-');
plot(ccsAdjErrors,'r-');
legend('CCS Errors','CCS Adj Errors');
hold off


[~,ccsInds] = sort(ccsErrors);
[~,ccsAdjInds] = sort(ccsAdjErrors);

figure
hold on
plot(ccsErrors(ccsInds),'g-');
plot(ccsAdjErrors(ccsInds),'r-');
legend('CCS Errors','CCS Adj Errors');
hold off

figure
hold on
plot(ccsErrors(ccsAdjInds),'g-');
plot(ccsAdjErrors(ccsAdjInds),'r-');
legend('CCS Errors','CCS Adj Errors');
hold off
%%


ccsEMDerrors = predErrorsEMD(1,:);
ccsAdjEMDerrors = predErrorsEMD(2,:);
ccsMSEerrors = predErrorsMSE(1,:);
ccsAdjMSEerrors = predErrorsMSE(2,:);

figure
hold on
plot(log(sort(ccsEMDerrors)));
plot(log(sort(ccsAdjEMDerrors)));
hold off
legend('CCS EMD','CCS Adj EMD');

figure
hold on
plot(log(sort(ccsMSEerrors)));
plot(log(sort(ccsAdjMSEerrors)));
hold off
legend('CCS MSE','CCS Adj MSE');