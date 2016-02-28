files = dir('tc_NickJ128rf8_iter*');

for i = 8:length(files)
   i
   fileData = load(files(i).name,'boostStruct','boostArgs');
   saveStr = [files(i).name(1:end-4) '_treeOnly.mat'];
   save(saveStr,'boostStruct','boostArgs');
end