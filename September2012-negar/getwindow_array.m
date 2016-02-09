
function [N, I, J, k] = getwindow_array(row,col,i,j,size)


%I=-size:1:size;
%J=I;
%I=i+I;J=J+j;

k=0;N=[];I=[];J=[];
for ii=-size:size
  for jj=-size:size
    m=i+ii; n=j+jj;  %%%% ali: could be out of patch? then -999 may get in and that's why i see several big numbers 
    if (m<=0 | n<=0 | m>row | n > col)
    else
       k=k+1;
       I(k)=m; J(k)=n;
       N(k)=(n-1)*row+m;
    end
  end
end

