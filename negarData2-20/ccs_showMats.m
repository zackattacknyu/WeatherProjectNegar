%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

folderName = 'zach_ccs/';

files = dir([folderName 'rgo*']);

NN = length(files);

precip = zeros(500,750);

for i = 1%:NN
    i
   
    fn =[folderName, files(i,1).name];
    
    if ~exist(fn,'file')
                continue;
    end
    
    load(fn);
    
    % area for training and testing over the US
    ir = ir(126:625,126:875);
    
    
    figure(1)
    imagesc(ir)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
    colorbar('vertical')
    title(fn)
    

end
 


