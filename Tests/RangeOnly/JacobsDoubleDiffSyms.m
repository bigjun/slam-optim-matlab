syms  px py pz real
syms b1x b1y b1z b2x b2y b2z b3x b3y b3z b4x b4y b4z real

b1 = [b1x b1y b1z ]';
b2 = [b2x b2y b2z ]';
b3 = [b3x b3y b3z ]';
b4 = [b4x b4y b4z ]';
p = [px py pz]';
b = [b1,b2,b3,b4];

dd = AbsoluteBuoy2DD(p', b');
dd = simplify(dd);

DD_p = jacobian(dd,p);
 
size(DD_p)


DD_b = jacobian(dd,b);

size(DD_b)


% subst
syms rb1 rb2 rb3 rb4 real
syms vb1x vb1y vb1z vb2x vb2y vb2z vb3x vb3y vb3z vb4x vb4y vb4z real

DD_b = subs(DD_b,((b1x - px)^2 + (b1y - py)^2 + (b1z - pz)^2)^(1/2),rb1); 
DD_b = subs(DD_b,((b2x - px)^2 + (b2y - py)^2 + (b2z - pz)^2)^(1/2),rb2);
DD_b = subs(DD_b,((b3x - px)^2 + (b3y - py)^2 + (b3z - pz)^2)^(1/2),rb3);
DD_b = subs(DD_b,((b4x - px)^2 + (b4y - py)^2 + (b4z - pz)^2)^(1/2),rb4);

DD_p = subs(DD_p,((b1x - px)^2 + (b1y - py)^2 + (b1z - pz)^2)^(1/2),rb1); 
DD_p = subs(DD_p,((b2x - px)^2 + (b2y - py)^2 + (b2z - pz)^2)^(1/2),rb2);
DD_p = subs(DD_p,((b3x - px)^2 + (b3y - py)^2 + (b3z - pz)^2)^(1/2),rb3);
DD_p = subs(DD_p,((b4x - px)^2 + (b4y - py)^2 + (b4z - pz)^2)^(1/2),rb4);


DD_p = subs(DD_p,2*b1x - 2*px, 2*vb1x);
DD_p = subs(DD_p,2*b2x - 2*px, 2*vb2x);
DD_p = subs(DD_p,2*b3x - 2*px, 2*vb3x);
DD_p = subs(DD_p,2*b4x - 2*px, 2*vb4x);

DD_p = subs(DD_p,2*b1y - 2*py, 2*vb1y);
DD_p = subs(DD_p,2*b2y - 2*py, 2*vb2y);
DD_p = subs(DD_p,2*b3y - 2*py, 2*vb3y);
DD_p = subs(DD_p,2*b4y - 2*py, 2*vb4y);


DD_p = subs(DD_p,2*b1z - 2*pz, 2*vb1z);
DD_p = subs(DD_p,2*b2z - 2*pz, 2*vb2z);
DD_p = subs(DD_p,2*b3z - 2*pz, 2*vb3z);
DD_p = subs(DD_p,2*b4z - 2*pz, 2*vb4z);
