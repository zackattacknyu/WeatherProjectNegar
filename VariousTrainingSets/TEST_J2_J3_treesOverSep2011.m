
load('decTreeSepOct2012.mat');
load('SepOct2012Training_J2rf5_tree1.mat');
load('sep2011TestDataSetAll2.mat');

testNickTreeScript;

save('rmseValidationSep2011_J2rf5.mat','rmseTestVals');

%%%%%%%%%%%%%%%%%

load('decTreeSepOct2012.mat');
load('SepOct2012Training_J3rf5_tree1.mat');
load('sep2011TestDataSetAll.mat');

testNickTreeScript;

save('rmseValidationSep2011_J3rf5.mat','rmseTestVals');
