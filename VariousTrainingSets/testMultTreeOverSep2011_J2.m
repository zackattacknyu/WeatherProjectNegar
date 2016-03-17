
for JVALUE = 2
    load('decTreeSepOct2012.mat');
    load('sep2011TestDataSetAll.mat');

    testMultNickTreeScript;

    save(['rmseTestSep2011Averaged_J' num2str(JVALUE) 'rf5.mat'],...
        'rmseTestVals');
end

