numTrials = 10000;
numRolls = zeros(1,numTrials);
numAttempts = 2000;

for i = 1:numTrials
    curArray = floor(rand(1,numAttempts)*6+1);
   for k = 3:numAttempts
       if(sum(curArray(k-2:k))>=18)
           numRolls(i)=k;
          break; 
       end
   end
end

mean(numRolls)