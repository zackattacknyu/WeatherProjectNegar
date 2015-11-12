%comparing CCS-253 and CCS280 and radar together

files = dir('data/compiledData/');

l = length(files);

DIM1=[3000,9000];
DIM2 =[1000,1750];

for i = 1:l
    
    curFileName = files(i).name;
    
    if(length(curFileName)<4)
       continue; 
    end
    
    load(['data/compiledData/',curFileName]);
    
    rr1 = rr1(251:875,5626:7375);
    rr2 = rr2(1:625,:);
    ir = ir(1:625,:);
    obs = obs(1:625,:); 
    
    figure(1)
    imagesc(rr1)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-135 25 -65 50],[625 1750],'us_states_outl_ug.tmp','k');
    colorbar('vertical')
    %title(fn1);
    
    figure(2)
    imagesc(rr2)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-135 25 -65 50],[625 1750],'us_states_outl_ug.tmp','k');
    colorbar('vertical')
    %title(fn2)
    
    figure(3)
    imagesc(ir)
    colormap(jet(120))
    caxis([180 300]) 
    drwvect([-135 25 -65 50],[625 1750],'us_states_outl_ug.tmp','k');
    colorbar('vertical')
    %title(ir)
    
    figure(4)
    imagesc(obs)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    drwvect([-135 25 -65 50],[625 1750],'us_states_outl_ug.tmp','k');
    colorbar('vertical')
    %title(obs)
    
    
    
    pause(7)
    clf
    
end