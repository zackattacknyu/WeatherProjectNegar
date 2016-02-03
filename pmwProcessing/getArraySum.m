function [ res ] = getArraySum( vv1,vv2 )
%GETARRAYSUM Summary of this function goes here
%   Detailed explanation goes here


vv1nans = isnan(vv1);
vv2nans = isnan(vv2);
res = vv1+vv2;
res(vv1nans)=vv2(vv1nans);
res(vv2nans)=vv1(vv2nans);

end

