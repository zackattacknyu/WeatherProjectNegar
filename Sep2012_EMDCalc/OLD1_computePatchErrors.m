%{
CURRENT_generatePatchErrors( 'patchesSep2011Data_time7.mat',...
    'patchesSep2011Data_partialResults_time7.mat',...
    'patchesSep2011Data_results_time7.mat' );

CURRENT_generatePatchErrors( 'patchesSep2011Data_time46.mat',...
    'patchesSep2011Data_partialResults_time46.mat',...
    'patchesSep2011Data_results_time46.mat' )


CURRENT_generatePatchErrors( 'patchesOct2012Data_time4.mat',...
    'patchesOct2012Data_partialResults_time4.mat',...
    'patchesOct2012Data_results_time4.mat' );

CURRENT_generatePatchErrors( 'patchesOct2012Data_time5.mat',...
    'patchesOct2012Data_partialResults_time5.mat',...
    'patchesOct2012Data_results_time5.mat' )



t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesOct2012Data_all2.mat',...
    'patchesOct2012Data_results_all2.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesOct2012Data_numSeconds.mat','numSeconds');

%}
t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011DataNew_time1.mat',...
    'patchesSep2011DataNew_time1_results.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011DataNew_time1_numSeconds.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011DataNew_time7.mat',...
    'patchesSep2011DataNew_time7_results.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011DataNew_time7_numSeconds.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011DataNew_time9.mat',...
    'patchesSep2011DataNew_time9_results.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011DataNew_time9_numSeconds.mat','numSeconds');