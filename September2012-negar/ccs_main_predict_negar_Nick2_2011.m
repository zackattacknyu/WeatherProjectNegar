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

%files = dir('goes/bghrus1209*');
files = dir('zach_IR2/bghrus1109*');
%files = dir('zach_RR2/q2hrus1109*');
%load('tc.mat');
%%
%load('tc_NickDecTreeResult_J128rf8.mat');
load('tc_NickJ128rf8_iter200_treeOnly.mat');
load('tc.mat');
XtrSet = Xtr;
NN = length(files);

precip = zeros(500,750);
precipNick = zeros(500,750);
precipCCS = zeros(500,750);

for i = 46%1:NN
    i
   
    %fn =['goes/', files(i,1).name];
    fn =['zach_IR2/', files(i,1).name];
    fn3 = ['zach_RR2/q2hrus', files(i,1).name(7:end)];
    fn2 = ['zach_ccs2/rgo' files(i,1).name(7:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    
    if ~exist(fn2,'file')
                continue;
    end
   
    if ~exist(fn2,'file')
                continue;
    end
    
    %ir = loadbfn_bgz(fn, DIM, 'short')/100;
    load(fn);
    load(fn3);
    
    % area for training and testing over the US
    ir = ir(126:625,126:875);
    
    rrTest = rr(126:625,126:875);
    
    ccsData = load(fn2); ccsIR = ccsData.ccs;
    ccsOverUS = ccsIR(376:875,5751:6500);
    
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
    
    %boostArgs.nIter = 10;
    rr3 = boostTreeVal2(boostStruct,boostArgs.nIter,uint8(XtePct),boostArgs.v);
     
    
    precip(ir<0) = -1;
    precip(L==0) = 0;
    precip(ir>0 & L>0) = rr2;
    
    precipNick(ir<0) = -1;
    precipNick(L==0) = 0;
    precipNick(ir>0 & L>0) = rr3;
    
      
    rrTestUse = rrTest(ir>0 & L>0);
    ccsUSuse = ccsOverUS(ir>0 & L>0);
    indicesToUse = (rrTestUse>=0);
    
    precipCCS(ir<0) = -1;
    precipCCS(L==0) = 0;
    precipCCS(ir>0 & L>0) = ccsUSuse;
    
    negarTreeRMSE = sqrt(mean((rr2(indicesToUse)-rrTestUse(indicesToUse)).^2))
    nickTreeRMSE = sqrt(mean((rr3(indicesToUse)-rrTestUse(indicesToUse)).^2))
    ccsRMSE = sqrt(mean((ccsUSuse(indicesToUse)-rrTestUse(indicesToUse)).^2))
    
    negarBias = getBiasMeasure((rr2(indicesToUse)<1),(rrTestUse(indicesToUse)<1))
    nickBias = getBiasMeasure((rr3(indicesToUse)<1),(rrTestUse(indicesToUse)<1))
    ccsBias = getBiasMeasure((ccsUSuse(indicesToUse)<1),(rrTestUse(indicesToUse)<1))
    
    negarBiasCoeff = getBiasCoefficient(rrTestUse(indicesToUse),rr2(indicesToUse))
    nickBiasCoeff = getBiasCoefficient(rrTestUse(indicesToUse),rr3(indicesToUse))
    ccsBiasCoeff = getBiasCoefficient(rrTestUse(indicesToUse),ccsUSuse(indicesToUse))
    
    
    
    figure(1)
    imagesc(precip)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
    colorbar('vertical')
    title(fn)
    
    %precip = fix(precip*100);
    %save(['ccs/precip' files(i,1).name(5:end-4) '.mat'],'precip');
    
    
    figure(2)
    imagesc(precipNick)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
    colorbar('vertical')
    title(fn)
    
    %precipNick = fix(precipNick*100);
    %save(['ccs/precipNick' files(i,1).name(5:end-4) '.mat'],'precipNick');
    
    
    figure(3)
    imagesc(rrTest)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
    colorbar('vertical')
    title(fn)
    
    figure(4)
    imagesc(precipCCS)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
    colorbar('vertical')
    title(fn)
    
    %rrTest = fix(rrTest*100);
    %save(['ccs/rrTestUse' files(i,1).name(5:end-4) '.mat'],'rrTestUse');
    
    %{
    cd('/mnt/t/disk4/nkarbala/research/ccs_tree/ccs/')
    savebfn_l(['rgo',files(i,1).name(7:16),'.bin'], precip, 'short');
    gzip(['rgo',files(i,1).name(7:16),'.bin']);
    delete(['rgo',files(i,1).name(7:16),'.bin']);
    cd('/mnt/t/disk4/nkarbala/research/ccs_tree/')
    %}
    pause(3)
end
 


