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

files = dir('./daily/data_daily*');
l = length(files);

ccsErrors = zeros(1,l);
ccsAdjErrors = zeros(1,l);

for i = 1:l
    
    load(strcat('daily/',files(i).name));

    ccsUS = ccs_s(45:140,941:1172).*mask_US;
    ccsAdjUS = ccsadj_s(45:140,941:1172).*mask_US;
    pmwUS = pmw_s(45:140,941:1172).*mask_US;

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