function test_LogExp
uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];

%% Rot

Tu = ExpSE3(uR);
au = LogSE3(Tu);
uR - au
Tv = ExpSE3(vR);

Ru = Tu(1:3,1:3);
Rv = Tv(1:3,1:3);
tu = Tu(1:3,4);
tv = Tv(1:3,4);

%A2R rotation
tdR = Ru'*(tv - tu); 
RdR = Ru'*Rv; 
TdR = [RdR tdR];
dR = LogSE3(TdR);

%% Using Rot and Arot
Ru1 = rot(uR(4:6));
Rv1 = rot(vR(4:6));
tu1 = uR(1:3);
tv1 = vR(1:3);
tdR1 = Ru1'*(tv1 - tu1); 
RdR1 = Ru1'*Rv1; 
dR1=[tdR1; arot(RdR1)];

%% evaluation

d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368];

dR-d_gt
% dR1-d_gt
% dR-dR1
