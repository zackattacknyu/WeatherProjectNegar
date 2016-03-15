
function RH=ccs_sub_seqsegment(ir,dim,THDH,MergeThd, S)

dir=pwd;
           %%preprocess the ir data            %%%%
            n = find(ir>THDH | ir < 150); ir2=ir;ir2(n)=THDH+1;
            ir2=imhmin(ir2,MergeThd);  % supression of the watershed merge threshold
            RH = watershed(ir2,8);
            RH(n)=-1; % 0 is the edge, -1 or the background;

            %%%assign the interedge to a certain cloud region
            [X,Y] = find(RH==0); % interboundary pixels
            [row, col] =size(RH);
            for i=1:length(X)
                 tmpMIN=100000;tmpL=0;
                 for ii=-1:1
                    for jj=-1:1
                         iii=X(i)+ii; jjj=Y(i)+jj;
                         if (iii>0 & iii <= row & jjj >0 & jjj <=col & RH(iii,jjj)~=0 )
                            if ( abs(ir(iii,jjj)-ir(X(i),Y(i)) )<tmpMIN )
                               tmpMIN = abs( ir(iii,jjj)-ir(X(i),Y(i)) );    
                               tmpL=RH(iii,jjj);
                            end
                          end
                    end
                  end
                 RH(X(i),Y(i))=tmpL;
            end

            MAXL=max(max(RH));  
            if (MAXL>=1)
                decrement=0;
                for i=1:MAXL
                   NN=find(RH==i);
                   LENGTH=length(NN);
                    if ( LENGTH < S );
                       RH(NN)=0;
                       decrement = decrement + 1 ;
                    else
                       RH(NN)= i-decrement;
                    end
                end
             end

%post process:
            RH(n)=0; 
            noData = find( ir <= 0 ); 
            RH(noData)=-1; % 0 is the background; -1 is the missing ir pixel
            
