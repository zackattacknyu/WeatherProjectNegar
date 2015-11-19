%comparing CCS-253 and CCS280 and radar together

files = dir('data/compiledData2/data*');

l = length(files);

num = 30;

DIM1=[3000,9000];
DIM2 =[1000,1750];

oldPredErrors = zeros(1,num);
newPredErrors = zeros(1,num);

rr1Block = zeros(625,1750,num);
%rr2Block = zeros(625,1750,num);
%obsBlock = zeros(625,1750,num);

for i = 1:num
    
    curFileName = files(i).name;
    
    if(length(curFileName)<4)
       continue; 
    end
    
    load(['data/compiledData/',curFileName]);
    
    rr1 = rr1(251:875,5626:7375);
    %rr2 = rr2(1:625,:);
    %ir = ir(1:625,:);
    %obs = obs(1:625,:); 
    
    rr1Block(:,:,i)=rr1;
    %rr2Block(:,:,i)=rr2;
    %obsBlock(:,:,i)=obs;   
    
    i
    
end
%%

numSlices = size(rr1Block,3);

figure(1)
panel1 = uipanel('Parent',1);
panel2 = uipanel('Parent',panel1);
set(panel1,'Position',[0 0 0.95 1]);
set(panel2,'Position',[0 0 1 1]);
set(gca,'Parent',panel2);
s = uicontrol('Style','Slider','Parent',1,...
    'Units','normalized','Position',[0.95 0 0.05 1],...
    'Value',1,'Min',1,'Max',numSlices,...
    'Callback',{@slider_precipMap,rr1Block});


    