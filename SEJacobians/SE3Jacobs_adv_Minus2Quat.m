

clear

syms ux uy uz ua ub uc real
syms ex ey ez ea eb ec real
syms vx vy vz va vb vc real
syms fixup positive
% real scalar inputs

syms u v e up vp ep ur vr er real
up = [ux uy uz]';
ur = [ua ub uc]';
vp = [vx vy vz]';
vr = [va vb vc]';
ep = [ex ey ez]';
er = [ea eb ec]';
u = [up; ur];
v = [vp; vr];
e = [ep; er];
% inputs as vectors
syms qu quc qv qe vep qve dvr dvp dv real
qu = a2q(ur);
quc = quatconj(qu')';
qv = a2q(vr);
qe = a2q(er);

vep = quat2matrix(qv) * (vp + ep);
qve = quatmultiply(qv', qe')';
% calculate v + e

dvr = quatmultiply(quc', qve')';
dvp = quat2matrix(quc) * (vep - up);

dv = [dvp; q2a(dvr)];

 Jv = jacobian(dv,e);
 uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
 vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
 H1_gt = [ -0.983775 -0.179220 0.008222 0.000000 0.098524 0.138346;  0.179250 -0.983799 0.003059 -0.098524 0.000000 -0.229005;  -0.007541 -0.004484 -0.999962 -0.138346 0.229005 0.000000;  0.000000 0.000000 0.000000 -0.998943 -0.055681 0.008411;  -0.000000 -0.000000 -0.000000 0.055688 -0.998966 0.001141;  -0.000000 -0.000000 -0.000000 -0.008363 -0.001453 -0.999976]; % the first jacobian
 H2_gt = [ 0.983775 0.179220 -0.008222 0.000000 0.000000 0.000000;  -0.179250 0.983799 -0.003059 0.000000 0.000000 0.000000;  0.007541 0.004484 0.999962 0.000000 0.000000 0.000000;  0.000000 0.000000 0.000000 0.998943 -0.055688 0.008363;  -0.000000 -0.000000 -0.000000 0.055681 0.998966 0.001453;  0.000000 0.000000 0.000000 -0.008411 -0.001141 0.999976]; 
 d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368]
% 
% 
% Ru=rot(uR(4:6));
% Rv=rot(vR(4:6));
% tu = uR(1:3);
% tv = vR(1:3);
% 
 dv_num = eval(subs(dv,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)})); 
 dv_diff = dv_num - d_gt
% 

% Tdu = inv(Tu* Te)* Tv ;
% 
% dur = ArotMat(Tdu(1,1), Tdu(1,2), Tdu(1,3), Tdu(2,1), Tdu(2,2), Tdu(2,3), Tdu(3,1), Tdu(3,2), Tdu(3,3));
% dup = [Tdu(1,4), Tdu(2,4), Tdu(3,4)];
% du = [dup dur'];
% 
% Ju11 = jacobian(dup,ep);
% Ju12 = jacobian(dup,er);
% Ju21 = jacobian(dur,ep);
% Ju22 = jacobian(dur,er);
% 
% Ju = [Ju11 Ju12; Ju21 Ju22];
% 
% ccu = ccode(Ju);
% ccv = ccode(Jv);
% 
% ccu = strrep(strrep(ccu, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
% ccu = strrep(ccu, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
% %ccu = strrep(ccu, 'conjugate', '');
% ccv = strrep(strrep(ccv, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
% ccv = strrep(ccv, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
% %ccv = strrep(ccv, 'conjugate', '');
% 
% fid = fopen('MyJacobsU_minus2.h','w')
% fwrite(fid, ccu, 'uchar');
% fclose(fid)
% fid = fopen('MyJacobsV_minus2.h','w')
% fwrite(fid, ccv, 'uchar');
% fclose(fid)

