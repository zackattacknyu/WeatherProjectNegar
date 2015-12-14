numRow=5;
figure
for i = 1:numRow
    
    curTarget = dispPatches{1,i};
    maxP = max(curTarget(:));
    
    for j = 1:2
       subplot(numRow,4,4*(i-1) + j)
       curPatch = dispPatches{j,i};
       imagesc(curPatch,[0 maxP]);
       colorbar;
    end
    
    curTarget = dispPatches2{1,i};
    maxP = max(curTarget(:));
    
    for j = 1:2
       subplot(numRow,4,4*(i-1) + j + 2)
       curPatch = dispPatches2{j,i};
       imagesc(curPatch,[0 maxP]);
       colorbar;
    end
    
    
end