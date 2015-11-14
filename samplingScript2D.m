fileNum=15;

dataFiles = dir('data/compiledData/data*');
load(['data/compiledData/' dataFiles(fileNum).name]);
    
rr1 = rr1(251:875,5626:7375);
rr2 = rr2(1:625,:);
ir = ir(1:625,:);
obs = obs(1:625,:); 

curImage = rr1;
curImage(curImage<0)=0;

%make octree for all the slots where sample
%   could come from in (x,y,t) space
minDist = 15;
patchSize = 20;
slotDist=minDist/2;
slots = zeros(floor(size(curImage)/slotDist)+1);


maxTotalPatches = numel(slots);
patchSum = zeros(1,maxTotalPatches);
randPatches = cell(1,maxTotalPatches);
randPatchesCornerCoord = cell(1,maxTotalPatches);

%gets indices using precip map as PDF
imageValues = curImage(:);
cdfX = cumsum(imageValues./sum(imageValues));

imgIndex=1;
maxTries = 1000;

for k = 1:maxTries

    curSample = find(rand<cdfX, 1 );
   [randStartRow,randStartCol] = ind2sub(size(curImage),curSample);
   if(randStartRow-patchSize/2 < 1 || randStartRow+patchSize/2 > size(curImage,1))
      continue; 
   end
   if(randStartCol-patchSize/2 < 1 || randStartCol+patchSize/2 > size(curImage,2))
      continue; 
   end
   
   %if(imgIndex>200)
   %   break; 
   %end
   
   slotX = floor(randStartRow/slotDist)+1;
   slotY = floor(randStartCol/slotDist)+1;

   if(slots(slotX,slotY) > 0)
      continue; 
   end

   slots(slotX,slotY)=1;

   randPatch = curImage(...
       (randStartRow-patchSize/2):(randStartRow+patchSize/2-1),...
       (randStartCol-patchSize/2):(randStartCol+patchSize/2-1));

   curLocation = [randStartRow randStartCol];

   ourPatch = randPatch;
   curPatchSum = sum(ourPatch(:));

   if(curPatchSum > 0)
        patchSum(imgIndex) = curPatchSum;
        randPatches{imgIndex} = ourPatch;
        randPatchesCornerCoord{imgIndex} = curLocation;
        imgIndex = imgIndex+1;

        if(mod(imgIndex,100) == 0)
           imgIndex 
        end
   end


end

patchSum = patchSum(1:(imgIndex-1));
randPatches = randPatches(1:(imgIndex-1));
randPatchesCornerCoord = randPatchesCornerCoord(1:(imgIndex-1));

maxNum = length(randPatches);
patchesCornerCoord = cell(1,maxNum);
curIndex=1;

%closest ones
for i = 1:maxNum
    patchLoc = randPatchesCornerCoord{i};
    numBad=0;
    for j=1:(curIndex-1)
        curLoc = patchesCornerCoord{j};
        if(norm(patchLoc-curLoc)<minDist)
           numBad = numBad+1; 
        end
    end
    if(numBad<1)
        patchesCornerCoord{curIndex} = patchLoc;
        curIndex = curIndex + 1;
    end
    if(mod(i,100)==0)
       i 
    end
end
patchesCornerCoord = patchesCornerCoord(1:(curIndex-1));

figure(1)
imagesc(curImage)
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
drwvect([-135 25 -65 50],[625 1750],'us_states_outl_ug.tmp','k');
colorbar('vertical')
hold on
for i = 1:length(patchesCornerCoord)
   centerLoc = patchesCornerCoord{i};
   centerLoc = centerLoc - [patchSize/2 patchSize/2];
   rectangle('Position',[centerLoc(2) centerLoc(1) patchSize patchSize]);
end
hold off








