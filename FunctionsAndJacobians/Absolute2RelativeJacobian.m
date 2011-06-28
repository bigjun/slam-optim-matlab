function [H1 H2]=Absolute2RelativeJacobian(p1,p2)

% Jacobian of the relative displacement between two poses.

dx=(p2(1)-p1(1));
dy=(p2(2)-p1(2));

c1=cos(p1(3));
s1=sin(p1(3));

H1=[[-c1 -s1 -s1*dx+c1*dy ];
    [ s1 -c1 -c1*dx-s1*dy ];
    [  0   0    -1        ]];

H2=[[ c1  s1 0];
    [-s1  c1 0];
    [  0   0 1]];

%H2=eye(3); % gtsam implementation

