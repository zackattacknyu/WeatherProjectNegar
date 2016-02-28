files = dir('zach_IR2/bghrus1109*');
load('sep2012Xtrain.mat');

%load('tc_NickJ128rf8_iter50_treeOnly.mat');

NN = length(files);

precip = zeros(500,750);
precipNick = zeros(500,750);

negarPredictionArray = cell(1,NN);
nickPredictionArray = cell(1,NN);
targetArray = cell(1,NN);

XtrSet = Xtr;

for i = 1:NN
    i
   
    fn =['zach_IR2/', files(i,1).name];
    fn3 = ['zach_RR2/q2hrus', files(i,1).name(7:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    
    if ~exist(fn3,'file')
                continue;
    end
    
    %ir = loadbfn_bgz(fn, DIM, 'short')/100;
    irFileData = load(fn);
    rrFileData = load(fn3);
	ir = irFileData.ir;
	rr = rrFileData.rr;
    
    % area for training and testing over the US
    ir = ir(126:625,126:875);
    
    rrTest = rr(126:625,126:875);
    
    
    L=ccs_sub_seqsegment(ir,DIM2,THDH,MergeThd, S); %segmentation
    
   % Lrgb = label2rgb(L, 'jet', [0.8 0.8 0.8] ,'shuffle');
    
%     figure(1)
%     imshow = (Lrgb);
    
    
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
             
    %[IDX_p,C_p] = kmeans(FF,400,'EmptyAction','singleton');         
      
    % predicting rainfall from the developed curves
    % relationship bewteen Tb-RR
    
    Xte = ccs_patchpixel_Feature(ir,L,MAXL,FF);
    
    cd('./@treeRegress/')
    
     rr2 = predict(tc,Xte);  
        
    cd('../') 
    
    [~,XtePct,~] = XToPct(XtrSet,Xte,256);
    
    rr3 = boostTreeVal2(boostStruct,boostArgs.nIter,uint8(XtePct),boostArgs.v);
     
    
    precip(ir<0) = -1;
    precip(L==0) = 0;
    precip(ir>0 & L>0) = rr2;
    
    precipNick(ir<0) = -1;
    precipNick(L==0) = 0;
    precipNick(ir>0 & L>0) = rr3;
    
    rrTestUse = rrTest(ir>0 & L>0);
    indicesToUse = (rrTestUse>=0);
    
    
    negarPrediction = rr2(indicesToUse);
    nickPrediction = rr3(indicesToUse);
    targetVals = rrTestUse(indicesToUse);
    
    negarPredictionArray{i} = negarPrediction;
    nickPredictionArray{i} = nickPrediction;
    targetArray{i} = targetVals;
  
    
end


totalNumEntries = 0;
for i = 1:length(targetArray)
   totalNumEntries = totalNumEntries + length(targetArray{i}); 
end

negarPredictions = zeros(1,totalNumEntries);
nickPredictions = zeros(1,totalNumEntries);
targetEntries = zeros(1,totalNumEntries);

curStart = 1;
for i = 1:length(targetArray)
   curLen = length(targetArray{i});
   negarPredictions(curStart:(curStart+curLen-1)) = negarPredictionArray{i};
   nickPredictions(curStart:(curStart+curLen-1)) = nickPredictionArray{i};
   targetEntries(curStart:(curStart+curLen-1)) = targetArray{i};
   curStart = curStart + curLen;
end


negarTreeRMSE = sqrt(mean((negarPredictions-targetEntries).^2))
nickTreeRMSE = sqrt(mean((nickPredictions-targetEntries).^2))

negarBias = getBiasMeasure((negarPredictions<1),(targetEntries<1))
nickBias = getBiasMeasure((nickPredictions<1),(targetEntries<1))

negarBiasCoeff = getBiasCoefficient(targetEntries,negarPredictions)
nickBiasCoeff = getBiasCoefficient(targetEntries,nickPredictions)