function F = ccs_patchpixel_Feature(IR,l,maxl,ff)

FDATAcell = cell(1,maxl);
numRows = 0;

for j=1:maxl
    
      kk = find(l == j);
    
      temp = IR(kk);
      feat = ff(j,:);
      
      DATA = zeros(length(temp),13);
      DATA(:,1) = temp;
      DATA(:,2:13) = repmat(feat,length(kk),1);
            
      FDATAcell{j}=DATA;
      
      numRows = numRows + size(DATA,1);
      
      %clear DATA
      %clear temp
end

FDATA = zeros(numRows,13);

curIndex=1;
for j =1:maxl
    DATA = FDATAcell{j};
    numRowData = size(DATA,1);
    FDATA(curIndex:(curIndex+numRowData-1),:)=DATA;
    curIndex=curIndex+numRowData;
end
  
 nn = (FDATA(:,13) >= 0);
 FDATA = FDATA(nn,:);

F = FDATA;