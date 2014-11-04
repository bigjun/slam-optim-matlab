function [dd,range,vect] = AbsoluteBuoy2DD(pose, buoys)
%returns a vector of size (nb x 1) of double differences (column vector)

nb = length(buoys);

dd = [];
range = [];
vect = [];
pivot = buoys(1,:); % set pivot 
[r_pivot,v] = getRange(pose,pivot); % pseudo range
if (nargout >1)
    range = [range;r_pivot];
    vect = [vect;v'];
end
for i=2:nb
    [r,v] = getRange(pose,buoys(i,:)); % pseudo range
    dd =  [dd;r - r_pivot];
    if (nargout >1)
        vect = [vect;v'];
        range = [range;r];
    end
end
end

function [r,v]=getRange(pose,buoy)

v=(buoy-pose)';
r = sqrt(v'*v); 
end