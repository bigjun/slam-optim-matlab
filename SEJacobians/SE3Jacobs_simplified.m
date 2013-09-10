clear


syms vex vey vez vea veb vec real
vep = [vex vey vez]';
ver = [vea veb vec]';
ve = [vep; ver];

thve = sqrt(ver' * ver);
qve = [cos(thve / 2); ver * (sin(thve / 2) / thve)];
qvec = [qve(1); -qve(2); -qve(3); -qve(4)];

syms ux uy uz ua ub uc real
up = [ux uy uz]';
ur = [ua ub uc]';
size(qvec)
qvec*(vep-up)


Jve=simple(jacobian(qvec,ver));
syms co si no real
Jve = subs(Jve, cos((vea^2 + veb^2 + vec^2)^(1/2)/2), co);
Jve = subs(Jve, sin((vea^2 + veb^2 + vec^2)^(1/2)/2), si);
Jve = subs(Jve, (vea^2 + veb^2 + vec^2)^(1/2), no);



size(Jve)


% u = [up; ur];
% thu = sqrt(ur' * ur);
% qu = [cos(thu / 2); ur * (sin(thu / 2) / thu)];
% 
% 
% quc = [qu(1); -qu(2); -qu(3); -qu(4)];
% 
% cve = simple(cross(quc(2:4), (vep - up)));
% dve = simple(2 * quc(1) * cve + (vep - up + cross(quc(2:4), 2 * cve))); % yields correct results, no bug so far?
% 
% Jve = jacobian(dve, qve)
% qve


% 
% syms ex ey ez ea eb ec real
% syms vx vy vz va vb vc real
% syms fixup positive
% % real scalar inputs
% 
% syms u v e up vp ep ur vr er real
% 
% 
% vp = [vx vy vz]'
% vr = [va vb vc]'
% ep = [ex ey ez]'
% er = [ea eb ec]'
% 
% v = [vp; vr]
% e = [ep; er]
% % inputs as vectors
% 
% %syms dx dy dz da db dc real % not required, outputs are vectors
% syms qu quc real
% syms thu positive
% syms qv real
% syms thv the positive
% syms qdd qe qd c qve real
% % intermediates
% 
% syms halfangle fullangle d dp dr real
% % outputs as vectors
% 
% 
% thv = sqrt(vr' * vr)
% the = sqrt(er' * er)
% 
% qv = [cos(thv / 2); vr * (sin(thv / 2) / thv)]
% qe = [cos(the / 2); er * (sin(the / 2) / the)]
% 
% qve = [
%     qv(1) * qe(1) - qv(2) * qe(2) - qv(3) * qe(3) - qv(4) * qe(4);
%     qv(1) * qe(2) + qv(2) * qe(1) + qv(3) * qe(4) - qv(4) * qe(3);
%     qv(1) * qe(3) + qv(3) * qe(1) + qv(4) * qe(2) - qv(2) * qe(4);
%     qv(1) * qe(4) + qv(4) * qe(1) + qv(2) * qe(3) - qv(3) * qe(2)]; % i don't have the quaternion toolbox
% % qv * qe
% 
% ver 
% 
% quc = [qu(1); -qu(2); -qu(3); -qu(4)]
% % qu^-1
% 
% c = simple(cross(quc(2:4), (vp + ep) - up))
% dp = simple(2 * quc(1) * c + (vp + ep) - up + cross(quc(2:4), 2 * c)) % yields correct results, no bug so far?
% % transform (vp + ep) - up by rotation qu^-1
% 
% qd = [
%     quc(1) * qve(1) - quc(2) * qve(2) - quc(3) * qve(3) - quc(4) * qve(4);
%     quc(1) * qve(2) + quc(2) * qve(1) + quc(3) * qve(4) - quc(4) * qve(3);
%     quc(1) * qve(3) + quc(3) * qve(1) + quc(4) * qve(2) - quc(2) * qve(4);
%     quc(1) * qve(4) + quc(4) * qve(1) + quc(2) * qve(3) - quc(3) * qve(2)]; % i don't have the quaternion toolbox
% % final rotation qu^-1 * (qv * qe)
% 
% halfangle = acos(qd(1))
% fullangle = 2 * halfangle
% %dr = simple(qd(2:4) * (fullangle / sin(halfangle)))
% dr = qd(2:4) * (fullangle / sin(halfangle)) % not simple ... takes far too much time
% % calculate the dest rotation as axis-angle
% 
% d = [dp; dr]
% % the difference
% 
% %syms theta positive % theta is thu
% %syms costheta sintheta real % these are sin and cos of theta
% %syms omega positive % omega is thv
% %syms cosomega sinomega real % these are sin and cos of omega
% Jv = jacobian(d, e); % not wrt to u but to e (and e is set to 0)
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
% %ccu = ccode(Ju);
% ccv = ccode(Jv);
% 
% %ccu = strrep(strrep(ccu, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
% %ccu = strrep(ccu, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
% %ccu = strrep(ccu, 'conjugate', '');
% ccv = strrep(strrep(ccv, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
% ccv = strrep(ccv, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
% %ccv = strrep(ccv, 'conjugate', '');
% 
% %fid = fopen('MyJacobsU_minus2.h','w')
% %fwrite(fid, ccu, 'uchar');
% %fclose(fid)
% fid = fopen('MyJacobsV_minus2.h','w')
% fwrite(fid, ccv, 'uchar');
% fclose(fid)
% 
