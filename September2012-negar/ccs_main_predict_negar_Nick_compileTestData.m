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
files = dir('matFiles/data1210*');
%load('tc.mat');
NN = length(files);

precip = zeros(500,750);
precipNick = zeros(500,750);

XteArray = cell(1,NN);
YteArray = cell(1,NN);

for i = 1:NN
    i
   
    %fn =['goes/', files(i,1).name];
    fn =['matFiles/', files(i,1).name];
    
    if ~exist(fn,'file')
                continue;
    end
   
    %ir = loadbfn_bgz(fn, DIM, 'short')/100;
    load(fn);
    
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
             

    
    XteCurrent = ccs_patchpixel_Feature(ir,L,MAXL,FF);
    
    YteCurrent = rrTest(ir>0 & L>0);
    
    
    XteArray{i} = XteCurrent;
    YteArray{i} = YteCurrent;
  
    
end

save('oct2012TestDataSet.mat','XteArray','YteArray');


totalNumEntries = 0;
for i = 1:length(YteArray)
   totalNumEntries = totalNumEntries + length(YteArray{i}); 
end

XteOct = zeros(totalNumEntries,size(XteArray{1},2));
YteOct = zeros(totalNumEntries,1);

curStart = 1;
for i = 1:length(YteArray)
   curLen = length(YteArray{i});
   XteOct(curStart:(curStart+curLen-1),:) = XteArray{i};
   YteOct(curStart:(curStart+curLen-1)) = YteArray{i};
   curStart = curStart + curLen;
end

save('oct2012TestDataSetAll.mat','XteArray','YteArray','XteOct','YteOct');