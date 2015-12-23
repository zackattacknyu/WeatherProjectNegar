
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

remainingPatches = remainingPatches(randperm(length(remainingPatches)));
for i = 1:length(remainingPatches)
    j = remainingPatches(i);
    patchSet = dispPatches(:,j);
    patchSet2 = {patchSet{1},patchSet{3},patchSet{2}};
    if(rand>0.5) %flip order of them
        aa = bestPredUI(patchSet2);
        if(aa==1)
            aa=2;
        elseif(aa==2) 
            aa=1;
        end
    else
        aa = bestPredUI(patchSet);
    end
    selections(j) = aa;
    if(aa == 0)
        break;
    end
    %uiwait
end
close all force
selections(selections==-1)=0;


