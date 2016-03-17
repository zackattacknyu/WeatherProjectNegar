
clear all;
close all;

DIM=[1000,1750]; 

files = dir('irData/bghrus1109*');
l = length(files);

path_ir = 'irData/';
path_rr = 'rrData/';

arrayDATA = cell(1,l);

numberPoints = zeros(1,l);

diffRR = zeros(1,l);

FDATA = [];

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
      
      
      
      %temp = ir(kk);
      rain = rr(kk);
      %feat = FF(j,:);
      
      numberPoints(i) = numberPoints(i) + length(find(rain>=0));
      
      %DATA = zeros(length(temp),14);
      %DATA(:,1) = temp;
      %DATA(:,2:13) = repmat(feat,length(kk),1);
      %DATA(:,14) = rain;
      
      
      
      %currentPatchData{j} = DATA;
      %FDATA = [FDATA;DATA];
      
      %clear DATA
      %clear temp
      %clear rain
      
  end
  
  %arrayDATA{i} = currentPatchData;
    
end

%{
numDataPoints=0;
for ii = 1:length(arrayDATA)
   currentDATA = arrayDATA{ii};
   for jj = 1:length(currentDATA)
      numDataPoints = numDataPoints + size(currentDATA{jj},1); 
   end
end

FDATA2 = zeros(numDataPoints,14);
curStartInd = 1;
for ii = 1:length(arrayDATA)
   currentDATA = arrayDATA{ii};
   for jj = 1:length(currentDATA)
       DATA = currentDATA{jj};
       numPoints = size(DATA,1); 
       curEndInd = curStartInd + numPoints - 1;
       
       FDATA2(curStartInd:curEndInd,:)=DATA;
       
       curStartInd = curEndInd+1;
   end
end



 nn = find(FDATA2(:,14) >= 0);
 FDATA2 = FDATA2(nn,:);
 
 save('SepOct2012PrepData.mat','FDATA');


%}

%{
save('negar_3_16_datapreptesting_zachVersion.mat','numberPatchPoints');


load('negar_3_16_datapreptesting.mat','numPatchPoints');
negarNumPoints = numPatchPoints;
load('negar_3_16_datapreptesting_zachVersion.mat','numberPatchPoints');
zachNumPoints = numberPatchPoints;
%}

