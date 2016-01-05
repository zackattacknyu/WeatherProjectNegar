mseSorted = sort([mseOthers mseBests]);
emdSorted = sort([emdOthers emdBests]);

%{
emdSorted = emdSorted(1:end-20);
mseSorted = mseSorted(1:end-20);

mseSorted = mseSorted./max(mseSorted);
emdSorted = emdSorted./max(emdSorted);
%}
figure
hold on
plot(mseSorted,'r-');
plot(emdSorted,'g-');
hold off