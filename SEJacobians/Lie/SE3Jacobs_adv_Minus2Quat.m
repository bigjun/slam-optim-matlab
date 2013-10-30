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
syms qu quc qv qe vep qve dvr dvp dv uep que dur dup du real
qu = a2qSyms(ur);
qv = a2qSyms(vr);
qe = a2qSyms(er);

%%
% (v + e) - u 

vep = vp + q2R(qv) * ep; % unused? why?
qve = quatmultiply(qv', qe')';

%  ve - u 
 
quc = quatconj(qu')';
dvp = q2R(quc) * (vep - up);
%dvp = q2R(quc) * ((vp + ep) - up);
dvr = quatmultiply(quc', qve')';

dv = [dvp; q2aSyms(dvr)];

Jv = jacobian(dv, e);

%%
% v - (u + e)  

uep = up + q2R(qu) *  ep; % unused? why?
que = quatmultiply(qu', qe')';
quec = quatconj(que')';

%  v - ue

dur = quatmultiply(quec', qv')';
dup = q2R(quec) * (vp - uep);
%dup = q2R(quec) * (vp - (up + ep));

du = [dup; q2aSyms(dur)];

Ju = jacobian(du, e);

%%

% ground truth
% smart plus bug
% uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
% vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
% H1_gt = [ -0.983775 -0.179220 0.008222 0.000000 0.098524 0.138346;  0.179250 -0.983799 0.003059 -0.098524 0.000000 -0.229005;  -0.007541 -0.004484 -0.999962 -0.138346 0.229005 0.000000;  0.000000 0.000000 0.000000 -0.998943 -0.055681 0.008411;  -0.000000 -0.000000 -0.000000 0.055688 -0.998966 0.001141;  -0.000000 -0.000000 -0.000000 -0.008363 -0.001453 -0.999976]; % the first jacobian
% H2_gt = [ 0.983775 0.179220 -0.008222 0.000000 0.000000 0.000000;  -0.179250 0.983799 -0.003059 0.000000 0.000000 0.000000;  0.007541 0.004484 0.999962 0.000000 0.000000 0.000000;  0.000000 0.000000 0.000000 0.998943 -0.055688 0.008363;  -0.000000 -0.000000 -0.000000 0.055681 0.998966 0.001453;  0.000000 0.000000 0.000000 -0.008411 -0.001141 0.999976];
% d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368]

uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368]; % difference between u and v
H1_gt = [ -1.000000 -0.000000 0.000000 0.000000 0.098524 0.138346;  0.000000 -1.000000 0.000000 -0.098524 0.000000 -0.229005;  0.000000 0.000000 -1.000000 -0.138346 0.229005 0.000000;  0.000000 0.000000 0.000000 -0.998943 -0.055681 0.008411;  -0.000000 -0.000000 -0.000000 0.055688 -0.998966 0.001141;  -0.000000 -0.000000 -0.000000 -0.008363 -0.001453 -0.999976]; % the first jacobian
H2_gt = [ 0.993665 -0.111155 0.016594 0.000000 0.000000 0.000000;  0.111111 0.993802 0.003521 0.000000 0.000000 0.000000;  -0.016883 -0.001655 0.999856 0.000000 0.000000 0.000000;  0.000000 0.000000 0.000000 0.998943 -0.055688 0.008363;  -0.000000 -0.000000 -0.000000 0.055681 0.998966 0.001453;  0.000000 0.000000 0.000000 -0.008411 -0.001141 0.999976]; % the second jacobian

Ru=rot(uR(4:6));
Rv=rot(vR(4:6));
tu = uR(1:3);
tv = vR(1:3);



%%
% % evaluations
Jv_eval = eval(subs(Jv,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)}));

dv_num = eval(subs(dv,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)}));


Ju_eval = eval(subs(Ju,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)}));

du_num = eval(subs(du,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)}));
%quec_num = eval(subs(quec,{ux, uy, uz, ua, ub, uc, vx, vy, vz, va, vb, vc, ex, ey, ez, ea, eb, ec}, {uR(1),uR(2),uR(3),uR(4),uR(5),uR(6),vR(1),vR(2),vR(3),vR(4),vR(5),vR(6), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15), 10^(-15)}))

%%
% diffs
dv_diff = dv_num - d_gt
Jv_diff = Jv_eval - H2_gt

du_diff = du_num - d_gt
Ju_diff = Ju_eval - H1_gt

dudv_diff = dv_num - du_num 
 
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

