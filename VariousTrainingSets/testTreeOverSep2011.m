%{
load('decTreeSepOct2012.mat');
load('SepOct2012Training_J16rf9_tree1.mat');
load('sep2011TestDataSetAll2.mat');

testNickTreeScript;

save('rmseValidationSep2011_J16rf9.mat','rmseTestVals');

%%%%%%%%%%%%%%%%%

load('decTreeSepOct2012.mat');
load('SepOct2012Training_J32rf9_tree1.mat');
load('sep2011TestDataSetAll.mat');

testNickTreeScript;

save('rmseValidationSep2011_J32rf9.mat','rmseTestVals');


load('decTreeSepOct2012.mat');
load('SepOct2012Training_J8rf9_tree1.mat');
load('sep2011TestDataSetAll2.mat');

testNickTreeScript;

save('rmseValidationSep2011_J8rf9.mat','rmseTestVals');

%%%%%%%%%%%%%%%%%

load('decTreeSepOct2012.mat');
load('SepOct2012Training_J64rf9_tree1.mat');
load('sep2011TestDataSetAll.mat');

testNickTreeScript;

save('rmseValidationSep2011_J64rf9.mat','rmseTestVals');



load('decTreeSepOct2012.mat');
load('SepOct2012Training_J4rf9_tree1.mat');
load('sep2011TestDataSetAll.mat');

testNickTreeScript;

save('rmseValidationSep2011_J4rf9.mat','rmseTestVals');
%}

J4dataAvg = load('rmseTestSep2011Averaged_J4rf9.mat');
J8dataAvg = load('rmseTestSep2011Averaged_J8rf9.mat');
J4data = load('rmseValidationSep2011_J4rf9.mat');
J8data = load('rmseValidationSep2011_J8rf9.mat');
J16data = load('rmseValidationSep2011_J16rf9.mat');
J16dataAvg = load('rmseTestSep2011Averaged_J16rf9.mat');
J32data = load('rmseValidationSep2011_J32rf9.mat');
J64data = load('rmseValidationSep2011_J64rf9.mat');

J16dataOther = load('rmseValidationSep2011_J16rf8_other.mat');
J32dataOther = load('rmseValidationSep2011_J32rf8_other.mat');
J64dataOther = load('rmseValidationSep2011_J64rf8_other.mat');

indsToSee = 1:10;
figure
hold on
plot(J4dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J4data.rmseTestVals(indsToSee));
plot(J8dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J8data.rmseTestVals(indsToSee));
plot(J16dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J16data.rmseTestVals(indsToSee));
%plot(J16dataOther.rmseTestVals(indsToSee),'LineWidth',3);
plot(J32data.rmseTestVals(indsToSee));
%plot(J32dataOther.rmseTestVals(indsToSee),'LineWidth',3);
%plot(J64data.rmseTestVals(indsToSee));
%plot(J64dataOther.rmseTestVals(indsToSee),'LineWidth',3);
legend('4 leaf nodes avg','4 leaf nodes','8 leaf nodes avg',...
    '8 leaf nodes','16 leaf nodes avg',...
    '16 leaf nodes',...
    '32 leaf nodes',...
    'Location','eastoutside');
%{
legend('4 leaf nodes avg','4 leaf nodes','8 leaf nodes avg',...
    '8 leaf nodes',...
    '16 leaf nodes',...
    '16 leaf nodes previous set',...
    '32 leaf nodes',...
    '32 leaf nodes previous set',...
    '64 leaf nodes',...
    '64 leaf nodes previous set',...
    'Location','eastoutside');
    %}
title('Test RMSE for Sep 2011 data');
hold off

%%


figure
hold on
plot(J4dataAvg.rmseTestVals);
plot(J4data.rmseTestVals);
legend('4 leaf nodes avg','4 leaf nodes','Location','eastoutside');
title('Test RMSE for Sep 2011 data');
hold off
%%
J8data = load('rmseValidationSep2011_J8rf9.mat');
J8dataAvg = load('rmseTestSep2011Averaged_J8rf9.mat');
figure
hold on
plot(J8dataAvg.rmseTestVals);
plot(J8data.rmseTestVals);
legend('8 leaf nodes avg','8 leaf nodes','Location','eastoutside');
title('Test RMSE for Sep 2011 data');
hold off
