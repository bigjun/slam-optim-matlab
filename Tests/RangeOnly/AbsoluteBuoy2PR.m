function [pr,v]=AbsoluteBuoy2PR(pose,buoy,bc)
%
% Returns the pseudorange
% vx and vy from the pose to the landmark


v=(buoy-pose)';


%v=(pose-buoy)';

pr = sqrt(v'*v) + bc;
  