function [ coeff ] = getCoeff( targetArray,predArray )
%GETCOEFF Summary of this function goes here
%   Detailed explanation goes here

rMatrix = corrcoef([targetArray predArray]);
coeff = rMatrix(1,2);

end

