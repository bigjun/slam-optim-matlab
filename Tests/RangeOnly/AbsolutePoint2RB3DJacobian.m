function [J1,J2,d] = AbsolutePoint2RB3DJacobian(p,b,RObs,range)

O3 = zeros(3,1);


%p-b
[rb,v] = AbsolutePoint2RB3D(p,b) ;
J1 = [v/rb;O3]';
J2 = -(v/rb)';


% %b-p
% [rb,v] = AbsolutePoint2RB3D(b,p) ;
% J1 = -[v/rb;O3]';
% J2 = (v/rb)';


J1 = RObs * J1;
J2 = RObs * J2;
d = RObs * (range - rb)';

end