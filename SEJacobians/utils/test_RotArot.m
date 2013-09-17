function test_RotArot
uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
eR = [10^(-15); 10^(-15); 10^(-15); 10^(-15); 10^(-15); 10^(-15)]

tu = uR(1:3);
tv = vR(1:3);
te = eR(1:3);

%% Rot

Ru=RotMat(uR(4:6));
Rv=RotMat(vR(4:6));

%A2R rotation
tdR = Ru'*(tv - tu); 
RdR = Ru'*Rv; 
dR=[tdR; arot(RdR)]

%% quat


qu = a2q(uR(4:6));
qv = a2q(vR(4:6));
qe = a2q(eR(4:6));


%A2R quats

tdq = (q2R(quatconj(qu')') * (tv - tu));
Rdq = quatmultiply(quatconj(qu'),qv')';
dq = [tdq;q2a(Rdq)]


%% using e
vep = tv + q2R(qv) *  te; 
qve = quatmultiply(qv', qe')';

quc = quatconj(qu')';
dvp = q2R(quc) * (vep - tu);
dvr = quatmultiply(quc', qve')';

dv = [dvp; q2a(dvr)]

%% other quats

%tdq = quatrotate(quatconj(qu'),(tv - tu)')'; % dont use, does something
%else

% quc = quatconj(qu')';
% qve = qv;
% qprod = [
%     quc(1) * qve(1) - quc(2) * qve(2) - quc(3) * qve(3) - quc(4) * qve(4);
%     quc(1) * qve(2) + quc(2) * qve(1) + quc(3) * qve(4) - quc(4) * qve(3);
%     quc(1) * qve(3) + quc(3) * qve(1) + quc(4) * qve(2) - quc(2) * qve(4);
%     quc(1) * qve(4) + quc(4) * qve(1) + quc(2) * qve(3) - quc(3) * qve(2)]; % i don't have the quaternion toolbox
% qproddiff = qprod - Rdq
% 
% c = cross(quc(2:4), tv - tu);
% qrotation = 2 * quc(1) * c + tv - tu + cross(quc(2:4), 2 * c); % yields correct results, no bug so far?
% % transform tv - tu by rotation qu^-1
% qrotationdiff = qrotation - tdq
% 
% qrotation2 = q2R(quc) * (tv - tu); 
% qrotation2diff = qrotation2 - tdq
% 
% qrotation3 = q2R([quc(2:4); quc(1)]) * (tv - tu); 
% qrotation3diff = qrotation3 - tdq



%% evaluation

d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368]

dR-d_gt
dq-d_gt
dv-d_gt

% 
% Rdq_gt = a2q(d_gt(4:6));
% Rdq- Rdq_gt
% tdq- d_gt(1:3)
% 
% %R2A quats
% vp = tu'+ quatrotate(qu',d_gt(1:3)')
% %vp-tv'
% vr = quatmultiply(qu', Rdq_gt')
% %vr-qv'

% difference between u and v

