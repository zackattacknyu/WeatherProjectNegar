function [ coeff ] = getCoeff( targetArray,predArray )
%GETCOEFF Summary of this function goes here
%   Detailed explanation goes here

%rMatrix = corrcoef([targetArray predArray]);
%coeff = rMatrix(1,2);

errorArray = abs(targetArray-predArray);
coeff=mean(errorArray);

%coeff=mean(targetArray);
%coeff=mean(predArray);

%coeff=max(targetArray);
%coeff=max(predArray);

%coeff = sum(predArray-targetArray)/sum(targetArray);

end

