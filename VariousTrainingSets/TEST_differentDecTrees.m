

fprintf('Loading Sep Oct 2012 Decision Tree...\n');
load('decTreeSepOct2012.mat','tc');

fprintf('Loading Sep 2011 Data...\n');
load('sep2011TestDataSetAll2.mat','XteOct','YteOct');
fprintf('Now computing test error over Sep 2011 Data...\n');
decTreeRMSE = sqrt(mse(tc,XteOct,YteOct));

save('decTreeSepOct2012_testRMSE','decTreeRMSE');

fprintf('Loading Sep 2012 Decision Tree...\n');
load('origSep2012Data.mat','tc');

fprintf('Loading Sep 2011 Data...\n');
load('sep2011TestDataSetAll2.mat','XteOct','YteOct');
fprintf('Now computing test error over Sep 2011 Data...\n');
decTreeRMSE = sqrt(mse(tc,XteOct,YteOct));

save('decTreeSep2012_testRMSE','decTreeRMSE');
fprintf('Finished\n');