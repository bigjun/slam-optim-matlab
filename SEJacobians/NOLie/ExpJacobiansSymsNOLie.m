function Je = ExpJacobiansSymsNOLie

syms xe ye ze a1e a2e a3e real

pe = [xe ye ze]';
re = [a1e a2e a3e]';

te = pe;  %TODO is it correct?!!!!!
Re=RotMat(re);

Te = [Re te];
e = [pe ; re];

Je = jacobian(Te, e);
Je = limit(Je,xe,0);
Je = limit(Je,ye,0);
Je = limit(Je,ze,0);
Je = limit(Je,a1e,0);
Je = limit(Je,a2e,0);
Je = limit(Je,a3e,0);









