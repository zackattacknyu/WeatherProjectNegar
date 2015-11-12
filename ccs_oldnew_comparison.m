%comparing CCS-253 and CCS280 and radar together

files = dir('data/compiledData/');

l = length(files);

DIM1=[3000,9000];
DIM2 =[1000,1750];

oldPredErrors = zeros(1,l);
newPredErrors = zeros(1,l);

rr1Block = zeros(l,625,1750);
rr2Block = zeros(l,625,1750);
obsBlock = zeros(l,625,1750);

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
    
    rr1Block(i,:,:)=rr1;
    rr2Block(i,:,:)=rr2;
    obsBlock(i,:,:)=obs;
    
    squError1 = (rr1-obs).^2;
    squError2 = (rr2-obs).^2;
    oldPredErrors(i) = sqrt(mean(squError1(:)));
    newPredErrors(i) = sqrt(mean(squError2(:)));
    
    i
    
end
%%

%displays the best old predictions
%[~,inds] = sort(oldPredErrors);

%displays the best new predictions
%[~,inds] = sort(oldPredErrors);

%displays predictions where new is worse than old
%inds = find(newPredErrors>oldPredErrors);

%displays predictions where old is worse than new
inds = find(newPredErrors<oldPredErrors);

for j = 1:length(inds)
    
    i = inds(j);
    
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
    %drwvect([-135 25 -65 50],[625 1750],'/home/dank/t3_vects/us_states_outl_ug.tmp','k')
    colorbar('vertical')
    %title(fn1);
    
    figure(2)
    imagesc(rr2)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    %drwvect([-135 25 -65 50],[625 1750],'/home/dank/t3_vects/us_states_outl_ug.tmp','k')
    colorbar('vertical')
    %title(fn2)
    
    figure(3)
    imagesc(obs)
    colormap([1 1 1;0.8 0.8 0.8;jet(20)])
    caxis([-1 20]) 
    %drwvect([-135 25 -65 50],[625 1750],'/home/dank/t3_vects/us_states_outl_ug.tmp','k')
    colorbar('vertical')
    %title(obs)
    
    [oldPredErrors(i) newPredErrors(i)]
    
    pause(3)
    clf
    
end