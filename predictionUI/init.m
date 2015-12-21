
for i = 1:30
    patchSet = dispPatches(:,i);
    aa = bestPredUI(patchSet);
    %uiwait
end


