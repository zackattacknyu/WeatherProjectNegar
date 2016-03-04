NN = 133;
rmseTestVals = zeros(1,NN);
for ii = 1:NN
    curYhat = preds{ii};
    rmseTestVals(ii) = sqrt(mean((curYhat-YteOct).^2));
end