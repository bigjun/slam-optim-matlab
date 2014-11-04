syms x y z lx ly lz vx vy vz prevx prevy prevz prevvx prevvy prevvz prev_pose pose landmark dt real
pose = [x y z vx vy vz]
prev_pose = [prevx prevy prevz prevvx prevvy prevvz]
landmark = [lx ly lz]
pores = pose - [prev_pose(1:3) + prev_pose(4:6) * dt prev_pose(4:6)]

J0 = jacobian(pores, prev_pose)
J1 = jacobian(pores, pose)
J2 = simple(jacobian(simple(sqrt(dot(landmark - pose(1:3), landmark - pose(1:3)))), pose))'
J3 = simple(jacobian(simple(sqrt(dot(landmark - pose(1:3), landmark - pose(1:3)))), landmark))'