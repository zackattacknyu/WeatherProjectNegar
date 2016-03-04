
%load('oct2012TestDataSetAll.mat');
load('sep2011TestDataSetAll.mat');
load('tc_NickDecTreeResult_J64rf8.mat');

feaToUse = 1:size(Xtr,2);
[~,XTeOctPct,~] = XToPct(Xtr(:,feaToUse),XteOct(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTeOctPct = uint8(XTeOctPct);


preds = boostTreeVal3(boostStruct,boostArgs.nIter,uint8(XTeOctPct),boostArgs.v);

rmseTestVals = zeros(1,length(preds));
for ii = 1:length(preds)
    curYhat = preds{ii};
    rmseTestVals(ii) = sqrt(mean((curYhat-YteOct).^2));
end

save('rmseValidationSep2011_J64rf8_tmp.mat','rmseTestVals');
save('rmseValidationSep2011_J64rf8.mat','preds','rmseTestVals','-v7.3');

fileFound=false;
while ~fileFound
   try
        load('tc_NickDecTreeResult_J32rf8.mat');
        fileFound=true;
   catch
        fprintf('File Not Found. Will check again in 5 seconds...\n');
        pause(5);
   end
end
