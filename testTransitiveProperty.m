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
tripletInds = [1 5 2;...
    1 6 3;...
    1 7 4;...
    2 8 3];

emdThresh = 1;
mseThresh = 1;
numWithTwoUnderMSE = 0; %number of triplets with two 
numWithTwoUnderEMD = 0; %number of triplets with two 
numWithThreeUnderMSE = 0; %number of triplets with all three under
numWithThreeUnderEMD = 0; %number of triplets with all three under

for slice = 1:size(allErrorsEMD,2)
   curErrorsEMD = allErrorsEMD(:,slice);
   curErrorsMSE = allErrorsMSE(:,slice);
   
   for row = 1:4
      curTripletEMD = curErrorsEMD(tripletInds(row,:)); 
      curTripletEMD = sort(curTripletEMD);
      if(max(curTripletEMD(1:2)) < emdThresh)
          numWithTwoUnderEMD = numWithTwoUnderEMD + 1;
      end
      
      if(max(curTripletEMD) < emdThresh)
          numWithThreeUnderEMD = numWithThreeUnderEMD + 1;
      end
      
      curTripletMSE = curErrorsMSE(tripletInds(row,:)); 
      curTripletMSE = sort(curTripletMSE);
      if(max(curTripletMSE(1:2)) < mseThresh)
          numWithTwoUnderMSE = numWithTwoUnderMSE + 1;
      end
      
      if(max(curTripletMSE) < mseThresh)
          numWithThreeUnderMSE = numWithThreeUnderMSE + 1;
      end
      
   end
   
   
end

transRatioMSE = numWithThreeUnderMSE/numWithTwoUnderMSE;
transRatioEMD = numWithThreeUnderEMD/numWithTwoUnderEMD;

