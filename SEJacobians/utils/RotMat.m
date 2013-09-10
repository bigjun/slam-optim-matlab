function Rd=RotMat(rd)

% exp_map = rot = Rordiguez for the rotations 
    
I3 = eye(3);
thd = sqrt(rd' * rd);
rd=rd/thd;
co=cos(thd);
si=sin(thd);
rx=skew_symmetric(rd);
Rd = I3  + rx * si + (1 - co) *  rx^2;
