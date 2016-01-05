%{
dice roll probabilities
according to this website:
http://mathworld.wolfram.com/Dice.html
%}
rolls = 2:12;
probs = (6-abs(rolls-7))/36;

%each entry is probability of that roll or greater
probsGreater = [1 1-cumsum(probs)];
probsGreater = probsGreater(1:end-1);

%expected value for each entry
expectedValue = rolls.*probsGreater + 2.*(1-probsGreater);

figure
plot(rolls,expectedValue)
xlabel('Dice Roll Guess');
ylabel('Expected Value of Guess');
title('Dice Roll Guess vs. Expected Value');
%%

%roll the dice
diceOne = 1:6;
diceTwo = 1:6;
[ONE,TWO] = meshgrid(diceOne,diceTwo);
matrixOfPossible = ONE+TWO;

%change lowest one to 4 if one is less than 4
for i = 1:6
   for j = 1:6
       if(i < 4 || j < 4)
           newI = i; newJ = j;
          if(i < j)
             newI = 4; 
          else
             newJ = 4;
          end
          matrixOfPossible(i,j)=newI+newJ;
       end
   end
end

%tabulate the outcomes and probabilities of each one
curTable = tabulate(matrixOfPossible(:));
rolls = curTable(:,1);
probs = curTable(:,2)./sum(curTable(:,2));
rolls = rolls(5:end); probs = probs(5:end);

%each entry is probability of that roll or greater
probsGreater = [1 1-cumsum(probs')];
probsGreater = probsGreater(1:end-1);

%expected value for each entry
expectedValue = (rolls').*probsGreater + 2.*(1-probsGreater);

figure
plot(rolls,expectedValue)
xlabel('Dice Roll Guess');
ylabel('Expected Value of Guess');
title('Dice Roll Guess vs. Expected Value');



