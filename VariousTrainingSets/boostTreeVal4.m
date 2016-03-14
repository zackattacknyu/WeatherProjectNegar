function rmseTestVals = boostTreeVal4(boostStruct, nIter, XTest, v,YTest)
trees = boostStruct.funparams;
[nIterTmp,K] = size(trees);
nIter = min(nIter,nIterTmp);
[N,p] = size(XTest);
F = zeros(N,K);
f = zeros(N,K);
assert(isa(XTest,'uint8'), 'only uint8 trees implemented for now');
rmseTestVals = zeros(1,length(nIter));
for n=1:nIter
    for k=1:K
        f(:,k) = treeValFAST(XTest,trees{n,k});
    end
    F = F + f*v;
	curYhat = sum(F,2);
    rmseTestVals(n) = sqrt(mean((curYhat-YTest).^2));
end
