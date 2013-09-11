clear

syms ux uy uz ua ub uc real
syms ex ey ez ea eb ec real
syms vx vy vz va vb vc real
syms fixup positive
% real scalar inputs

syms u v e up vp ep ur vr er real
up = [ux uy uz]'
ur = [ua ub uc]'
vp = [vx vy vz]'
vr = [va vb vc]'
ep = [ex ey ez]'
er = [ea eb ec]'
u = [up; ur]
v = [vp; vr]
e = [ep; er]
% inputs as vectors

%syms dx dy dz da db dc real % not required, outputs are vectors
syms qu quc real
syms thu positive
syms qv real
syms thv the positive
syms qdd qe qd c que real
% intermediates

syms halfangle fullangle d dp dr real
% outputs as vectors

thu = sqrt(ur' * ur)
thv = sqrt(vr' * vr)
the = sqrt(er' * er)
qu = [cos(thu / 2); ur * (sin(thu / 2) / thu)]
qv = [cos(thv / 2); vr * (sin(thv / 2) / thv)]
qe = [cos(the / 2); er * (sin(the / 2) / the)]

que = [
    qu(1) * qe(1) - qu(2) * qe(2) - qu(3) * qe(3) - qu(4) * qe(4);
    qu(1) * qe(2) + qu(2) * qe(1) + qu(3) * qe(4) - qu(4) * qe(3);
    qu(1) * qe(3) + qu(3) * qe(1) + qu(4) * qe(2) - qu(2) * qe(4);
    qu(1) * qe(4) + qu(4) * qe(1) + qu(2) * qe(3) - qu(3) * qe(2)]; % i don't have the quaternion toolbox
% qu * qe

quc = [que(1); -que(2); -que(3); -que(4)];
% (qu * qe)^-1

%c = simple(cross(quc(2:4), vp - (up + ep)))
%dp = simple(2 * quc(1) * c + vp - (up + ep) + cross(quc(2:4), 2 * c)) % yields correct results, no bug so far?
c = (cross(quc(2:4), vp - (up + ep)))
dp = (2 * quc(1) * c + vp - (up + ep) + cross(quc(2:4), 2 * c)) % yields correct results, no bug so far?
% transform vp - (up + ep) by rotation (qu * qe)^-1

qd = [
    quc(1) * qv(1) - quc(2) * qv(2) - quc(3) * qv(3) - quc(4) * qv(4);
    quc(1) * qv(2) + quc(2) * qv(1) + quc(3) * qv(4) - quc(4) * qv(3);
    quc(1) * qv(3) + quc(3) * qv(1) + quc(4) * qv(2) - quc(2) * qv(4);
    quc(1) * qv(4) + quc(4) * qv(1) + quc(2) * qv(3) - quc(3) * qv(2)]; % i don't have the quaternion toolbox
% final rotation (qu * qe)^-1 * qv

halfangle = acos(qd(1))
fullangle = 2 * halfangle
%dr = simple(qd(2:4) * (fullangle / sin(halfangle)))
dr = qd(2:4) * (fullangle / sin(halfangle)) % not simple ... takes far too much time
% calculate the dest rotation as axis-angle

d = [dp; dr]
% the difference

%%

% ground truth
uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
H1_gt = [ -0.983775 -0.179220 0.008222 0.000000 0.098524 0.138346;  0.179250 -0.983799 0.003059 -0.098524 0.000000 -0.229005;  -0.007541 -0.004484 -0.999962 -0.138346 0.229005 0.000000;  0.000000 0.000000 0.000000 -0.998943 -0.055681 0.008411;  -0.000000 -0.000000 -0.000000 0.055688 -0.998966 0.001141;  -0.000000 -0.000000 -0.000000 -0.008363 -0.001453 -0.999976]; % the first jacobian
H2_gt = [ 0.983775 0.179220 -0.008222 0.000000 0.000000 0.000000;  -0.179250 0.983799 -0.003059 0.000000 0.000000 0.000000;  0.007541 0.004484 0.999962 0.000000 0.000000 0.000000;  0.000000 0.000000 0.000000 0.998943 -0.055688 0.008363;  -0.000000 -0.000000 -0.000000 0.055681 0.998966 0.001453;  0.000000 0.000000 0.000000 -0.008411 -0.001141 0.999976];
d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368]

d_num = eval(subs(d,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)}));
quc_num = eval(subs(quc,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)}))

d_diff = d_num - d_gt

%%

% %syms theta positive % theta is thu
% %syms costheta sintheta real % these are sin and cos of theta
% %syms omega positive % omega is thv
% %syms cosomega sinomega real % these are sin and cos of omega
% Ju = jacobian(d, e); % not wrt to u but to e (and e is set to 0)
% %Jv = jacobian(d, v);
% 
% %Ju = subs(Ju, (ua^2+ub^2+uc^2)^(1/2), theta);
% %Ju = subs(Ju, (va^2+vb^2+vc^2)^(1/2), omega);
% %Ju = subs(Ju, (ua^2+ub^2+uc^2), theta^2);
% %Ju = subs(Ju, (va^2+vb^2+vc^2), omega^2);
% %Ju = subs(Ju, cos(1/2*theta), costheta);
% %Ju = subs(Ju, sin(1/2*theta), sintheta);
% %Ju = subs(Ju, cos(1/2*omega), cosomega);
% %Ju = subs(Ju, sin(1/2*omega), sinomega);
% %Ju = simple(Ju)
% 
% %Jv = subs(Jv, (ua^2+ub^2+uc^2)^(1/2), theta);
% %Jv = subs(Jv, (va^2+vb^2+vc^2)^(1/2), omega);
% %Jv = subs(Jv, (ua^2+ub^2+uc^2), theta^2);
% %Jv = subs(Jv, (va^2+vb^2+vc^2), omega^2);
% %Jv = subs(Jv, cos(1/2*theta), costheta);
% %Jv = subs(Jv, sin(1/2*theta), sintheta);
% %Jv = subs(Jv, cos(1/2*omega), cosomega);
% %Jv = subs(Jv, sin(1/2*omega), sinomega);
% %Jv = simple(Jv)
% 
% ccu = ccode(Ju);
% %ccv = ccode(Jv);
% 
% ccu = strrep(strrep(ccu, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
% ccu = strrep(ccu, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
% %ccu = strrep(ccu, 'conjugate', '');
% %ccv = strrep(strrep(ccv, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
% %ccv = strrep(ccv, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
% %ccv = strrep(ccv, 'conjugate', '');
% 
% fid = fopen('MyJacobsU_minus2.h','w')
% fwrite(fid, ccu, 'uchar');
% fclose(fid)
% %fid = fopen('MyJacobsV_minus.h','w')
% %fwrite(fid, ccv, 'uchar');
% %fclose(fid)
% 
