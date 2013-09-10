function result=testSymbJacobian(Ju)

%syms ux uy uz ua ub uc real % reference pose
%syms vx vy vz va vb vc real
%syms dx dy dz da db dc real % relative pose

% real scalar inputs

uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
I3 = eye(3);

% %u
% up = [ux uy uz]';
% ur = [ua ub uc]';
% %v
% vp = [vx vy vz]';
% vr = [va vb vc]';


up = uR(1:3);
ur = uR(4:6);
%v
vp = vR(1:3);
vr = vR(4:6);

u = [up; ur];
v = [vp; vr];
% inputs as vectors


thu = sqrt(ur' * ur);
thv = sqrt(vr' * vr);

cu=cos(thu);
su=sin(thu);

cv=cos(thv);
sv=sin(thv);
% 
%
% 
%urx=[0 -uc ub; uc 0 -ua; -ub ua 0];
urx=skew_symmetric(ur)
urx2=urx*urx^2;
%vrx=[0 -vc vb; vc 0 -va; -vb va 0];
vrx=skew_symmetric(vr)
vrx2=vrx*vrx^2;

% % exp_map = rot = Rodriguez for the rotations 
tu = up;
Ru = I3 * cu + urx * su + (1 - cu) * (urx2 - I3);
tv = vp;
Rv = I3 * cv + vrx * sv + (1 - cv) * (vrx2 - I3);


% Real values from numeric approximation


%Ru = subs(Ru, [ux uy uz ua ub uc], uR');
% % Ru = subs(Ru, uy, uR(2));
% % Ru = subs(Ru, uz, uR(3));
% % Ru = subs(Ru, ua, uR(4));
% % Ru = subs(Ru, ub, uR(5));
% % Ru = subs(Ru, uc, uR(6));
% 
% Rv = subs(Rv, vx, vR(1));
% Rv = subs(Rv, vy, vR(2));
% Rv = subs(Rv, vz, vR(3));
% Rv = subs(Rv, va, vR(4));
% Rv = subs(Rv, vb, vR(5));
% Rv = subs(Rv, vc, vR(6));



Ju = subs(Ju, ru11, Ru(1,1)); 
Ju = subs(Ju, ru12, Ru(1,2)); 
Ju = subs(Ju, ru13, Ru(1,3)); 
Ju = subs(Ju, ru21, Ru(2,1)); 
Ju = subs(Ju, ru22, Ru(2,2)); 
Ju = subs(Ju, ru23, Ru(2,3)); 
Ju = subs(Ju, ru31, Ru(3,1)); 
Ju = subs(Ju, ru32, Ru(3,2));
Ju = subs(Ju, ru33, Ru(3,3));
Ju = subs(Ju, tux, tu(1,1)); 
Ju = subs(Ju, tuy, tu(2,1)); 
Ju = subs(Ju, tuz, tu(3,1));

% Jv = subs(Jv, rv11, Rv(1,1)); 
% Jv = subs(Jv, rv12, Rv(1,2)); 
% Jv = subs(Jv, rv13, Rv(1,3)); 
% Jv = subs(Jv, rv21, Rv(2,1)); 
% Jv = subs(Jv, rv22, Rv(2,2)); 
% Jv = subs(Jv, rv23, Rv(2,3)); 
% Jv = subs(Jv, rv31, Rv(3,1)); 
% Jv = subs(Jv, rv32, Rv(3,2));
% Jv = subs(Jv, rv33, Rv(3,3));
% Jv = subs(Jv, tvx, tv(1,1)); 
% Jv = subs(Jv, tvy, tv(2,1)); 
% Jv = subs(Jv, tvz, tv(3,1));

Ju

H1_gt = [ -0.983775 -0.179220 0.008222 0.000000 0.098524 0.138346;  0.179250 -0.983799 0.003059 -0.098524 0.000000 -0.229005;  -0.007541 -0.004484 -0.999962 -0.138346 0.229005 0.000000;  0.000000 0.000000 0.000000 -0.998943 -0.055681 0.008411;  -0.000000 -0.000000 -0.000000 0.055688 -0.998966 0.001141;  -0.000000 -0.000000 -0.000000 -0.008363 -0.001453 -0.999976]; % the first jacobian


%Ju-H1_gt




