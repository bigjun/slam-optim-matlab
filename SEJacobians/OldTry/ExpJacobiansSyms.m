function Je = ExpJacobiansSyms

syms xe ye ze a1e a2e a3e real

pe = [xe ye ze]';
re = [a1e a2e a3e]';

te = pe;
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


% Te = limit(Te,xe,0);
% Te = limit(Te,ye,0);
% Te = limit(Te,ze,0);
% Te = limit(Te,a1e,0);
% Te = limit(Te,a2e,0);
% Te = limit(Te,a3e,0)









