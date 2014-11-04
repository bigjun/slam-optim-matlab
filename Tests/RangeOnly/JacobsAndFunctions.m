syms x y z lx ly lz vx vy vz prevx prevy prevz prevvx prevvy prevvz prev_pose pose landmark dt lmdist distmeas sp1 sp2 sp3 sv1 sv2 sv3 real
pose = [x y z vx vy vz]
prev_pose = [prevx prevy prevz prevvx prevvy prevvz]
landmark = [lx ly lz]

sigPose = [sp1 sp2 sp3]; 
sigVel = [sv1 sv2 sv3];

pores = pose - [prev_pose(1:3) + prev_pose(4:6) + sigPose * dt prev_pose(4:6) + sigVel]
%pores = simple(sqrt(dot(pores, pores))) % 1D residual

J0 = jacobian(pores, prev_pose)
J1 = jacobian(pores, pose)

lmdist = simple(sqrt(dot(landmark - pose(1:3), landmark - pose(1:3))))

J2 = simple(jacobian(distmeas - lmdist, pose))'
J3 = simple(jacobian(distmeas - lmdist, landmark))'

syms pos f_time velocity real

pos = [sin(f_time * .5), -1 - .5 * (.5 + .5 * sin(f_time / 10)), cos(f_time * .5)]
velocity = jacobian(pos, f_time)
simplify(sqrt(dot(velocity, velocity)))