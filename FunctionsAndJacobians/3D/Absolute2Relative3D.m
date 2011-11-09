function d = Absolute2Relative3D(p1,p2)
% returns the relative position of p2 with respect to p1
% both, p1,p2 are in absolute
ps1.pose=p1(1:3);
ps2.pose=p2(1:3);
ps1.Q=rot(p1(4:6));
ps2.Q=rot(p2(4:6));

ps1_Q_inv = inv(ps1.Q);
ds.pose = ps1_Q_inv *(ps2.pose - ps1.pose); % it seems that I have to multiply by that
%ds.axis = ps1.Q * arot(ps1.Q \ ps2.Q); % it seems that p1.Q is multiplied by p1_Q_inv 
ds.axis = arot(ps1.Q \ ps2.Q); % it seems that p1.Q is multiplied by p1_Q_inv 

d=[ds.pose;ds.axis];


