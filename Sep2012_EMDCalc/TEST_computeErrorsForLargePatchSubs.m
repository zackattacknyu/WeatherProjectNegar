

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSize200Sep2011_time7_sub1.mat',...
    'patchesSize200Sep2011_time7_sub1_results.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSize200Sep2011_time7_sub1_numSeconds.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSize200Sep2011_time7_sub2.mat',...
    'patchesSize200Sep2011_time7_sub2_results.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSize200Sep2011_time7_sub2_numSeconds.mat','numSeconds');

