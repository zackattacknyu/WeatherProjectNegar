
%load('oct2012TestDataSetAll.mat');
fprintf('Loading Validation Set...\n');
load('sep2011TestDataSetAll.mat');
fprintf('Validation Set loaded, loading tree information...\n');
load('tc_NickDecTreeResult_J32rf8.mat');

feaToUse = 1:size(Xtr,2);
[~,XTeOctPct,~] = XToPct(Xtr(:,feaToUse),XteOct(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTeOctPct = uint8(XTeOctPct);

numIterToSee = 100;
fprintf('Computing predictions...\n');
preds = boostTreeVal3(boostStruct,numIterToSee,uint8(XTeOctPct),boostArgs.v);

fprintf('Predictions computed\n');
rmseTestVals = zeros(1,length(preds));
for ii = 1:length(preds)
    curYhat = preds{ii};
    rmseTestVals(ii) = sqrt(mean((curYhat-YteOct).^2));
end

save('rmseValidationSep2011_J32rf8_valsOnly.mat','rmseTestVals');
save('rmseValidationSep2011_J32rf8.mat','preds','rmseTestVals','-v7.3');

