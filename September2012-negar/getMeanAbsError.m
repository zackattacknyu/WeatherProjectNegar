function [ coeff ] = getMeanAbsError( targetArray,predArray )
%GETCOEFF Summary of this function goes here
%   Detailed explanation goes here


errorArray = abs(targetArray-predArray);
coeff=mean(errorArray);


end

