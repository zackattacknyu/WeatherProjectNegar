
for JVALUE = [4 8 16]
    load('decTreeSepOct2012.mat');
    load('sep2011TestDataSetAll.mat');

    testMultNickTreeScript;

    save(['rmseTestSep2011Averaged_J' num2str(JVALUE) 'rf9.mat'],...
        'rmseTestVals');
end



%{
J4data = load('rmseValidationSep2011_J4rf9.mat');
J8data = load('rmseValidationSep2011_J8rf9.mat');
J16data = load('rmseValidationSep2011_J16rf9.mat');
J32data = load('rmseValidationSep2011_J32rf9.mat');
J64data = load('rmseValidationSep2011_J64rf9.mat');

J16dataOther = load('rmseValidationSep2011_J16rf8_other.mat');
J32dataOther = load('rmseValidationSep2011_J32rf8_other.mat');
J64dataOther = load('rmseValidationSep2011_J64rf8_other.mat');

figure
hold on
plot(J4data.rmseTestVals);
plot(J8data.rmseTestVals);
plot(J16data.rmseTestVals);
plot(J16dataOther.rmseTestVals,'LineWidth',3);
plot(J32data.rmseTestVals);
plot(J32dataOther.rmseTestVals,'LineWidth',3);
plot(J64data.rmseTestVals);
plot(J64dataOther.rmseTestVals,'LineWidth',3);
legend('4 leaf nodes','8 leaf nodes','16 leaf nodes',...
    '16 leaf nodes previous set',...
    '32 leaf nodes',...
    '32 leaf nodes previous set',...
    '64 leaf nodes',...
    '64 leaf nodes previous set',...
    'Location','eastoutside');
title('Test RMSE for Sep 2011 data');
hold off
%}