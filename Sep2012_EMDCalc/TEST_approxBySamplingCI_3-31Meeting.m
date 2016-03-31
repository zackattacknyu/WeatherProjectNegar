%load('patchesSep2011Data_results_new1.mat');
%load('patchesSep2011Data_results_allT_new1.mat');
%load('patchesSep2011Data_results_all2.mat');
load('patchesOct2012Data_results_all4.mat');

numPatches = size(predErrorsEMD,2);
LvaluesFunc1 = sum(totalWorkEMD,2);

WORK1 = sort(totalWorkEMD(1,:));
WORK2 = sort(totalWorkEMD(2,:));

LOGWORK1 = sort(log(totalWorkEMD(1,:)));
LOGWORK2 = sort(log(totalWorkEMD(2,:)));

INDS = 1:length(LOGWORK1);
cdfVals = INDS./length(LOGWORK1);
%%
%{
SLIDE 1 RESULTS
%}

WORKCURRENT = WORK1;
LOGWORKCURRENT = LOGWORK1;

[phatML,pciML] = mle(WORKCURRENT,'distribution','lognormal');

mu = phatML(1);
sigma = phatML(2);
yFit = normcdf(LOGWORKCURRENT,mu,sigma);
figure
hold on
plot(LOGWORK1,cdfVals,'r-','LineWidth',2);
plot(LOGWORK1,yFit,'g-','LineWidth',2)
title('Cumulative Distribution of V = log(W) values');
xlabel('V');
ylabel('P( V <= v )')
legend('CDF for Original Data','CDF from MLE parameters');
hold off

rmseFit = sqrt(mean((yFit-cdfVals).^2));
nLogLike = normlike(phatML,LOGWORKCURRENT)/length(LOGWORKCURRENT);
%%
%{
SLIDE 2 RESULTS
%}

workArray = {WORK1};
loopInd = 1;
AlphaVal = 0.05;
displaySpecs = {'k','b'};

muArray = cell(1,length(workArray));
upperMuArray = cell(1,length(workArray));
lowerMuArray = cell(1,length(workArray));

sigmaArray = cell(1,length(workArray));
upperSigmaArray = cell(1,length(workArray));
lowerSigmaArray = cell(1,length(workArray));

startInd = 100;
indsNumTry = startInd:50:length(WORK1);
indsNumTry = [indsNumTry length(WORK1)];
numTries = length(indsNumTry);

for ii=1:length(workArray)
    
    WORKCURRENT = workArray{ii};
    LOGWORKCURRENT = log(WORKCURRENT);
    

    %numbers of samples that will be tried

    numPerms = 1;
    
    upperVal = zeros(numPerms,numTries);
    lowerVal = zeros(numPerms,numTries);
    meanVal = zeros(numPerms,numTries);
    
    upperVal2 = zeros(numPerms,numTries);
    lowerVal2 = zeros(numPerms,numTries);
    meanVal2 = zeros(numPerms,numTries);

    resInd = 1;


    for j = 1:numPerms
        inds = randperm(length(WORKCURRENT));
        resInd = 1;
        for i = indsNumTry
            curDataSet = WORKCURRENT(inds(1:i));

            [phatCur,pciCur] = mle(curDataSet,'distribution','lognormal','Alpha',AlphaVal);
            sizeVec = pciCur(2,:)-pciCur(1,:);

            muCur = phatCur(1); sigmaCur = phatCur(2);
            muUpper = pciCur(2,1); muLower = pciCur(1,1);
            sigmaUpper = pciCur(2,2); sigmaLower = pciCur(1,2);

            meanVal(j,resInd)=muCur;
            upperVal(j,resInd) = muUpper;
            lowerVal(j,resInd) = muLower;
            
            meanVal2(j,resInd)=sigmaCur;
            upperVal2(j,resInd) = sigmaUpper;
            lowerVal2(j,resInd) = sigmaLower;

            resInd = resInd+1;
        end
    end
    
    muArray{loopInd} = meanVal;
    upperMuArray{loopInd} = upperVal;
    lowerMuArray{loopInd} = lowerVal;
    
    sigmaArray{loopInd} = meanVal2;
    upperSigmaArray{loopInd} = upperVal2;
    lowerSigmaArray{loopInd} = lowerVal2;
    
    loopInd = loopInd + 1;
end


figure
hold on
title('Mu Values and their Upper and Lower Bounds with 95% Confidence')
for jj = 1:length(muArray)
    spec1 = [displaySpecs{jj} '-'];
    spec2 = [displaySpecs{jj} ':'];
    
    plot(indsNumTry,muArray{jj},spec1,'LineWidth',2);
    plot(indsNumTry,upperMuArray{jj},spec2);
    plot(indsNumTry,lowerMuArray{jj},spec2);
end
xlabel('Number of Samples');
ylabel('Mu');
hold off

figure
hold on
title('Sigma Values and their Upper and Lower Bounds with 95% Confidence')
for jj = 1:length(muArray)
    spec1 = [displaySpecs{jj} '-'];
    spec2 = [displaySpecs{jj} ':'];
    
    plot(indsNumTry,sigmaArray{jj},spec1,'LineWidth',2);
    plot(indsNumTry,upperSigmaArray{jj},spec2);
    plot(indsNumTry,lowerSigmaArray{jj},spec2);
end
xlabel('Number of Samples');
ylabel('Sigma');
hold off



%%
%{
SLIDE 3 RESULTS
%}

workArray = {WORK1,WORK2};
loopInd = 1;
AlphaVal = 0.05;
displaySpecs = {'r','b'};

meanArray = cell(1,length(workArray));
upperMeanArray = cell(1,length(workArray));
lowerMeanArray = cell(1,length(workArray));

startInd = 100;
indsNumTry = startInd:50:length(WORK1);
indsNumTry = [indsNumTry length(WORK1)];
numTries = length(indsNumTry);

for ii=1:length(workArray)
    
    WORKCURRENT = workArray{ii};
    LOGWORKCURRENT = log(WORKCURRENT);
    

    %numbers of samples that will be tried

    numPerms = 1;
    upperMeanVal = zeros(numPerms,numTries);
    lowerMeanVal = zeros(numPerms,numTries);
    meanCurDist = zeros(numPerms,numTries);

    resInd = 1;


    for j = 1:numPerms
        inds = randperm(length(WORKCURRENT));
        resInd = 1;
        for i = indsNumTry
            curDataSet = WORKCURRENT(inds(1:i));

            [phatCur,pciCur] = mle(curDataSet,'distribution','lognormal','Alpha',AlphaVal);
            sizeVec = pciCur(2,:)-pciCur(1,:);

            muCur = phatCur(1); sigmaCur = phatCur(2);
            muUpper = pciCur(2,1); muLower = pciCur(1,1);
            sigmaUpper = pciCur(2,2); sigmaLower = pciCur(1,2);

            meanCurDist(j,resInd)=exp(muCur + sigmaCur^2/2);
            upperMeanVal(j,resInd) = exp(muUpper + sigmaUpper^2/2);
            lowerMeanVal(j,resInd) = exp(muLower + sigmaLower^2/2);

            resInd = resInd+1;
        end
    end
    
    meanArray{loopInd} = meanCurDist;
    upperMeanArray{loopInd} = upperMeanVal;
    lowerMeanArray{loopInd} = lowerMeanVal;
    
    loopInd = loopInd + 1;
end


figure
hold on
title('Range of expected values for W_1 (blue) and W_2 (red) vs Number of Samples');
for jj = 1:length(meanArray)
    spec1 = [displaySpecs{jj} '-'];
    spec2 = [displaySpecs{jj} '--'];
    
    plot(indsNumTry,meanArray{jj},spec1,'LineWidth',2);
    plot(indsNumTry,lowerMeanArray{jj},spec2);
    plot(indsNumTry,upperMeanArray{jj},spec2);
end
xlabel('Number of Samples used in MLE estimation');
ylabel('Expected Value via MLE parameters');
hold off