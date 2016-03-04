
%load('oct2012TestDataSetAll.mat');
fprintf('Starting...\n');
load('sep2011TestDataSetAll.mat');
fprintf('Validation Data loaded...\n');
load('tc_NickDecTreeResult_J64rf8.mat');
fprintf('Tree loaded...\n');

validateNickTreeScript;

fprintf('Results found...\n');
save('rmseValidationSep2011_J64rf8_tmp.mat','rmseTestVals');
%save('rmseValidationSep2011_J64rf8.mat','preds','rmseTestVals','-v7.3');

%%%%%%%%%%%%%%%%

fileFound=false;
while ~fileFound
   try
        load('tc_NickDecTreeResult_J32rf8.mat');
        fileFound=true;
        fprintf('J 32 file found...\n');
   catch
        fprintf('J32 File Not Found. Will check again in 5 seconds...\n');
        pause(5);
   end
end

load('sep2011TestDataSetAll.mat');
fprintf('Validation Data loaded...\n');
load('tc_NickDecTreeResult_J32rf8.mat');
fprintf('Tree loaded...\n');

validateNickTreeScript;

save('rmseValidationSep2011_J32rf8_tmp.mat','rmseTestVals');
%save('rmseValidationSep2011_J32rf8.mat','preds','rmseTestVals','-v7.3');

%%%%%%%%%%%%%%%%%

fileFound=false;
while ~fileFound
   try
        load('tc_NickDecTreeResult_J16rf8.mat');
        fprintf('J 16 file found...\n');
        fileFound=true;
   catch
        fprintf('File Not Found. Will check again in 5 seconds...\n');
        pause(5);
   end
end

load('sep2011TestDataSetAll.mat');
fprintf('Validation Data loaded...\n');
load('tc_NickDecTreeResult_J16rf8.mat');
fprintf('Tree loaded...\n');

validateNickTreeScript;

save('rmseValidationSep2011_J16rf8_tmp.mat','rmseTestVals');
%save('rmseValidationSep2011_J16rf8.mat','preds','rmseTestVals','-v7.3');