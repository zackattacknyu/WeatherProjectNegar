function slider_callback1(src,eventdata,arg1)
val = get(src,'Value');
%set(arg1,'Position',[0 -val 1 2])
imagesc(rand(50,50)*val*100);
colorbar;
display(val)
end

