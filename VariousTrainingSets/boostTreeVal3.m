function predictions = boostTreeVal3(boostStruct, nIter, XTest, v)
trees = boostStruct.funparams;
predictions = cell(1,nIter);
[nIterTmp,K] = size(trees);
nIter = min(nIter,nIterTmp);
[N,p] = size(XTest);
F = zeros(N,K);
f = zeros(N,K);
assert(isa(XTest,'uint8'), 'only uint8 trees implemented for now');
for n=1:nIter
    for k=1:K
        f(:,k) = treeValFAST(XTest,trees{n,k});
    end
    F = F + f*v;
	predictions{n} = sum(F,2);
end
