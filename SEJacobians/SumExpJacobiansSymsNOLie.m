function JExpPlus=SumExpJacobiansSymsNOLie(vx, vy, vz, vR11, vR12, vR13, vR21, vR22, vR23, vR31, vR32, vR33)

syms ex ey ez eR11 eR12 eR13 eR21 eR22 eR23 eR31 eR32 eR33 real

vR = [vR11 vR12 vR13; vR21 vR22 vR23; vR31 vR32 vR33];
vp = [vx vy vz]';

eR = [eR11 eR12 eR13; eR21 eR22 eR23; eR31 eR32 eR33];
ep = [ex ey ez]';
eT = [eR, ep];

vep = vp + vR * ep;  %TODO replace by R2AMatrix
veR = vR * eR;

veT = [veR, vep];

Jve = jacobian(veT,eT); % the same as Jose Blanco

Je= ExpJacobiansSyms;

JExpPlus = Jve * Je;










