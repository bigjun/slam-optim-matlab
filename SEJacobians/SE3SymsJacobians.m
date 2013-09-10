syms dppu vx vy vz ux uy uz wu xu yu zu thu xv yv zv wv thv va vb vc ua ub uc cx cy cz

thu=sqrt(ua^2+ub^2+uc^2);
xu=(ua/thu)*(sin(thu/2));
yu=(ub/thu)*(sin(thu/2));
zu=(uc/thu)*(sin(thu/2));
wu=cos(thu/2);
thv=sqrt(va^2+vb^2+vc^2);
xv=(va/thv)*(sin(thv/2));
yv=(vb/thv)*(sin(thv/2));
zv=(vc/thv)*(sin(thv/2));
wv=cos(thv/2);
cx=-yu*(vz-uz)+uz*(vy-uy);
cy=-zu*(vx-ux)+ux*(vz-uz);
cz=-xu*(vy-uy)+uy*(vx-ux);
dx=2*wu*cx+vx-ux-yu*2*cz+zu*2*cy;
dy=2*wu*cy + vy-uy - zu*2*cx + xu*2*cz;
dz=2*wu*cz + vz-uz - xu*2*cy + yu*2*cx;
dp=[dx;dy;dz];
p=[ux;uy;uz];
dppu=jacobian(dp,p);
