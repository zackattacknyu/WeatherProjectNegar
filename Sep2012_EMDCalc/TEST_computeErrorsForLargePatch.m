

t1 = clock;
CURRENT_generatePatchErrors( 'patchesSize200Sep2011_time7.mat',...
    'patchesSize200Sep2011_time7_partialResults.mat',...
    'patchesSize200Sep2011_time7_results.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSize200Sep2011_time7_numSeconds.mat','numSeconds');

