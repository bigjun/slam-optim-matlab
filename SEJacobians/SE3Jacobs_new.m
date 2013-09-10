clear

syms ux uy uz ua ub uc real
syms vx vy vz va vb vc real
syms fixup positive
% real scalar inputs

syms u v up vp ur vr real
up = [ux uy uz]'
ur = [ua ub uc]'
vp = [vx vy vz]'
vr = [va vb vc]'
u = [up; ur]
v = [vp; vr]
% inputs as vectors

%syms dx dy dz da db dc real % not required, outputs are vectors
syms qu quc real
syms thu positive
syms qv real
syms thv positive
syms qdd qd c real
% intermediates

syms halfangle fullangle d dp dr real
% outputs as vectors

thu = sqrt(ur' * ur)
thv = sqrt(vr' * vr)
qu = [ur * (sin(thu / 2) / thu); cos(thu / 2)]
qv = [vr * (sin(thv / 2) / thv); cos(thv / 2)]

quc = [-qu(1); -qu(2); -qu(3); qu(4)]

c = cross(quc(1:3), vp - up)

dp = 2 * quc(4) * c + vp - up + cross(quc(1:3), 2 * c) % yields correct results, no bug so far?

%qd = quatnormalize(quatmultiply(quc, qv))
qdd = [;
    quc(4) * qv(1) + quc(1) * qv(4) + quc(2) * qv(3) - quc(3) * qv(2);
    quc(4) * qv(2) + quc(2) * qv(4) + quc(3) * qv(1) - quc(1) * qv(3);
    quc(4) * qv(3) + quc(3) * qv(4) + quc(1) * qv(2) - quc(2) * qv(1);
    quc(4) * qv(4) - quc(1) * qv(1) - quc(2) * qv(2) - quc(3) * qv(3)]; % i don't have the quaternion toolbox
% w = a.w() * b.w() - a.x() * b.x() - a.y() * b.y() - a.z() * b.z(),
% x = a.w() * b.x() + a.x() * b.w() + a.y() * b.z() - a.z() * b.y(),
% y = a.w() * b.y() + a.y() * b.w() + a.z() * b.x() - a.x() * b.z(),
% z = a.w() * b.z() + a.z() * b.w() + a.x() * b.y() - a.y() * b.x() % thats how eigen does it
qd = qdd ./ sqrt(qdd' * qdd) % and normalize!
qdE = quatnormalize(quatmultiply(quc', qv'))'

halfangle = acos(qd(4))
fullangle = 2 * halfangle - fixup
%fullangle = 2 * (halfangle + pi * sign(qd(4))) % todo if qd(4) < 0, 2 * halfangle will be greater than pi, subtract pi from angle 
%fullangle = mod(2 * halfangle, pi) % should be the same thing
dr = qd(1:3) * (fullangle / sin(halfangle))
% calculate the dest rotation

d = [dp; dr]
% the difference

syms theta positive % theta is thu
syms costheta sintheta real % these are sin and cos of theta
syms omega positive % omega is thv
syms cosomega sinomega real % these are sin and cos of omega
Ju = jacobian(d, u);
Jv = jacobian(d, v);

Ju = subs(Ju, (ua^2+ub^2+uc^2)^(1/2), theta);
Ju = subs(Ju, (va^2+vb^2+vc^2)^(1/2), omega);
Ju = subs(Ju, (ua^2+ub^2+uc^2), theta^2);
Ju = subs(Ju, (va^2+vb^2+vc^2), omega^2);
Ju = subs(Ju, cos(1/2*theta), costheta);
Ju = subs(Ju, sin(1/2*theta), sintheta);
Ju = subs(Ju, cos(1/2*omega), cosomega);
Ju = subs(Ju, sin(1/2*omega), sinomega);
%Ju = simplify(Ju);

Jv = subs(Jv, (ua^2+ub^2+uc^2)^(1/2), theta);
Jv = subs(Jv, (va^2+vb^2+vc^2)^(1/2), omega);
Jv = subs(Jv, (ua^2+ub^2+uc^2), theta^2);
Jv = subs(Jv, (va^2+vb^2+vc^2), omega^2);
Jv = subs(Jv, cos(1/2*theta), costheta);
Jv = subs(Jv, sin(1/2*theta), sintheta);
Jv = subs(Jv, cos(1/2*omega), cosomega);
Jv = subs(Jv, sin(1/2*omega), sinomega);
%Jv = simplify(Jv);

ccu = ccode(Ju);
ccv = ccode(Jv);

ccu = strrep(strrep(ccu, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
ccu = strrep(ccu, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
ccu = strrep(ccu, 'conjugate', '');
ccv = strrep(strrep(ccv, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
ccv = strrep(ccv, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
ccv = strrep(ccv, 'conjugate', '');

fid = fopen('MyJacobsU.h','w')
fwrite(fid, ccu, 'uchar');
fclose(fid)
fid = fopen('MyJacobsV.h','w')
fwrite(fid, ccv, 'uchar');
fclose(fid)

