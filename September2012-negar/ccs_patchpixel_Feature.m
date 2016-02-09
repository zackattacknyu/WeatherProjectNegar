function F = ccs_patchpixel_Feature(IR,l,maxl,ff)

FDATA = []

for j=1:maxl
    
      kk = find(l == j);
    
      temp = IR(kk);
      feat = ff(j,:);
      
      DATA(:,1) = temp;
      DATA(:,2:13) = repmat(feat,length(kk),1);
            
      FDATA = [FDATA;DATA];
      
      clear DATA
      clear temp
      clear rain
end
  
 nn = find(FDATA(:,13) >= 0);
%  
 FDATA = FDATA(nn,:);

F = FDATA;