function p2=Relative2Absolute(p1,d)

% computes the absolute position of p2 knowing p1 and d. p1 and d must be
% column vectors 
o=p1(3);
R=[[ cos(o) -sin(o) 0];
    [ sin(o)  cos(o) 0];
    [      0       0 1]];
Pr=R*d;

p2(1:2,1)=p1(1:2,1) + Pr(1:2,1);
p2(3,1)=pi2pi(p1(3,1) + Pr(3,1));
