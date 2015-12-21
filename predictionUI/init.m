
%{
Codes to use for aa:
0 = none selected
1 = middle selected
2 = right selected
-1 = ambiguous
-2 = save for later
%}

for i = 1:30
    i
    patchSet = dispPatches(:,i);
    aa = bestPredUI(patchSet)
    if(aa == 0)
        break;
    end
    %uiwait
end
close all force


