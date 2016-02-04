function [ randPatches ] = getPatchesFromCoords( curImage,randPatchesCornerCoord, patchSize )
%GETPATCHESFROMCOORDS Summary of this function goes here
%   Detailed explanation goes here

randPatches = cell(1,length(randPatchesCornerCoord));
for k = 1:length(randPatchesCornerCoord) %try to obtain the sample patches
    
    curLocation = randPatchesCornerCoord{k};
    randStartRow = curLocation(1);
    randStartCol = curLocation(2);

   %obtains the patch
   randPatch = curImage(...
       (randStartRow-patchSize/2):(randStartRow+patchSize/2-1),...
       (randStartCol-patchSize/2):(randStartCol+patchSize/2-1));
    randPatches{k} = randPatch;

end
end

