function test_RotArot
uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
Ru=RotMat(uR(4:6)) %WRONG!!!
Qu = rot(uR(4:6))
Rv=RotMat(vR(4:6))%WRONG!!!
Qv = rot(vR(4:6))

tu = uR(1:3);
tv = vR(1:3);

tdR = Ru'*(tv - tu); 
RdR= Ru'*Rv;


 cd = (trace(RdR)-1)/2;
 sd = sqrt(1 - cd^2);
 angle = acos(cd);
 b=angle/(2*sd);
 DR=[RdR(3,2) - RdR(2,3); RdR(1,3) - RdR(3,1); RdR(2,1) - RdR(1,2)]* ((angle*cd-sd)/(4*sd^3))
 
 

dR = arot (RdR)
d=[tdR; dR]

d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368]
% difference between u and v

