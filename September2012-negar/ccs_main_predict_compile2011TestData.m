%{
NOTE ABOUT TC.MAT
It was trained over every 4th timestep (every 2 hours)
    with the radar and ir data
    for Sep 2012
Every 4th timestep was used, they were NOT accumulated
%}

% PERSIANN-CCS decision tree added
% Negar Karbalaee
% February 2016

% First of all we should load tc which is an object for
% model predi

%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

%files = dir('goes/bghrus1209*');
files = dir('zach_IR2/bghrus1109*');
%load('tc.mat');
NN = length(files);

precip = zeros(500,750);
precipNick = zeros(500,750);

XteArray = cell(1,NN);
YteArray = cell(1,NN);
%%
for i = 1:4:NN
    i
   
    fn =['zach_IR2/', files(i,1).name];
    fn3 = ['zach_RR2/q2hrus', files(i,1).name(7:end)];
    fn4 = ['zach_IR2_patches/segs_feat', files(i,1).name(7:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    
    if ~exist(fn3,'file')
                continue;
    end
    
    if ~exist(fn4,'file')
                continue;
    end
    
    %ir = loadbfn_bgz(fn, DIM, 'short')/100;
    irFileData = load(fn);
    rrFileData = load(fn3);
	ir = irFileData.ir;
	rr = rrFileData.rr;
    
    % area for training and testing over the US
    ir = ir(126:625,126:875);
    
    rrTest = rr(126:625,126:875);
    
    load(fn4,'L','MAXL','FF');
             

    
    XteCurrent = ccs_patchpixel_Feature(ir,L,MAXL,FF);
    
    YteCurrent = rrTest(ir>0 & L>0);
	
	indicesToUse = (YteCurrent>=0);
	
	XteCurrentUse = XteCurrent(indicesToUse,:);
	YteCurrentUse = YteCurrent(indicesToUse);
    
    
    XteArray{i} = XteCurrentUse;
    YteArray{i} = YteCurrentUse;
  
    
end

save('sep2011TestDataSet2.mat','XteArray','YteArray');


totalNumEntries = 0;
for i = 1:length(YteArray)
   totalNumEntries = totalNumEntries + length(YteArray{i}); 
end

XteOct = zeros(totalNumEntries,size(XteArray{1},2));
YteOct = zeros(totalNumEntries,1);

curStart = 1;
for i = 1:length(YteArray)
   curLen = length(YteArray{i});
   XteOct(curStart:(curStart+curLen-1),:) = XteArray{i};
   YteOct(curStart:(curStart+curLen-1)) = YteArray{i};
   curStart = curStart + curLen;
end

save('sep2011TestDataSetAll2.mat','XteArray','YteArray','XteOct','YteOct');