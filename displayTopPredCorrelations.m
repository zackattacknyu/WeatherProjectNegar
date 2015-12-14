otherPercents = zeros(1,length(otherOnesA));
for k = 1:length(otherOnesA)
   curInd = find(otherOnesA(k)==otherSortedArray,1);
   otherPercents(k) = curInd/length(otherSortedArray);
end

figure
subplot(121)
plot(otherPercents);
axis([1 length(otherPercents) 0 Inf]);
title(titleA);
xlabel(xlabelA);
ylabel(ylabelA);

subplot(122)
plot(sort(otherPercents));
axis([1 length(otherPercents) 0 Inf]);
title(titleA);
xlabel(xlabelB);
ylabel(ylabelA);