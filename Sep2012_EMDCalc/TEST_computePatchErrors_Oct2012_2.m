
t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesOct2012Data_all3.mat',...
    'patchesOct2012Data_results_all3.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesOct2012Data_numSeconds_all3.mat','numSeconds');

