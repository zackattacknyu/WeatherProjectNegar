%dataFiles = dir('zach_RR/q2hrus1210*');
%dataFiles2 = dir('zach_ccs/rgo1210*');
%dataFiles3 = dir('negarPredMaps/decTreePred1210*');

dataFiles = dir('zach_RR2/q2hrus1109*');
dataFiles2 = dir('zach_ccs2/rgo1109*');
dataFiles3 = dir('negarPredMaps2/decTreePred1109*');
%%
numT = min([length(dataFiles) length(dataFiles2) length(dataFiles3)]);
numSampleTimes = 400;
minTimeDiff = 0;
epsilon = 1e-2;
precipThresh = 500;

%timeStamps = getSampledPoints(numT,numSampleTimes,minTimeDiff);
timeStamps = 1:numT;
%%
timeStamps2 = zeros(1,length(timeStamps));
targetSums = zeros(1,length(timeStamps));
curInd = 1;
for tt = 1:length(timeStamps)
    
    tt
    
    fileNum = timeStamps(tt);
    
    %fn = ['zach_RR/q2hrus' dataFiles3(fileNum).name(12:end)];
    fn = ['zach_RR2/q2hrus' dataFiles3(fileNum).name(12:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    
   
    curData = load(fn);
    try
       ir = curData.ir; 
    catch
       ir = curData.rr;
    end

    curImage = ir(126:625,126:875);
    
    curImage(curImage<0)=0;
    
    curSum = sum(curImage(:));
    targetSums(tt) = curSum;
    if(curSum>precipThresh)
        %curSum
        timeStamps2(curInd) = fileNum;
        curInd = curInd + 1;
    end
    
    
end

timeStamps2 = timeStamps2(1:(curInd-1));
timeStamps2 = sort(timeStamps2);

%%

%used as pixel value for 0<x<1 pixels
delta = 0.1;

%timeStamps2 = [2 3 5:9 44:52 57 61 95 107:111 138:148 157];
%timeStamps2 = [435 437 440 481 485];

%timeStamps2 = predsDifferOrdered;
%indTime=485;
%timeStamps2 = [indTime];

numTimeStamps = length(timeStamps2);

numPred = 2;
patchesT = cell(1,numTimeStamps);
patchesPred = cell(1,numTimeStamps);

for tt = 1:numTimeStamps
    
    %tt
    
    
    
    fileNum = timeStamps2(tt);
    fprintf(['Now Sampling Image ' num2str(tt) ' of ' num2str(numTimeStamps) ...
        ' (File Number: ' num2str(fileNum) ')\n']);
    %{
    prefPred = preferredPredByW(tt);
    fprintf(['Preferred Prediction: ' num2str(prefPred) '\n']);
    fprintf(['W Difference: ' num2str(largestDiffsW(tt)) '\n']);
    fprintf(['RMSE Difference: ' num2str(rValInLargestDiffsW(tt)) '\n\n']);
    %}
        
    %fn = ['zach_RR/q2hrus' dataFiles3(fileNum).name(12:end)];
    %fn2 = ['zach_ccs/rgo' dataFiles3(fileNum,1).name(12:end)];
    %fn3 = ['negarPredMaps/decTreePred' dataFiles3(fileNum,1).name(12:end)];
    
    fn = ['zach_RR2/q2hrus' dataFiles3(fileNum).name(12:end)];
    fn2 = ['zach_ccs2/rgo' dataFiles3(fileNum,1).name(12:end)];
    fn3 = ['negarPredMaps2/decTreePred' dataFiles3(fileNum,1).name(12:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    if ~exist(fn2,'file')
                continue;
    end
    if ~exist(fn3,'file')
                continue;
    end
    
    curData = load(fn);
    try
       ir = curData.ir; 
    catch
       ir = curData.rr;
    end
    curImage = ir(126:625,126:875);
    leaveOutIndices = find(curImage<0);
    indicesSmallValues = find(curImage>=0 & curImage<1);
    curImage(leaveOutIndices)=0;
    if(sum(curImage(:))<=epsilon)
       continue; 
    end
    
    ccsData = load(fn2); 
    try
        ccsIR = ccsData.ir;
    catch
        ccsIR = ccsData.ccs;
    end
    ccsOverUS = ccsIR(376:875,5751:6500);
    
    negarPred = load(fn3); precipMap = negarPred.precip;

    ccsOverUS(ccsOverUS<0)=0;
    precipMap(precipMap<0)=0;
    
    curPredImages = cell(1,numPred);
    curPredImages{1} = precipMap;
    curPredImages{2} = ccsOverUS;
    
    indicesUse = find(curImage>=0);
    decTreeRMSE = sqrt(mean((curImage(indicesUse)-precipMap(indicesUse)).^2));
    ccsRMSE = sqrt(mean((curImage(indicesUse)-ccsOverUS(indicesUse)).^2));
    
    %save(['patchesSep2011DataTest5_time' num2str(fileNum) '_rmse.mat'],'decTreeRMSE','ccsRMSE');
    
    minDist = 18;
    patchSize = 20;
    maxTries = 2000;
    maxNumPatches = 500;
    minPatchSum = 1;

    curImage2 = curImage;
    curImage2(indicesSmallValues) = delta;
    samplingImage=curImage2+ccsOverUS+precipMap;
    samplingImage(leaveOutIndices)=0;
    [ ~, randPatchesCornerCoord, patchSum ] = ...
        getSampledPatches( samplingImage, patchSize, minDist, maxNumPatches, maxTries, delta );
    curImage(indicesSmallValues) = 0;
    
    targetPatches = getPatchesFromCoords(curImage,randPatchesCornerCoord,patchSize);
    curPredPatches = cell(numPred,length(targetPatches));
    for j = 1:numPred
        curPredPatches(j,:) = getPatchesFromCoords(curPredImages{j},randPatchesCornerCoord,patchSize);
    end
    
    indicesToKeep = zeros(1,length(targetPatches));
    newInd = 1;
    for i = 1:length(targetPatches)
       
        curT = targetPatches{i};
        if(sum(curT(:))<=epsilon)
            continue;
        end
        
        
        numBad=0;
        for j = 1:numPred
           curPred = curPredPatches{j,i}; 
           if(sum(curPred(:))<0)
              numBad=numBad+1; 
           end
        end
        if(numBad>0)
           continue; 
        end
        
        indicesToKeep(newInd) = i;
        newInd = newInd + 1;
        
    end
    indicesToKeep = indicesToKeep(1:(newInd-1));
    
    targetPatches = targetPatches(indicesToKeep);
    predPatches = curPredPatches(:,indicesToKeep);
    
    patchesT{tt} = targetPatches;
    patchesPred{tt} = predPatches;

    %save(['patchesSep2011DataTest5_time' num2str(fileNum) '.mat'],'targetPatches','predPatches');
    
    %fg = figure
    %drawMapWithPatches(curImage,randPatchesCornerCoord(indicesToKeep),patchSize);
    %{
    figure
    subplot(1,3,1)
    curImage(leaveOutIndices)=-1;
    drawMapWithPatches(curImage,randPatchesCornerCoord(indicesToKeep),patchSize);
    
    subplot(1,3,2)
    precipMap(leaveOutIndices)=-1;
    drawMapWithPatches(precipMap,randPatchesCornerCoord(indicesToKeep),patchSize);
    
    subplot(1,3,3)
    ccsOverUS(leaveOutIndices)=-1;
    drawMapWithPatches(ccsOverUS,randPatchesCornerCoord(indicesToKeep),patchSize);
    %}
    
    
    %pause(1);
    
    %close(fg);
end


%now find total number of patches found
numPatches = 0;
for i = 1:length(patchesT)
    numPatches = numPatches + length(patchesT{i});
end


targetPatches = cell(1,numPatches);
predPatches = cell(numPred,numPatches);
index = 1;
for i = 1:length(patchesT)
    
    curPatchesT = patchesT{i};
    curPredPatches = patchesPred{i};
    
    for j = 1:length(curPatchesT);
        
        targetPatches{index} = curPatchesT{j};
        predPatches(:,index) = curPredPatches(:,j);
       
        index = index+1;
    end
    
end

save(['patchesSep2011DataTest7.mat'],'targetPatches','predPatches');
%%
masterTarget = targetPatches;
masterPred = predPatches;


for kk=1:9
    targetPatches = masterTarget;
    predPatches = masterPred;
    inds = randperm(numPatches);
    randTenPerc = inds(1:963);
    targetPatches = targetPatches(randTenPerc);
    predPatches = predPatches(:,randTenPerc);
    save(['patchesSep2011DataTest4_rand' num2str(kk) '.mat'],...
        'targetPatches','predPatches');
end
%%
%save(['patchesSep2011DataTest2_time' num2str(indTime) '.mat'],'targetPatches','predPatches');

%save('patchesSep2011Data_allT_new3.mat','targetPatches','predPatches','patchesT','patchesPred');




