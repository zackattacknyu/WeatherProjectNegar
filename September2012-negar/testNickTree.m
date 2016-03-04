%{
NN = 133;
rmseTestVals = zeros(1,NN);
for ii = 1:NN
    curYhat = preds{ii};
    rmseTestVals(ii) = sqrt(mean((curYhat-YteOct).^2));
end
%}

totalNumEntries = 0;
for i = 1:length(targetArray)
   totalNumEntries = totalNumEntries + length(targetArray{i}); 
end

negarPredictions = zeros(1,totalNumEntries);
nickPredictions = zeros(1,totalNumEntries);
targetEntries = zeros(1,totalNumEntries);

curStart = 1;
for i = 1:length(targetArray)
   curLen = length(targetArray{i});
   negarPredictions(curStart:(curStart+curLen-1)) = negarPredictionArray{i};
   nickPredictions(curStart:(curStart+curLen-1)) = nickPredictionArray{i};
   targetEntries(curStart:(curStart+curLen-1)) = targetArray{i};
   curStart = curStart + curLen;
end