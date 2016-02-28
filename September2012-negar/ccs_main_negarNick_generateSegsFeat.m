%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

files = dir('zach_IR2/bghrus*');

NN = length(files);

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
    
    %Xte = ccs_patchpixel_Feature(ir,L,MAXL,FF);
    
    save(['zach_IR2_patches/segs_feat' files(i).name(7:end)],'L','MAXL','FF');
    
    
  
    
end

