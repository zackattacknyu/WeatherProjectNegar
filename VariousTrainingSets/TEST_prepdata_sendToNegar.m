
clear all;
close all;

DIM=[1000,1750]; 

files = dir('irData/bghrus1109*');
l = length(files);

path_ir = 'irData/';
path_rr = 'rrData/';

numberPointsArray = zeros(1,l);

for i= 1:l
    i
    
    
  fn1 = ([path_ir files(i).name]);
  fn2 = ([path_rr  'q2hrus' files(i).name(7:end)]);
  fn3 = ['patchesData/segs_feat',files(i).name(7:16),'.mat'];
  
  
  
  if ~exist(fn1,'file'); continue; end
  if ~exist(fn2,'file'); continue; end
  if ~exist(fn3,'file'); continue; end
  
  load(fn3,'L','FF');
  MAXL = max(max(L));
  
  load(fn1,'ir');
  ir = ir(126:625,126:875);
  
  rrFileData = load(fn2);
  try
     rr = rrFileData.rr; 
  catch
     rr = rrFileData.ir; 
  end
  rr = rr(126:625,126:875);
  
  
  for j = 1:MAXL
      
      kk = find(L == j);
      
      %temp = ir(kk);
      rain = rr(kk);
      %feat = FF(j,:);
      
      numberPointsArray(i) = numberPointsArray(i) + length(find(rain>=0));
      

  end
  
    
end

totalNumberPoints = sum(numberPointsArray);

save('negarNumDataPoints.mat','numberPointsArray');
