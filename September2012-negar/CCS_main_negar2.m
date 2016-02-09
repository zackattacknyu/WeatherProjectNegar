% PERSIANN-CCS ward clouds added
% Negar Karbalaee
% April 2015

clear all;
close all;

%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

%files = dir('../ccs_sep_event/t300/goes/bghrus12*');
files = dir('./goes/bghrus12*');
n = length(files);

full_FF = []

for i = 1:n
    i
   
    fn =['./goes/', files(i,1).name];
    
    ir = loadbfn_bgz(fn, DIM, 'short')/100;
    ir = ir(126:625,126:875);
    
    L=ccs_sub_seqsegment(ir,DIM2,THDH,MergeThd, S); %segmentation
    
    Lrgb = label2rgb(L, 'jet', [0.8 0.8 0.8] ,'shuffle');
    
%     figure(1)
%     imshow = (Lrgb);

%     figure(2)
%     aa = max(max(L)); 
%     aa1 = rand(aa,3); aa1(1,:) = [1 1 1];
%     imagesc(L,[0 aa]);
%     colormap(aa1);
%     drwvect([-130 25 -100 45],[500 750],'/home/dank/t3_vects/us_states_outl_ug.tmp','k');
%     xlim([0 750]);
%     ylim([0 500]);
    
       NUM_FEATURE=12; WDSIZE=2;  MAXL=max(max(L));
        
            F=zeros(MAXL,NUM_FEATURE);
beginning_of_loop = MAXL
            for gg=1:MAXL
               F(gg,1:(NUM_FEATURE) )=ccs_getFeature(ir,L,gg,NUM_FEATURE,WDSIZE,DIM2(1),DIM2(2));
               FF(gg,:) = ( F(gg,:) - minV(1,:) )./ DistV(1,:);  %% Normalized the features
            end
end_of_loop = 0
            % post process features, avoid extremes
             n=find(FF>2); FF(n)=2; n=find(FF<0); FF(n)=0;  
             
             full_FF = [full_FF;FF];
            
             cd('./patches/');
             
             sv1 = ['save segs_feat_' files(i).name(7:16) ' L FF'];
             eval(sv1)
             
             cd('../')
             
             clear FF
                
end

 save('FFcluster_fall.mat','full_FF');

%[IDX,C] = kmeans(full_FF,400,'EmptyAction','singleton','MaxIter',1000,'Display','iter','OnlinePhase','on');

