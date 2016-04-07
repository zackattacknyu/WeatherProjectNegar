%{
NOTE ABOUT TC.MAT
It was trained over every 4th timestep (every 2 hours)
    with the radar and ir data
    for Sep 2012
Every 4th timestep was used, they were NOT accumulated
%}

% PERSIANN-CCS decision tree added
% Negar Karbalaee
% February 2016

% First of all we should load tc which is an object for
% model predi

%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

files = dir('matFiles/data1209*');
NN = length(files);

ccsPredictionArray = cell(1,NN);
targetArray = cell(1,NN);

for i = 1:NN
    i
   
    %fn =['goes/', files(i,1).name];
    fn =['matFiles/', files(i,1).name];
    fn2 = ['zach_ccs/rgo' files(i,1).name(5:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    
    if ~exist(fn2,'file')
                continue;
    end
   
    %ir = loadbfn_bgz(fn, DIM, 'short')/100;
    load(fn,'ir','rr');
    
    % area for training and testing over the US
    ir = ir(126:625,126:875);
    
    rrTest = rr(126:625,126:875);
    
    ccsData = load(fn2); ccsIR = ccsData.ir;
    ccsOverUS = ccsIR(376:875,5751:6500);
    
    L=ccs_sub_seqsegment(ir,DIM2,THDH,MergeThd, S); %segmentation

    
    
       NUM_FEATURE=12; WDSIZE=2;  MAXL=max(max(L));
        
            F=zeros(MAXL,NUM_FEATURE);
beginning_of_loop = MAXL;
            for gg=1:MAXL
               F(gg,1:(NUM_FEATURE) )=ccs_getFeature(ir,L,gg,NUM_FEATURE,WDSIZE,DIM2(1),DIM2(2));
               FF(gg,:) = ( F(gg,:) - minV(1,:) )./ DistV(1,:);  %% Normalized the features
            end
end_of_loop = 0;
            % post process features, avoid extremes
             n=find(FF>2); FF(n)=2; n=find(FF<0); FF(n)=0;  

    
    rrTestUse = rrTest(ir>0 & L>0);
    ccsUSuse = ccsOverUS(ir>0 & L>0);
    indicesToUse = (rrTestUse>=0);
    
    ccsPrediction = ccsUSuse(indicesToUse);
    if(~isempty(find(ccsPrediction<0, 1)))
        fn2
        
    end
    
    targetVals = rrTestUse(indicesToUse);
    
    ccsPredictionArray{i} = ccsPrediction;
    targetArray{i} = targetVals;
  
    
end

%save('oct2012ccsPredictions.mat','ccsPredictionArray','targetArray');
%clear all
%load('oct2012ccsPredictions.mat');

totalNumEntries = 0;
for i = 1:length(targetArray)
   totalNumEntries = totalNumEntries + length(targetArray{i}); 
end

ccsPredictions = zeros(1,totalNumEntries);
targetEntries = zeros(1,totalNumEntries);

curStart = 1;
for i = 1:length(targetArray)
   curLen = length(targetArray{i});
   ccsPredictions(curStart:(curStart+curLen-1)) = ccsPredictionArray{i};
   targetEntries(curStart:(curStart+curLen-1)) = targetArray{i};
   curStart = curStart + curLen;
end


ccsRMSE = sqrt(mean((ccsPredictions-targetEntries).^2))
ccsBias = getBiasMeasure((ccsPredictions<1),(targetEntries<1))
ccsBiasCoeff = getBiasCoefficient(targetEntries,ccsPredictions)

save('oct2012partialCcsPredictions_allInfo.mat',...
    'ccsPredictions','targetEntries',...
    'ccsRMSE','ccsBias','ccsBiasCoeff');
