function d = smartMinus(p1,p2)
% Implements p2-p1 on manifold
% both, p1,p2 are in absolute
ps1.pose=p1(1:3);
ps2.pose=p2(1:3);
ps1.Q=rot(p1(4:6));
ps2.Q=rot(p2(4:6));

ds.pose = ps2.pose - ps1.pose; 
%ds.axis = ps1.Q * arot(ps1.Q \ ps2.Q); 
ds.axis = arot(ps1.Q \ ps2.Q); % it seems that p1.Q is multiplied by p1_Q_inv 

d=[ds.pose;ds.axis];


