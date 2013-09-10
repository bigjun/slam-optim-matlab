function JExpPlus=SumExpJacobiansSyms(vx, vy, vz, vR11, vR12, vR13, vR21, vR22, vR23, vR31, vR32, vR33)


%syms vx vy vz vR11 vR12 vR13 vR21 vR22 vR23 vR31 vR32 vR33 real % for
%debug
syms ex ey ez eR11 eR12 eR13 eR21 eR22 eR23 eR31 eR32 eR33 real

vR = [vR11 vR12 vR13; vR21 vR22 vR23; vR31 vR32 vR33];
vp = [vx vy vz]';

eR = [eR11 eR12 eR13; eR21 eR22 eR23; eR31 eR32 eR33];
ep = [ex ey ez]';
eT = [eR, ep];

% % in axis angle space 
% syms vx vy vz va1 va2 va3 real
% vp = [vx vy vz]';
% va = [va1 va2 va3]';
% vR = RotMat(va);
% % end axis angle space

vep = vp + vR * ep;
veR = vR * eR;

veT = [veR, vep];

Jve = jacobian(veT,eT); % the same as Jose Blanco

Je= ExpJacobiansSyms;

JExpPlus = Jve * Je;










