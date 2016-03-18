load('Sep2011SetupDataZach.mat');
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);


boostArgs.v = 0.5; 
rf = 0.5; J = 32;
boostArgs.funargs = {rf J};

boostArgs.nIter = 1000;
boostArgs.evaliter = 1:boostArgs.nIter;
totalTreesToTrain = 8;

Jvals = [2 3 4 8];
rfVals = [0.5 0.9 1];
rfDisp = [5 9 10];
dirStr = 'C:/Users/Zach/Google Drive/WeatherProject/computed/';
for i = 1:totalTreesToTrain
    
    i
    
    for jj = 1:length(Jvals)
        
        curJ = Jvals(jj)
        
        for kk = 1:length(rfVals)
            rf = rfVals(kk);
            boostArgs.funargs = {rf curJ};


           fileStr = ['Sep2011Training_J' num2str(curJ) 'rf' num2str(rfDisp(kk)) '_tree' num2str(i) '.mat'];


            [perfTrain,perfTest,boostStruct] = ...
                BoostLSFixed(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);

            save(fileStr,'perfTrain','perfTest','boostStruct','boostArgs');

            save([dirStr fileStr],'perfTrain','perfTest','boostStruct','boostArgs');

        end
    end
end

