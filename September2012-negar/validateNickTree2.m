%{
load('oct2012TestDataSetAll.mat');
load('tc_NickDecTreeResult_J64rf8.mat');

validateNickTreeScript;

save('rmseValidationOct2012_J64rf8_tmp.mat','rmseTestVals');
save('rmseValidationOct2012_J64rf8.mat','preds','rmseTestVals','-v7.3');

%}

fileFound=false;
while ~fileFound
   try
        load('tc_NickDecTreeResult_J32rf8.mat');
        fileFound=true;
        fprintf('File J32 Found\n');
   catch
        fprintf('File Not Found. Will check again in 5 seconds...\n');
        pause(5);
   end
end

load('oct2012TestDataSetAll.mat');
load('tc_NickDecTreeResult_J32rf8.mat');

validateNickTreeScript;

save('rmseValidationOct2012_J32rf8_tmp.mat','rmseTestVals');
%save('rmseValidationOct2012_J32rf8.mat','preds','rmseTestVals','-v7.3');

%%%%%%%%%%%%%%%%%

fileFound=false;
while ~fileFound
   try
        load('tc_NickDecTreeResult_J16rf8.mat');
        fileFound=true;
        fprintf('File J16 Found\n');
   catch
        fprintf('File Not Found. Will check again in 5 seconds...\n');
        pause(5);
   end
end

load('oct2012TestDataSetAll.mat');
load('tc_NickDecTreeResult_J16rf8.mat');

validateNickTreeScript;

save('rmseValidationOct2012_J16rf8_tmp.mat','rmseTestVals');
%save('rmseValidationOct2012_J16rf8.mat','preds','rmseTestVals','-v7.3');