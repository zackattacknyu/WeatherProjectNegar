
%{
Codes to use for aa:

-1 = save for later
0 = none selected

1 = middle selected
2 = right selected
-2 = ambiguous

%}
selections = zeros(1,size(dispPatches,2));
%%
remainingPatches = find(selections==0); %-1 values are changed to zero so we don't need to care here

for i = 1:length(remainingPatches)
    j = remainingPatches(i);
    patchSet = dispPatches(:,j);
    aa = bestPredUI(patchSet)
    selections(j) = aa;
    if(aa == 0)
        break;
    end
    %uiwait
end
close all force
selections(selections==-1)=0;


