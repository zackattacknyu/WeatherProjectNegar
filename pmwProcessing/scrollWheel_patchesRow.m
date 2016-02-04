function [  ] = scrollWheel_patchesRow( src, event, patchesDisp,slider )
%SCROLLWHEEL_PRECIPMAP Summary of this function goes here
%   Detailed explanation goes here
%display(event)
%display(get(xx,'Value'));

val1 = floor(get(slider,'Value'));
minV = get(slider,'Min'); maxV = get(slider,'Max');

val = val1 - event.VerticalScrollCount;
if(val >= minV && val <= maxV)
    set(slider,'Value',val);
else
    val = val1;
end


displayPatchesRow(patchesDisp,val);
end

