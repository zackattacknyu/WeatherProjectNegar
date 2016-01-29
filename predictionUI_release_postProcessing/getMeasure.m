function [ prob ] = getMeasure( trainBinary,predBinary )
%GETMEASURE Summary of this function goes here
%   Detailed explanation goes here

numPixels = numel(trainBinary);

numTruePos = sum((predBinary==1)&(trainBinary==1));
numTrueNeg = sum((predBinary==0)&(trainBinary==0));
numFalsePos = sum((predBinary==1)&(trainBinary==0));
numFalseNeg = sum((predBinary==0)&(trainBinary==1));

%accuracy
%prob = (numTruePos+numTrueNeg)/numPixels;

%prob detection
%{
if(numTruePos+numFalseNeg<1)
    prob=1;
else
    prob=numTruePos/(numTruePos+numFalseNeg);
end
%}

%false alarm rate
%{
if(numFalsePos+numTrueNeg<1)
    prob=0;
else
    prob = (numFalsePos)/(numFalsePos+numTrueNeg);
end
%}

%bias score
%{
if(numTruePos+numFalseNeg<1)
    prob=0;
else
    prob = (numTruePos+numFalsePos)/(numTruePos+numFalseNeg);
end
%}

%success ratio
if(numTruePos+numFalsePos<1)
    prob=1;
else
    prob = numTruePos/(numTruePos+numFalsePos);
end

%false alarm ratio
prob = 1-prob;

% threat score
%{
%hrand = (numTruePos+numFalseNeg)*(numTruePos+numFalsePos)/numPixels;
if(numTruePos+numFalseNeg+numFalsePos<1)
%if(numTruePos+numFalseNeg+numFalsePos-hrand==0)
    prob=1;
else
    prob = numTruePos/(numTruePos+numFalseNeg+numFalsePos);
    %prob = (numTruePos-hrand)/(numTruePos+numFalseNeg+numFalsePos-hrand);
end
%}

%prob=sum(trainBinary==1);
%prob=sum(predBinary==1);

end

