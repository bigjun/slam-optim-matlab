function [PR_p,PR_b,rhs] = AbsoluteBuoy2PRJacobian(p,b,bc,RObs,meas)

O3 = zeros(3,1);

%buoy-pose
[rb,v] = AbsoluteBuoy2PR(p,b,bc) ;
PR_p = [-v/rb;O3;1]';
PR_b = (v/rb)';

PR_p = RObs * PR_p;
PR_b = RObs * PR_b;
rhs = RObs * (meas - rb)';

