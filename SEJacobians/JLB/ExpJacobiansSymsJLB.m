function [eD,De] = ExpJacobiansSymsJLB(R)

I3 = eye(3);
O33 = zeros(3,3);
O31 = zeros(3,1);
O93 = zeros(9,3);

d1=R(1:3,1); 
d2=R(1:3,2);
d3=R(1:3,3);

eD=[O33 -skew_symmetric(d1); O33 -skew_symmetric(d2); O33 -skew_symmetric(d3); I3 O33];

dx=[O31, -d3, d2;
     d3, O31, -d1;
    -d2, d1, O31]

De=[O93 dx; R O33]; 



G1 = [0 0 0; 0 0 -1; 0 1 0];
G2 = [0 0 1; 0 0 0; -1 0 0];
G3 = [0 -1 0; 1 0 0; 0 0 0];

G = [G1*R G2*R G3*R]










