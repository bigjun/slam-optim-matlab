syms bx by bz px py pz real
syms bx by bz px py pz real
syms bc real
b = [bx by bz ]';
p = [px py pz]';

% %absolute 2 relative
% v = p-b;  
% %d = norm(v)
% d = sqrt(v'*v);
% 
% jvp = jacobian(v,p)
% jvb = jacobian(v,b)
% 
% jdp = jacobian(d,p);
% jdb = jacobian(d,b);
% 
% syms rb vx vy vz
% 
% a= ((abs(px - bx)^2 + abs(px - bx)^2 + abs(px - bx)^2)^(1/2) );
% 
% diff = a-d
% 
% jdp = subs(jdp,((bx - px)^2 + (by - py)^2 + (bz - pz)^2)^(1/2),rb)
% jdb = subs(jdb,((bx - px)^2 + (by - py)^2 + (bz - pz)^2)^(1/2),rb) 
% 
% jdp = subs(jdp,(bx - px),vx);
% jdp = subs(jdp,(bx - px),vy);
% jdp = subs(jdp,(bx - px),vz)
% 
% jdb = subs(jdb,(bx - px),vx);
% jdb = subs(jdb,(bx - px),vy);
% jdb = subs(jdb,(bx - px),vz)




% pseudo range
% v = b-p;
% pr = sqrt(v'*v) + bc;


pr = AbsoluteBuoy2PR(p',b',bc) ;

PR_p = jacobian(pr,p);
PR_b = jacobian(pr,b);
PR_bc = jacobian(pr,bc) % = 1


syms rb vx vy vz

% PR_p = subs(PR_p,((bx - px)^2 + (by - py)^2 + (bz - pz)^2)^(1/2),rb);
% PR_b = subs(PR_b,((bx - px)^2 + (by - py)^2 + (bz - pz)^2)^(1/2),rb); 

PR_p = subs(PR_p,((px - bx)^2 + (py - by)^2 + (pz - bz)^2)^(1/2),rb);
PR_b = subs(PR_b,((px - bx)^2 + (py - by)^2 + (pz - bz)^2)^(1/2),rb); 



PR_p = subs(PR_p,(bx - px),vx);
PR_p = subs(PR_p,(by - py),vy);
PR_p = subs(PR_p,(bz - pz),vz)

PR_b = subs(PR_b,(bx - px),vx);
PR_b = subs(PR_b,(by - py),vy);
PR_b = subs(PR_b,(bz - pz),vz)



