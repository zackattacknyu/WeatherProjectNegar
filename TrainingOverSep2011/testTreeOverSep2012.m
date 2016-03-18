
load('Sep2011SetupDataZach.mat');

load('sep2012TestDataSet_every4thT.mat');

rfVals = [5 9 10];
Jvals = [2 3 4];

for rf = rfVals
    rf
   for j = Jvals
       j
        load(['Sep2011Training_J' num2str(j) 'rf' num2str(rf) '_tree1.mat']);
        testNickTreeScript;

        save(['rmseValidationSep2012_J' num2str(j) 'rf' num2str(rf) '.mat'],'rmseTestVals');
   end
end




