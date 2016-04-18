
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

DIM=[1000,1750]; 

files = dir('zach_IR/bghrus1009*');
l = length(files);

path_ir = 'zach_IR/';
path_rr = 'zach_RR/';

arrayDATA = cell(1,l);

for i= 1:l
    i
    
    
  fn1 = ([path_ir files(i).name]);
  fn2 = ([path_rr  'q2hrus' files(i).name(7:end)]);
  %fn3 = ['patchesData/segs_feat',files(i).name(7:16),'.mat'];
  
  
  
  if ~exist(fn1,'file'); continue; end
  if ~exist(fn2,'file'); continue; end
  %if ~exist(fn3,'file'); continue; end
  %load(fn3,'L','FF');
  %MAXL = max(max(L));
  
  load(fn1,'ir');
  ir = ir(126:625,126:875);
  
  rrFileData = load(fn2);
  try
     rr = rrFileData.rr; 
  catch
     rr = rrFileData.ir; 
  end
  rr = rr(126:625,126:875);
  
  
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

   % Xte = ccs_patchpixel_Feature(ir,L,MAXL,FF);

  
  
  currentPatchData = cell(1,MAXL);
  
  for j = 1:MAXL
      
      kk = find(L == j);
      
      temp = ir(kk);
      rain = rr(kk);
      feat = FF(j,:);
      
      DATA = zeros(length(temp),14);
      DATA(:,1) = temp;
      DATA(:,2:13) = repmat(feat,length(kk),1);
      DATA(:,14) = rain;
      
      currentPatchData{j} = DATA;
      
      %FDATA = [FDATA;DATA];
      
      clear DATA
      clear temp
      clear rain
      
  end
  
  arrayDATA{i} = currentPatchData;
    
end

numDataPoints=0;
for ii = 1:length(arrayDATA)
   currentDATA = arrayDATA{ii};
   for jj = 1:length(currentDATA)
      numDataPoints = numDataPoints + size(currentDATA{jj},1); 
   end
end

FDATA = zeros(numDataPoints,14);
curStartInd = 1;
for ii = 1:length(arrayDATA)
   currentDATA = arrayDATA{ii};
   for jj = 1:length(currentDATA)
       DATA = currentDATA{jj};
       numPoints = size(DATA,1); 
       curEndInd = curStartInd + numPoints - 1;
       
       FDATA(curStartInd:curEndInd,:)=DATA;
       
       curStartInd = curEndInd+1;
   end
end



 nn = find(FDATA(:,14) >= 0); 
 FDATA = FDATA(nn,:);
 
 
 save('Sep2010PrepData.mat','FDATA');