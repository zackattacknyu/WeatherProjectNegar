function [ prob ] = getMeasure( trainBinary,predBinary )
%GETMEASURE Summary of this function goes here
%   Detailed explanation goes here

numPixels = numel(trainBinary);

numTruePos = sum((predBinary==1)&(trainBinary==1));
numTrueNeg = sum((predBinary==0)&(trainBinary==0));
numFalsePos = sum((predBinary==1)&(trainBinary==0));
numFalseNeg = sum((predBinary==0)&(trainBinary==1));

prob = (numTruePos+numTrueNeg)/numPixels;
%prob = (numFalsePos)/(numFalsePos+numTrueNeg);

end

