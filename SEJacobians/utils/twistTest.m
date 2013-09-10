%function (v, omega)
dx=1;
dy=0;
dth=pi/2;
n=20;



dT=[cos(dth/n) -sin(dth/n) dx/n; sin(dth/n) cos(dth/n) dy/n; 0 0 1]
T1=dT^n



twist=[0 -dth dx; dth 0 dy; 0 0 0]

T= (eye(3)+1/n*twist)^n



TG=[cos(dth) -sin(dth) dx; sin(dth) cos(dth) dy; 0 0 1]