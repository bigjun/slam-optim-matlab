syms mx my mz px py pz tx ty tz r00 r01 r02 r10 r11 r12 r20 r21 r22 R t p m pp e temp d real
m = [mx my mz]'
p = [px py pz]'
t = [tx ty tz]'
R = [r00 r01 r02; r10 r11 r12; r20 r21 r22]

temp = R' * p - t
d = sqrt(dot(temp, temp))
pp = temp / d
e = (acos(dot(m, pp)))^2

J0 = jacobian(e, p)'
J1 = jacobian(e, [r00 r01 r02 r10 r11 r12 r20 r21 r22 tx ty tz]')'

simple(J0)
simple(J1)