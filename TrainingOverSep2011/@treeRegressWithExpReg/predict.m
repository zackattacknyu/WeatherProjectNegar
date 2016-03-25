function Yte = predict(obj,Xte)
% Y = predict(tree, X) : make predictions on data X 
  Yte = dectreeTest(Xte, obj.L,obj.R,obj.F,obj.T,obj.BETA, 1); 

function yhat = dectreeTest(data, L,R,F,T,BETA, pos) 
  yhat=zeros(size(data,1),1);
  if (F(pos)==0) 
      %yhat(:)=T(pos);
      curBETA = BETA(pos,:);
      %yhat=data*(curBETA');
      yhat=(exp(data*(curBETA'))-1)./100;
  else 
    goLeft = data(:,F(pos)) < T(pos);
    yhat(goLeft)  = dectreeTest(data(goLeft,:), L,R,F,T,BETA, L(pos)); 
    yhat(~goLeft) = dectreeTest(data(~goLeft,:), L,R,F,T,BETA, R(pos));
  end;
