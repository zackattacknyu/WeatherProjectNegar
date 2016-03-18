
bad = 1;
while bad
	try
		load('decTreeSepOct2012.mat','Y','Ytr','Yte');
		bad = 0;
	catch
		bad = 1;
		fprintf('Will look for file again in 3 seconds...\n');
		pause(3);
	end
end

load('sep2011TestDataSetAll.mat','XteOct','YteOct');

meanY = mean(YteOct);

meanInitY = mean(Y);
meanTrainY = mean(Ytr);
meanValidY = mean(Yte);

%predict mean
stdData = std(YteOct)

%predict 0
rmseBaseline = sqrt(mean(YteOct.^2))

%predict 1
rmseBaseline2 = sqrt(mean((YteOct-1).^2))

rmseBaselineMeanY = sqrt(mean((YteOct-meanInitY).^2))
rmseBaselineMeanYtrain = sqrt(mean((YteOct-meanTrainY).^2))
rmseBaselineMeanYvalid = sqrt(mean((YteOct-meanValidY).^2))

save('baselineResults2.mat','rmseBaselineMeanY','rmseBaselineMeanYtrain','rmseBaselineMeanYvalid');