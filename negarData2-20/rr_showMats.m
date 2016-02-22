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

folderName = 'zach_RR/';

files = dir([folderName 'q2hrus*']);

NN = length(files);

precip = zeros(500,750);

for i = 1:NN
    i
   
    fn =[folderName, files(i,1).name];
    
    if ~exist(fn,'file')
                continue;
    end
    
    load(fn);
    
    % area for training and testing over the US
    ir = ir(126:625,126:875);
    
    ir(ir<0)=0;
    
    figure(1)
    imagesc(ir);
    colorbar;
    drawnow;
    
    pause(1);
    
end
 


