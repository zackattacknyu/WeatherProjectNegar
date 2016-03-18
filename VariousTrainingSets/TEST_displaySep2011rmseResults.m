
J4data = load('rmseValidationSep2011_J4rf9.mat');
J8data = load('rmseValidationSep2011_J8rf9.mat');
J16data = load('rmseValidationSep2011_J16rf9.mat');
J32data = load('rmseValidationSep2011_J32rf9.mat');
J64data = load('rmseValidationSep2011_J64rf9.mat');

J16dataOther = load('rmseValidationSep2011_J16rf8_other.mat');
J32dataOther = load('rmseValidationSep2011_J32rf8_other.mat');
J64dataOther = load('rmseValidationSep2011_J64rf8_other.mat');

indsToSee = 1:10;
figure
hold on
plot(J4data.rmseTestVals(indsToSee),'LineWidth',2);
plot(J8data.rmseTestVals(indsToSee),'LineWidth',2);
plot(J16data.rmseTestVals(indsToSee));
plot(J16dataOther.rmseTestVals(indsToSee),'LineWidth',3);
plot(J32data.rmseTestVals(indsToSee));
plot(J32dataOther.rmseTestVals(indsToSee),'LineWidth',3);
plot(J64data.rmseTestVals(indsToSee));
plot(J64dataOther.rmseTestVals(indsToSee),'LineWidth',3);

legend('4 leaf nodes',...
    '8 leaf nodes',...
    '16 leaf nodes',...
    '16 leaf nodes previous set',...
    '32 leaf nodes',...
    '32 leaf nodes previous set',...
    '64 leaf nodes',...
    '64 leaf nodes previous set',...
    'Location','eastoutside');

title('Test RMSE for Sep 2011 data');
hold off
%%

J4dataAvg = load('rmseTestSep2011Averaged_J4rf9.mat');
J8dataAvg = load('rmseTestSep2011Averaged_J8rf9.mat');
J4data = load('rmseValidationSep2011_J4rf9.mat');
J8data = load('rmseValidationSep2011_J8rf9.mat');
J16data = load('rmseValidationSep2011_J16rf9.mat');
J16dataAvg = load('rmseTestSep2011Averaged_J16rf9.mat');

indsToSee = 1:100;
figure
hold on
plot(J4data.rmseTestVals(indsToSee));
plot(J4dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J8data.rmseTestVals(indsToSee));
plot(J8dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J16data.rmseTestVals(indsToSee));
plot(J16dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
legend('4 leaf nodes','4 leaf nodes with Avg',...
    '8 leaf nodes','8 leaf nodes with Avg',...
    '16 leaf nodes','16 leaf nodes with Avg',...
    'Location','eastoutside');

title('Test RMSE for Sep 2011 data');
hold off
%%

J4dataAvg = load('rmseTestSep2011Averaged_J4rf9.mat');
J4dataAvg2 = load('rmseTestSep2011Averaged_J4rf5.mat');
J8dataAvg = load('rmseTestSep2011Averaged_J8rf9.mat');
J8dataAvg2 = load('rmseTestSep2011Averaged_J8rf5.mat');
%J4data = load('rmseValidationSep2011_J4rf9.mat');
%J8data = load('rmseValidationSep2011_J8rf9.mat');
%J16data = load('rmseValidationSep2011_J16rf9.mat');
%J16dataAvg = load('rmseTestSep2011Averaged_J16rf9.mat');

J2data = load('rmseValidationSep2011_J2rf5.mat');
J2dataAvg = load('rmseTestSep2011Averaged_J2rf5.mat');
J3data = load('rmseValidationSep2011_J3rf5.mat');
J3dataAvg = load('rmseTestSep2011Averaged_J3rf5.mat');

indsToSee = 1:10;
figure
hold on
plot(J2data.rmseTestVals(indsToSee));
plot(J2dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J3data.rmseTestVals(indsToSee));
plot(J3dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J4dataAvg.rmseTestVals(indsToSee));
plot(J4dataAvg2.rmseTestVals(indsToSee));
plot(J8dataAvg.rmseTestVals(indsToSee));
plot(J8dataAvg2.rmseTestVals(indsToSee));
legend('2 leaf nodes','2 leaf nodes avg','3 leaf nodes','3 leaf nodes avg',...
    '4 leaf, avg','4 leaf, avg 2','8 leaf, avg','8 leaf, avg 2',...
    'Location','eastoutside');

title('Test RMSE for Sep 2011 data');
hold off

%%

J4dataAvg = load('rmseTestSep2011Averaged_J4rf9.mat');
J4dataAvg2 = load('rmseTestSep2011Averaged_J4rf5.mat');
J8dataAvg = load('rmseTestSep2011Averaged_J8rf9.mat');
J8dataAvg2 = load('rmseTestSep2011Averaged_J8rf5.mat');
%J4data = load('rmseValidationSep2011_J4rf9.mat');
%J8data = load('rmseValidationSep2011_J8rf9.mat');
%J16data = load('rmseValidationSep2011_J16rf9.mat');
%J16dataAvg = load('rmseTestSep2011Averaged_J16rf9.mat');

J2data = load('rmseValidationSep2011_J2rf5.mat');
J2dataAvg = load('rmseTestSep2011Averaged_J2rf5.mat');
J3data = load('rmseValidationSep2011_J3rf5.mat');
J3dataAvg = load('rmseTestSep2011Averaged_J3rf5.mat');

load('baselineResults2.mat');

indsToSee = 1:10;
baseline = ones(size(indsToSee)).*rmseBaselineMeanYtrain;
figure
hold on
plot(baseline,'r--');
plot(J2dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J3dataAvg.rmseTestVals(indsToSee),'LineWidth',2);

plot(J4dataAvg.rmseTestVals(indsToSee),'r-');
plot(J4dataAvg2.rmseTestVals(indsToSee),'b-');
plot(J8dataAvg.rmseTestVals(indsToSee),'k-');
plot(J8dataAvg2.rmseTestVals(indsToSee),'g-');
%legend('baseline','4 leaf, avg','4 leaf, avg 2','8 leaf, avg','8 leaf, avg 2',...
%    'Location','eastoutside');
legend('baseline','2 leaf nodes avg','3 leaf nodes avg',...
    '4 leaf, avg','4 leaf, avg 2','8 leaf, avg','8 leaf, avg 2',...
    'Location','eastoutside');

title('Test RMSE for Sep 2011 data');
hold off

%%


J4dataAvg = load('rmseTestSep2011Averaged_J4rf9.mat');
J4dataAvg2 = load('rmseTestSep2011Averaged_J4rf5.mat');
J8dataAvg = load('rmseTestSep2011Averaged_J8rf9.mat');
J8dataAvg2 = load('rmseTestSep2011Averaged_J8rf5.mat');
%J4data = load('rmseValidationSep2011_J4rf9.mat');
%J8data = load('rmseValidationSep2011_J8rf9.mat');
%J16data = load('rmseValidationSep2011_J16rf9.mat');
%J16dataAvg = load('rmseTestSep2011Averaged_J16rf9.mat');

J2data = load('rmseValidationSep2011_J2rf5.mat');
J2dataAvg = load('rmseTestSep2011Averaged_J2rf5.mat');
J3data = load('rmseValidationSep2011_J3rf5.mat');
J3dataAvg = load('rmseTestSep2011Averaged_J3rf5.mat');

load('baselineResults2.mat');

indsToSee = 1:10;
baseline = ones(size(indsToSee)).*rmseBaselineMeanYtrain;
baseline2 = ones(size(indsToSee)).*stdData;
figure
hold on
plot(baseline,'r--');
plot(baseline2,'g--');
plot(J2dataAvg.rmseTestVals(indsToSee),'LineWidth',2);
plot(J3dataAvg.rmseTestVals(indsToSee),'LineWidth',2);

plot(J2data.rmseTestVals(indsToSee),'r-');
plot(J3data.rmseTestVals(indsToSee),'b-');

legend('baseline','baseline 2','2 leaf nodes avg','3 leaf nodes avg',...
    '2 leaf','3 leaf',...
    'Location','eastoutside');

title('Test RMSE for Sep 2011 data');
hold off