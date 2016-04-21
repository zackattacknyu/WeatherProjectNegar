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

%files = dir('zach_ccs2/rgo1209*');
files = dir('zach_ccs2/rgo1109*');
NN = length(files);

covered = false(1,NN);

for i = 1:NN
   
    
    fn =['zach_RR2/q2hrus', files(i).name(4:end)];
    fn3 =['zach_IR2/bghrus', files(i).name(4:end)];
    fn2 = ['zach_ccs2/' files(i).name];
    fn4 = ['zach_IR2_patches/segs_feat' files(i).name(4:end)];
    
    %if ~exist(fn,'file')
    %            continue;
    %end
    
    %if ~exist(fn2,'file')
    %            continue;
    %end
   
    if ~exist(fn3,'file')
                continue;
    end
    
    %if ~exist(fn4,'file')
    %            continue;
    %end
    
    i
    covered(i)=true;
    %{
    irData = load(fn3);
    ir = irData.ir;
    ir = ir(126:625,126:875);
    
    rrData = load(fn);
    try
       rr = rrData.rr; 
    catch
       rr = rrData.ir;
    end
    rrTest = rr(126:625,126:875);
    
    ccsData = load(fn2); 
    
    try
        ccsIR = ccsData.ccs;
    catch
        ccsIR = ccsData.ir;
    end
    
    ccsOverUS = ccsIR(376:875,5751:6500);
    
    patchData = load(fn4);
    L = patchData.L;
    
    ytarget = rrTest;
    xone = ir;
    ccspred = ccsOverUS;
    seg = L;
    
    fnY =['projectData/ytarget', files(i).name(4:end)];
    fnX1 =['projectData/xone', files(i).name(4:end)];
    fnCcs = ['projectData/ccspred', files(i).name(4:end)];
    fnSeg = ['projectData/seg' files(i).name(4:end)];
    
    save(fnY,'ytarget');
    save(fnX1,'xone');
    save(fnCcs,'ccspred');
    save(fnSeg,'seg');
  
    %}
end


