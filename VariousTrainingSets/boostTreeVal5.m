function rmseTestVals = boostTreeVal5(boostStructArray, nIter, XTest, v,YTest,evalIndices)

%NOTE: THIS FUNCTION HAS BEEN UNIT TESTED 
%   AND THUS VERIFIED!!

rmseTestVals = zeros(1,length(nIter));
numTrees = length(boostStructArray);

boostStruct = boostStructArray{1};
curTrees = boostStruct.funparams;
[nIterTmp,K] = size(curTrees);
nIter = min(nIter,nIterTmp);
[N,p] = size(XTest);

f = zeros(N,K);
assert(isa(XTest,'uint8'), 'only uint8 trees implemented for now');

FvalForTrees = cell(1,numTrees);
for treeNum = 1:numTrees
   FvalForTrees{treeNum} = zeros(N,K); 
end


for n=1:nIter
    
    n
    
    curYhat = zeros(N,1);
    for treeNum = 1:numTrees
        
        F = FvalForTrees{treeNum};
        boostStruct = boostStructArray{treeNum};
        curTrees = boostStruct.funparams;
        for k=1:K
            f(:,k) = treeValFAST(XTest,curTrees{n,k});
        end
        F = F + f*v;
        FvalForTrees{treeNum} = F;
        curYhat = curYhat + sum(F,2);
        
    
    end
    
    %prediction is mean of all tree predictions
    curYhat = curYhat/numTrees;
    
    curYhatEval = curYhat(evalIndices);
    YTestEval = YTest(evalIndices);
    
    rmseTestVals(n) = sqrt(mean((curYhatEval-YTestEval).^2));
end
