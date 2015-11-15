function [ rmse ] = rmsePatches( patch1,patch2 )
%MSEPATCHES get the RMSE between two patches that are 2D matrices

diffPatch = patch1-patch2;
diffArray = diffPatch(:);

rmse = sqrt(mean(diffArray.^2));


end

