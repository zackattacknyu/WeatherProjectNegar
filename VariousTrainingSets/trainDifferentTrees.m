load('decTreeSepOct2012.mat');
feaToUse = 1:size(Xtr,2);
[XTrPct,XTePct,binLocs] = XToPct(Xtr(:,feaToUse),Xte(:,feaToUse), 256);
XTrPct = uint8(XTrPct); XTePct = uint8(XTePct);


boostArgs.v = 0.5; 
rf = 0.9; J = 32;
boostArgs.funargs = {rf J};

boostArgs.nIter = 1000;
boostArgs.evaliter = 1:boostArgs.nIter;
totalTreesToTrain = 15;

%Jvals = [4 8 16 32 64 128];

Jvals = [4 8];

for i = 3:totalTreesToTrain
    
    i
    
    for jj = 1:length(Jvals)
        
        curJ = Jvals(jj)
        boostArgs.funargs = {rf curJ};
        

       fileStr = ['SepOct2012Training_J' num2str(curJ) 'rf9_tree' num2str(i) '.mat'];


        [perfTrain,perfTest,boostStruct] = ...
            BoostLSFixed(XTrPct, Ytr, XTePct, Yte, @boostTreeFun, boostArgs, [], []);

        save(fileStr,'perfTrain','perfTest','boostStruct','boostArgs')
    end
end
%{

Jvals = [4 8 16 32 64 128];
testErrors = cell(1,length(Jvals));
trainErrors = cell(1,length(Jvals));
ii=1;
for jj = 1:length(Jvals)
    curJ = Jvals(jj);
    fileStr = ['SepOct2012Training_J' num2str(curJ) 'rf9_tree' num2str(ii) '.mat'];
    curErrors = zeros(1,1000);
    curErrors2 = zeros(1,1000);
    load(fileStr,'perfTest','perfTrain');
    for kk = 1:1000
        curErrors(kk) = perfTest(kk).rmse;
        curErrors2(kk) = perfTrain(kk).rmse;
    end
    testErrors{jj} = curErrors;
    trainErrors{jj} = curErrors2;
end

figure
hold on
for ii = 1:6
    plot(testErrors{ii});
end
legend('J=4','J=8','J=16','J=32','J=64','J=128');
title('Validation Error vs. Number of Iterations');
hold off

figure
hold on
for ii = 1:6
    plot(trainErrors{ii});
end
legend('J=4','J=8','J=16','J=32','J=64','J=128');
title('Training Error vs. Number of Iterations');
hold off

%}