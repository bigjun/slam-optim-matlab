function A= q2R(q)
% Q_TO_DCM converts a quaternion [x y z w]' to a DCM and Q
    I = eye(3);
    q_ = q(1:3);
    Q = [0 -q(3) q(2);
         q(3) 0 -q(1);
         -q(2) q(1) 0];
    A = (q(4)^2 - q_'*q_) * I + 2 * (q_ * q_') + 2 * q(4) * Q; 
end