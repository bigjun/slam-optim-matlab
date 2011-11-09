function p2 = Relative2Absolute3D(p1,d)
% returns the absolute position of p2 which at distance d from
% p1( in absolute)
ps1.pose=p1(1:3);
ps1.Q=rot(p1(4:6));
ds.pose=d(1:3); % TODO This must depend on factorR.
ds.Q=rot(d(4:6));

ps2.pose = ps1.pose + ps1.Q*ds.pose;
ps2.q = arot(ps1.Q *ds.Q); 

p2=[ps2.pose;ps2.q];


