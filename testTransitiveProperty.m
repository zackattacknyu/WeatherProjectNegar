%{
order of rows:
target & pred 1
target & pred 2
target & pred 3
target & pred 4
%}
load('patchesSet11-23Data_3_results.mat');
predErrorsMSEtarP = predErrorsMSE;
predErrorsEMDtarP = predErrorsEMD;

%{
order of rows:
pred 1 & pred 2
pred 1 & pred 3
pred 1 & pred 4
pred 2 & pred 3
%}
load('patchesSet11-23Data_3_allPredResults_old.mat');
predErrorsMSEpairwise = predErrorsMSE(1:4,:);
predErrorsEMDpairwise = predErrorsEMD(1:4,:);

allErrorsMSE = [predErrorsMSEtarP;predErrorsMSEpairwise];
allErrorsEMD = [predErrorsEMDtarP;predErrorsEMDpairwise];


%{
The following triplets we should look out for, meaning
    two of them less than delta should imply the other one is also
1: 1,5,2
2: 1,6,3
3: 1,7,4
4: 2,8,3
%}

tripletErrorsEMD = zeros(4,size(allErrorsMSE,2));
tripletErrorsMSE = zeros(4,size(allErrorsMSE,2));
tripletInds = [1 5 2;1 6 3;1 7 4;2 8 3];

for slice = 1:size(allErrorsEMD,2)
   curErrorsEMD = allErrorsEMD(:,slice);
   curErrorsMSE = allErrorsMSE(:,slice);
   
   errorMatrixEMD = curErrorsEMD(tripletInds);
   tripletErrorsEMD(:,slice) = min(errorMatrixEMD,[],2);
   
   errorMatrixMSE = curErrorsMSE(tripletInds);
   tripletErrorsMSE(:,slice) = min(errorMatrixMSE,[],2);
end

emdThresh = 1;
mseThresh = 1;
numTripletsEMD = size(find(tripletErrorsEMD<emdThresh),1);
numTripletsMSE = size(find(tripletErrorsMSE<mseThresh),1);