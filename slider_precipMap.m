function slider_precipMap(src,eventdata,arg1)
val = floor(get(src,'Value'));
rr1 = arg1(:,:,val);
imagesc(rr1)
colormap([1 1 1;0.8 0.8 0.8;jet(20)])
caxis([-1 20]) 
drwvect([-135 25 -65 50],[625 1750],'us_states_outl_ug.tmp','k');
colorbar('vertical')
end

