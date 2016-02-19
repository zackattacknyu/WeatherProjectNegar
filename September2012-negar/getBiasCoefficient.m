function [ coeff ] = getBiasCoefficient( targetArray,predArray )
%GETCOEFF Summary of this function goes here
%   Detailed explanation goes here

coeff = (sum(predArray)-sum(targetArray))/sum(targetArray);

end

