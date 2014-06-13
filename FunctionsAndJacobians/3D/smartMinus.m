function d = smartMinus(p1,p2)
% Implements p2-p1 on manifold
% both, p1,p2 are in absolute 
% the same as A2R
ps1.pose=p1(1:3);
ps2.pose=p2(1:3);
ps1.Q=rot(p1(4:6));
ps2.Q=rot(p2(4:6));

inv_ps1.Q = inv (ps1.Q);
ds.pose = inv_ps1.Q * (ps2.pose - ps1.pose);
ds.axis = arot(inv_ps1.Q * ps2.Q);
d=[ds.pose;ds.axis];


