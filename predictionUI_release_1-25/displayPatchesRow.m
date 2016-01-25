function [  ] = displayPatchesRow( dispPatches,val )
%DISPLAYPRECIPMAP Summary of this function goes here
%   Detailed explanation goes here
figure
targetP = dispPatches{1,val};
maxPixel = max(targetP(:));

numCol = size(dispPatches,1);

for jj = 1:numCol
    subplot(1,numCol,jj);
    imagesc(dispPatches{jj,val},[0 maxPixel]);
    colorbar;
end

end

