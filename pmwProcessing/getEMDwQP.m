function [ emd ] = getEMDwQP( basePatch,curPatch )
%GETEMDWQP Summary of this function goes here
%   Detailed explanation goes here

alphaVal=0.1;
[~,rawF,~,~,totalFlow] = getQuadProgResult(basePatch,curPatch,alphaVal);
emd = rawF/totalFlow;

end

