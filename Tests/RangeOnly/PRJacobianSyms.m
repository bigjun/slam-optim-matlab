function PRJacobianSyms
%calculates the Jacobian of the pseudo range residual

syms bx by bz px py pz real
syms bx by bz px py pz real
syms bc pr real
b = [bx by bz ]';
p = [px py pz]';


v = p-b;
h = sqrt(v'*v)-bc - pr; %observation function

syms rb vx vy vz real
Jp = simplify(jacobian(h,p)) ;

Jp = subs(Jp,((px - bx)^2 + (py - by)^2 + (pz - bz)^2)^(1/2),rb);


Jp = subs(Jp,(px - bx),vx);
Jp = subs(Jp,(py - by),vy);
Jp = subs(Jp,(pz - bz),vz)


Jbc = jacobian(h,bc)



syms bc pr real
fpr = d - bc -pr;

Jp = jacobian(fpr,p);
Jp = subs(Jp,((bx - px)^2 + (by - py)^2 + (bz - pz)^2)^(1/2),rb);
Jp = subs(Jp,(px - bx),vx);
Jp = subs(Jp,(py - by),vy);
Jp = subs(Jp,(pz - bz),vz)




Jbc = jacobian(fpr,bc)