testingData = load('sep2012TestDataSet_every4thT.mat');

rmseBaseline = std(testingData.YteSept);

xData = testingData.XteSept;
numData = size(xData,1);
xData = [xData ones(numData,1)];
yData = testingData.YteSept;

rmseLinReg = zeros(1,13);
rmseExpReg = zeros(1,13);

randInds = randperm(length(yData));
numDisp = 20000;

indsDisp = randInds(1:numDisp);
%indsDisp = find(yData>1);

[b,bint,r,rint,stats] = regress(yData,xData);

yfit3=xData*b;


for kk = 1:13
    xx = xData(:,kk);
    %[pp,ss,mu] = polyfit(xx,yData,1);

    %yfit = polyval(pp,xx);
    
    %fitFunc = fit(xx,yData,'exp1');
    %yfit2 = fitFunc(xx);
        
    fig = figure
    hold on
    plot(xx(indsDisp),yData(indsDisp),'r.');
    %plot(xx(randIndsDisp),yfit3(randIndsDisp),'b.');
    hold off
    title(['Feature ' num2str(kk) ' Data'])
    xlabel('Feature Value');
    ylabel('Y Value');
    %fileNm = ['featureDisplay2/feature' num2str(kk) 'data.png'];
    %print(fig,fileNm,'-dpng');
end

%%

xx1 = xData(:,1);
xx2 = xData(:,4);
scatter3(xx1(indsDisp),xx2(indsDisp),yData(indsDisp));