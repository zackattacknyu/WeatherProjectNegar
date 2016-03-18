
for JVALUE = 4
    load('decTreeSepOct2012.mat');
    load('sep2011TestDataSetAll.mat');

    for rfVal = [5,9];
        testMultNickTreeScript2;
        save(['rmseTestSep2011Averaged_J' num2str(JVALUE) 'rf' num2str(rfVal) '_TEST.mat'],...
            'rmseTestVals');
    end
end

