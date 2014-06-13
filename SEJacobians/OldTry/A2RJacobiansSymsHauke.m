
function [Ju , Jv] = A2RJacobiansSymsHauke

I6 = eye(6);
O33 = zeros(3,3);

syms xu yu zu a1u a2u a3u xv yv zv a1v a2v a3v real

ut = [xu yu zu]';
ua = [a1u a2u a3u]';
vt = [xv yv zv]'; 
va = [a1v a2v a3v]';

u=[ut; ua];
v=[vt; va];

[Ru, tu, Rv, tv]=RotMat(u,v);

td = Ru'*(tv - tu); 
Rd= Ru'*Rv; 
%Rd= Ru\Rv; 
[ a1d, a2d, a3d]= AxisVect(Rd);
xd = td(1);
yd = td(2);
zd = td(3);

dt=[xd yd zd]';
da=[a1d, a2d, a3d]';

Mu1 = [jacobian(-dt,ut) jacobian(-dt,ua); jacobian(-da,ut) jacobian(-da,ua)]


Mv1 = [jacobian(-dt,vt) jacobian(-dt,va); jacobian(-da,vt) jacobian(-da,va)]

%Mu= [-skew_symmetric([a1u a2u a3u]'),-skew_symmetric([xu yu zu]'); O33  -skew_symmetric([a1u a2u a3u]')];
%Mv= [ skew_symmetric([a1v a2v a3v]'), skew_symmetric([xv yv zv]'); O33   skew_symmetric([a1v a2v a3v]')];
%Md= [Rd, skew_symmetric(td)*Rd; O33, Rd];


Mu= [-skew_symmetric([a1d a2d a3d]'),-skew_symmetric([xd yd zd]'); O33  -skew_symmetric([a1d a2d a3d]')];

Mv= [ skew_symmetric([a1d a2d a3d]') ,skew_symmetric([xd yd zd]'); O33   skew_symmetric([a1d a2d a3d]')];


Ju= -(I6 + 1/2 * Mu + 1/12 * Mu^2); 
Jv= (I6+1/2*Mv+ 1/12 * Mv^2);


%Tests
uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
H1_gt = [ -0.983775 -0.179220  0.008222 0.000000 0.098524 0.138346;  0.179250 -0.983799  0.003059 -0.098524 0.000000 -0.229005;  -0.007541 -0.004484 -0.999962 -0.138346 0.229005 0.000000;  0.000000 0.000000 0.000000 -0.998943 -0.055681 0.008411;  -0.000000 -0.000000 -0.000000 0.055688 -0.998966 0.001141;  -0.000000 -0.000000 -0.000000 -0.008363 -0.001453 -0.999976]; % the first jacobian
H2_gt = [  0.983775  0.179220 -0.008222 0.000000 0.000000 0.000000; -0.179250  0.983799 -0.003059  0.000000 0.000000  0.000000;   0.007541 0.004484 0.999962 0.000000 0.000000 0.000000;  0.000000 0.000000 0.000000 0.998943 -0.055688 0.008363;  -0.000000 -0.000000 -0.000000 0.055681 0.998966 0.001453;  0.000000 0.000000 0.000000 -0.008411 -0.001141 0.999976];
%[Ru, tu, Rv, tv]=RotMat(uR,vR);

JuR= eval(subs(Ju,{xu yu zu a1u a2u a3u xv yv zv a1v a2v a3v}, {uR(1) uR(2) uR(3) uR(2) uR(5) uR(6) vR(1) vR(2)  vR(3) vR(2) vR(5) vR(6)}))
JvR= eval(subs(Jv,{xu yu zu a1u a2u a3u xv yv zv a1v a2v a3v}, {uR(1) uR(2) uR(3) uR(2) uR(5) uR(6) vR(1) vR(2)  vR(3) vR(2) vR(5) vR(6)}))


Diff1=JuR-H1_gt
Diff2=JvR-H2_gt

norm(Diff1)
norm(Diff2)
