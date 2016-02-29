%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

files = dir('zach_IR2/bghrus1109*');
load('tc.mat');

NN = length(files);

precip = zeros(500,750);

for i = 1:NN
    i
    
    fn =['zach_IR2/', files(i,1).name];
    fn2 = ['zach_IR2_patches/segs_feat' files(i,1).name(7:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    
    if ~exist(fn2,'file')
                continue;
    end
   
    load(fn,'ir');
    
    % area for training and testing over the US
    ir = ir(126:625,126:875);
    
    load(fn2,'L','MAXL','FF');
    
    
    Xte = ccs_patchpixel_Feature(ir,L,MAXL,FF);
    
    cd('./@treeRegress/')
    
     rr2 = predict(tc,Xte);  
        
    cd('../') 
     
    
    precip(ir<0) = -1;
    precip(L==0) = 0;
    precip(ir>0 & L>0) = rr2;
    
    save(['negarPredMaps2/decTreePred' files(i,1).name(7:end)],'precip');
    
    
end