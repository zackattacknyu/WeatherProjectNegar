%comparing CCS-253 and CCS280 and radar together

close all
clear all

files1 = dir('goes/bghrus*');
files2 = dir('ccs_t300/300trgo*');
files3 = dir('ccs_t253/rgo*');
files4 = dir('radar/q2hrus*');

files1Dates = cell(1,length(files1));
files2Dates = cell(1,length(files2));
files3Dates = cell(1,length(files3));
files4Dates = cell(1,length(files4));

for i = 1:length(files1)
   files1Dates{i} = files1(i).name(7:end-7);
end

for i = 1:length(files2)
   files2Dates{i} = files2(i).name(8:end-7);
end

for i = 1:length(files3)
   files3Dates{i} = files3(i).name(4:end-7);
end

for i = 1:length(files4)
   files4Dates{i} = files4(i).name(7:end-7);
end

intersect12 = intersect(files1Dates,files2Dates);
intersect34 = intersect(files3Dates,files4Dates);
files = intersect(intersect12,intersect34);

%files = dir('./goes/bghrus1209*')

l = length(files)

DIM1=[3000,9000];
DIM2 =[1000,1750];

for i = 1:l
    
    fn1 = ['./ccs_t253/rgo',files{i},'.bin.gz'];
    fn2 = ['./ccs_t300/300trgo',files{i},'.bin.gz'];
    fn3 = ['./goes/bghrus',files{i},'.bin.gz'];
    fn4 = ['./radar/q2hrus',files{i},'.bin.gz'];
    
    rr1 = loadbfn_lgz(fn1, DIM1, 'short')/100;
    rr2 = loadbfn_lgz(fn2, DIM2, 'short')/100;
    ir = loadbfn_bgz(fn3, DIM2, 'short')/100;
    obs = loadbfn_lgz(fn4, DIM2, 'short')/10;
    
    save(['ccs_oldNew_compiledData/data',files{i},'.mat'],'rr1','rr2','ir','obs');
    i
end