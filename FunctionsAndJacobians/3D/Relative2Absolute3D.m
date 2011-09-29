function p2 = Relative2Absolute3D(p1,d)
% returns the absolute position of p2 which at distance d from
% p1( in absolute)
ps1.pose=p1(1:3);
ps1.ypr=p1(4:6);
ps1.Q=ypr2R(ps1.ypr(1),ps1.ypr(2),ps1.ypr(3));
ds.pose=d(1:3); % TODO This must depend on factorR.
ds.q=d(4:7);

ps2.pose = ps1.pose + ds.pose;
ps2.Q = ps1.Q * rot(ps1.Q \ ds.q(1:3)); %d(4:6)) WHAT IS THIS???

p2=[ps2.pose;R2ypr(ps2.Q)];


