%{
t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_all2.mat',...
    'patchesSep2011Data_results_all2.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_all2.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_all3.mat',...
    'patchesSep2011Data_results_all3.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_all3.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_all4.mat',...
    'patchesSep2011Data_results_all4.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_all4.mat','numSeconds');



t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_new1.mat',...
    'patchesSep2011Data_results_new1.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_new1.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_new2.mat',...
    'patchesSep2011Data_results_new2.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_new2.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_new3.mat',...
    'patchesSep2011Data_results_new3.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_new3.mat','numSeconds');

%}

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_allT_new1.mat',...
    'patchesSep2011Data_results_allT_new1.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_allT_new1.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_allT_new2.mat',...
    'patchesSep2011Data_results_allT_new2.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_allT_new2.mat','numSeconds');

t1 = clock;
CURRENT_generatePatchErrors_multiThreaded( 'patchesSep2011Data_allT_new3.mat',...
    'patchesSep2011Data_results_allT_new3.mat' )
t2 = clock;
numSeconds = etime(t2,t1)
save('patchesSep2011Data_numSeconds_allT_new3.mat','numSeconds');