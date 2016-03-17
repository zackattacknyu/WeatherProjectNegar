
clear all;
close all;

DIM=[1000,1750]; 

files = dir('irData/bghrus1109*');
l = length(files);

path_ir = 'irData/';
path_rr = 'rrData/';

arrayDATA = cell(1,l);

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
 
 
 save('Sep2011PrepData.mat','FDATA');