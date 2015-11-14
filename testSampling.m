imageValues = curImage(:);

epsilon = 1e-9; %cannot have zero values
imageValues(imageValues<epsilon)=epsilon;

cdfX = cumsum(imageValues./sum(imageValues));

numSamples = 5000;
samples = zeros(1,numSamples);
for i = 1:numSamples
   %samples(i) = sum(rand > cdfX);
   samples(i) = find(rand<cdfX, 1 );
end

figure
plot(imageValues);

figure
hist(samples,50);