function [ samples ] = getSampledPoints( numT, targetNumSamples, minDist )
%GETSAMPLEDPOINTS Summary of this function goes here
%   Detailed explanation goes here


epsilon = 1e-5;

%array of samples
samples = zeros(1,targetNumSamples);

%uniform pdf
pdf = ones(1,numT);

for i = 1:targetNumSamples
    
    %sample from current pdf
    pdf = pdf./sum(pdf);
    cdf = cumsum(pdf);
    curSample = find(rand<cdf, 1 );
    samples(i) = curSample;
    
    %zero the neighborhood around sample taken so it won't be used
    minInd = max(1,curSample-minDist);
    maxInd = min(length(pdf),curSample+minDist);
    pdf(minInd:maxInd)=0;
    
    %if entire pdf is now 0
    if(sum(pdf)<epsilon)
       break; 
    end
    
end
samples = samples(1:i);
end

