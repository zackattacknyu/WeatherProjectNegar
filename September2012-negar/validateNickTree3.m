J16data = load('rmseValidationSep2011_J16rf8_tmp.mat');
J32data = load('rmseValidationSep2011_J32rf8_tmp.mat');
J64data = load('rmseValidationSep2011_J64rf8_tmp.mat');

figure
hold on
plot(J16data.rmseTestVals,'r-');
plot(J32data.rmseTestVals,'b-');
plot(J64data.rmseTestVals,'g-');
legend('16 leaf nodes','32 leaf nodes','64 leaf nodes','Location','eastoutside');
title('Validation RMSE for Sep 2011 data');
hold off

J16data2 = load('rmseValidationOct2012_J16rf8_tmp.mat');
J32data2 = load('rmseValidationOct2012_J32rf8_tmp.mat');
J64data2 = load('rmseValidationOct2012_J64rf8_tmp.mat');

figure
hold on
plot(J16data2.rmseTestVals,'r-');
plot(J32data2.rmseTestVals,'b-');
plot(J64data2.rmseTestVals,'g-');
legend('16 leaf nodes','32 leaf nodes','64 leaf nodes','Location','eastoutside');
title('Validation RMSE for Oct 2012 data');
hold off