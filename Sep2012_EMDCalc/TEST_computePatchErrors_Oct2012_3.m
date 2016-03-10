
t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesOct2012Data_all4.mat',...
    'patchesOct2012Data_results_all4.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesOct2012Data_numSeconds_all4.mat','numSeconds');

