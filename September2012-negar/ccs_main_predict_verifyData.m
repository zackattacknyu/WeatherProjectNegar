%%NOTE: VERIFIED!!

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
files = dir('matFiles/data12*');
NN = length(files);
%%
for i = 1:NN
    %i
   
    curName = files(i).name;
    fn =['matFiles/' curName];
    fn2 = ['zach_IR/bghrus' curName(5:end)];
    fn3 = ['zach_RR/q2hrus' curName(5:end)];
    
    if ~exist(fn,'file')
                continue;
    end
    
    if ~exist(fn2,'file')
                continue;
    end
   
    if ~exist(fn3,'file')
                continue;
    end
    
    
    load(fn,'ir','rr');
    
    irOld = ir;
    rrOld = rr;
    
    load(fn2,'ir');
    
    irNew = ir;
    
    load(fn3,'ir');
    
    rrNew=ir;
    
    curErrorIR = sum(sum(irOld-irNew))
    curErrorRR = sum(sum(rrOld-rrNew))
    
end
 
%%

files = dir('zach_ccs/rgo*');
NN = length(files);

for i = 1:NN
    %i
   
    curName = files(i).name;
    fn =['zach_ccs/' curName];
    
    
    if ~exist(fn,'file')
                continue;
    end
    
    
    load(fn,'ir');
    
    ir2 = ir; ir2(ir<0)=0;
    figure(1)
    imagesc(ir2);
    drawnow
    
    pause(1)
    
    
end

