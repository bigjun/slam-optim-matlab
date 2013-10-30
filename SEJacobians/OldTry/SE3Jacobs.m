clear

syms ux uy uz ua ub uc real
syms vx vy vz va vb vc real
% real scalar inputs

syms u v up vp ur vr real
up = [ux uy uz]';
ur = [ua ub uc]';
vp = [vx vy vz]';
vr = [va vb vc]';
u = [up; ur];
v = [vp; vr];
% inputs as vectors

%syms dx dy dz da db dc real % not required, outputs are vectors
syms qu quc real
syms thu positive
syms qv real
syms thv positive
syms qd c halfangle real
% intermediates

syms dp dr real
% outputs as vectors

thu = sqrt(ur' * ur);
%thuE=sqrt(ua^2+ub^2+uc^2);

thv = sqrt(vr' * vr);
%thvE=sqrt(va^2+vb^2+vc^2);

qu = [ur * (sin(thu / 2) / thu); cos(thu / 2)];
% xuE=(ua/thu)*(sin(thu/2));
% yuE=(ub/thu)*(sin(thu/2));
% zuE=(uc/thu)*(sin(thu/2));
% wuE=cos(thu/2);
% quE =[xuE, yuE, zuE, wuE];

qv = [vr * (sin(thv / 2) / thv); cos(thv / 2)];
% xvE=(va/thv)*(sin(thv/2));
% yvE=(vb/thv)*(sin(thv/2));
% zvE=(vc/thv)*(sin(thv/2));
% wvE=cos(thv/2);
% qvE =[xvE, yvE, zvE, wvE];

quc = [-qu(1); -qu(2); -qu(3); qu(4)];


c = cross(quc(1:3), vp - up);

% cx=-yuE*(vz-uz)+zuE*(vy-uy);
% cy=-zuE*(vx-ux)+xuE*(vz-uz);
% cz=-xuE*(vy-uy)+yuE*(vx-ux);
% cE=[cx,cy,cz];


dp = 2 * quc(4) * c + vp - up + cross(quc(1:3), 2 * c)

% CP=cross( quc(1:3),(2 * c))
% 
% dx=2*wuE*cx + vx-ux +2*cy*zuE - 2*cz*yuE;
% dy=2*wuE*cy + vy-uy +2*cz*xuE - 2*cx*zuE;
% dz=2*wuE*cz + vz-uz +2*cx*yuE - 2*cy*xuE;
% 
% %CPx=- yuE*2*cz + zuE*2*cy;
% %CPy=- zuE*2*cx + xuE*2*cz;
% %CPz=- xuE*2*cy + yuE*2*cx;
% 
% CPx=2*cy*zuE - 2*cz*yuE;
% CPy=2*cz*xuE - 2*cx*zuE;
% CPz=2*cx*yuE - 2*cy*xuE;
% 
% dpE=[dx;dy;dz];
% CPE=[CPx;CPy;CPz];

qd = quatnormalize(quatmultiply(quc', qv'))'
%qd = quc .* qv % i don't have the quaternion toolbox

halfangle = acos(qd(4))
dr = qd(1:3) .* (2 * halfangle / sin(halfangle))
% calculate the dest rotation

d = [dp; dr]
% the difference

% syms theta positive % theta is thu
% syms costheta sintheta real % these are sin and cos of theta
% syms omega positive % omega is thv
% syms cosomega sinomega real % these are sin and cos of omega
% Ju = jacobian(d, u);
% Jv = jacobian(d, v);
% 
% Ju = subs(Ju, (ua^2+ub^2+uc^2)^(1/2), theta);
% Ju = subs(Ju, (va^2+vb^2+vc^2)^(1/2), omega);
% Ju = subs(Ju, (ua^2+ub^2+uc^2), theta^2);
% Ju = subs(Ju, (va^2+vb^2+vc^2), omega^2);
% Ju = subs(Ju, cos(1/2*theta), costheta);
% Ju = subs(Ju, sin(1/2*theta), sintheta);
% Ju = subs(Ju, cos(1/2*omega), cosomega);
% Ju = subs(Ju, sin(1/2*omega), sinomega)
% %Ju = simplify(Ju)
% 
% 
% Jv = subs(Jv, (ua^2+ub^2+uc^2)^(1/2), theta);
% Jv = subs(Jv, (va^2+vb^2+vc^2)^(1/2), omega);
% Jv = subs(Jv, (ua^2+ub^2+uc^2), theta^2);
% Jv = subs(Jv, (va^2+vb^2+vc^2), omega^2);
% Jv = subs(Jv, cos(1/2*theta), costheta);
% Jv = subs(Jv, sin(1/2*theta), sintheta);
% Jv = subs(Jv, cos(1/2*omega), cosomega);
% Jv = subs(Jv, sin(1/2*omega), sinomega)
%Jv = simplify(Jv)

syms th positive % theta is thu
syms cth sth real % these are sin and cos of theta
syms o positive % omega is thv
syms co so real % these are sin and cos of omega
Ju = jacobian(d, u);
Jv = jacobian(d, v);


Ju = subs(Ju, (ua^2+ub^2+uc^2)^(1/2), th);
Ju = subs(Ju, (va^2+vb^2+vc^2)^(1/2), o);
Ju = subs(Ju, (ua^2+ub^2+uc^2), th^2);
Ju = subs(Ju, (va^2+vb^2+vc^2), o^2);
Ju = subs(Ju, cos(1/2*th), cth);
Ju = subs(Ju, sin(1/2*th), sth);
Ju = subs(Ju, cos(1/2*o), co);
Ju = subs(Ju, sin(1/2*o), so)
%Ju = simplify(Ju)


Jv = subs(Jv, (ua^2+ub^2+uc^2)^(1/2), th);
Jv = subs(Jv, (va^2+vb^2+vc^2)^(1/2), o);
Jv = subs(Jv, (ua^2+ub^2+uc^2), th^2);
Jv = subs(Jv, (va^2+vb^2+vc^2), o^2);
Jv = subs(Jv, cos(1/2*th), cth);
Jv = subs(Jv, sin(1/2*th), sth);
Jv = subs(Jv, cos(1/2*o), co);
Jv = subs(Jv, sin(1/2*o), so)



