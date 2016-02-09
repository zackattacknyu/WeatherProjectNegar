

clear all;
close all;

DIM=[1000,1750]; 

files = dir('goes/bghrus1209*');
l = length(files);

path_ir = 'goes/';
path_rr = 'radar/';

FDATA = [];

for i= 1:l
    i
    
    
  fn1 = ([path_ir files(i).name]);
  fn2 = ([path_rr  'q2hrus' files(i).name(7:end)]);
  
  %load(['./patches/segs_feat_',files(i).name(7:16),'.mat']);
  
  if ~exist(fn1,'file'); continue; end
  if ~exist(fn2,'file'); continue; end
  %if ~exist(fn3,'file'); continue; end
  
  %MAXL = max(max(L));
  
  ir = loadbfn_bgz(fn1, DIM, 'short')/100;
  ir = ir(126:625,126:875);
  
  rr = loadbfn_lgz(fn2, DIM, 'short')/10;
  rr = rr(126:625,126:875);
  
  for j = 1:MAXL
      
      kk = find(L == j);
      
      temp = ir(kk);
      rain = rr(kk);
      feat = FF(j,:);
      
      DATA(:,1) = temp;
      DATA(:,2:13) = repmat(feat,length(kk),1);
      DATA(:,14) = rain;
      
      FDATA = [FDATA;DATA];
      
      clear DATA
      clear temp
      clear rain
      
  end
    
end



 nn = find(FDATA(:,14) >= 0);
% 
 FDATA = FDATA(nn,:);