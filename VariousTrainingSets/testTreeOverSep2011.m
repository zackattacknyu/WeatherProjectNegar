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

J4data = load('rmseValidationSep2011_J4rf9.mat');
J8data = load('rmseValidationSep2011_J8rf9.mat');
J16data = load('rmseValidationSep2011_J16rf9.mat');
J32data = load('rmseValidationSep2011_J32rf9.mat');
J64data = load('rmseValidationSep2011_J64rf9.mat');

figure
hold on
plot(J4data.rmseTestVals,'c-');
plot(J8data.rmseTestVals,'g-');
plot(J16data.rmseTestVals,'r-');
plot(J32data.rmseTestVals,'b-');
plot(J64data.rmseTestVals,'k-');
legend('4 leaf nodes','8 leaf nodes','16 leaf nodes',...
    '32 leaf nodes','64 leaf nodes',...
    'Location','eastoutside');
title('Test RMSE for Sep 2011 data');
hold off
%}