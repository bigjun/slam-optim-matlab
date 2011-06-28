function Pr=Absolute2Relative(p1,p2)

% computes the relative position of p2 in coordinates of p1. 
%p1,p2 must be column vectors and Pr is column vector
d(1:2,1)=p2(1:2)-p1(1:2);
d(3,1)=pi2pi(p2(3)-p1(3));
%d=p2-p1;
o=-p1(3);
R=[[ cos(o) -sin(o) 0];
   [ sin(o)  cos(o) 0];
   [      0       0 1]];

Pr=R*d;