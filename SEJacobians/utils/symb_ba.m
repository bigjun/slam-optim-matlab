syms r11 r12 r13 r21 r22 r23 r31 r32 r33 tx ty tz real
syms fx fy px py
syms x y z real



u = (fx*r11*x + fx*r12*y + fx*r13*z + fx*tx + px*r31*x + px*r32*y + px*r33*z + px*tz) / (r31*x + r32*y + r33*z + tz);
v = (fy*r21*x + fy*r22*y + fy*r23*z + fy*ty + py*r31*x + py*r32*y + py*r33*z + py*tz) / (r31*x + r32*y + r33*z + tz);

%u
Ju_r11 = simplify(diff(u, r11)); Ju_r12 = simplify(diff(u, r12)); Ju_r13 = simplify(diff(u, r13));
Ju_r21 = simplify(diff(u, r21)); Ju_r22 = simplify(diff(u, r22)); Ju_r23 = simplify(diff(u, r23));
Ju_r31 = simplify(diff(u, r31)); Ju_r32 = simplify(diff(u, r32)); Ju_r33 = simplify(diff(u, r33));

Ju_tx = simplify(diff(u, tx)); Ju_ty = simplify(diff(u, ty)); Ju_tz = simplify(diff(u, tz));

Ju_fx = simplify(diff(u, fx)); Ju_fy = simplify(diff(u, fy));
Ju_px = simplify(diff(u, px)); Ju_py = simplify(diff(u, py));

Ju_x = simplify(diff(u, x)); Ju_y = simplify(diff(u, y)); Ju_z = simplify(diff(u, z));

%v
Jv_r11 = simplify(diff(v, r11)); Jv_r12 = simplify(diff(v, r12)); Jv_r13 = simplify(diff(v, r13));
Jv_r21 = simplify(diff(v, r21)); Jv_r22 = simplify(diff(v, r22)); Jv_r23 = simplify(diff(v, r23));
Jv_r31 = simplify(diff(v, r31)); Jv_r32 = simplify(diff(v, r32)); Jv_r33 = simplify(diff(v, r33));

Jv_tx = simplify(diff(v, tx)); Jv_ty = simplify(diff(v, ty)); Jv_tz = simplify(diff(v, tz));

Jv_fx = simplify(diff(v, fx)); Jv_fy = simplify(diff(v, fy));
Jv_px = simplify(diff(v, px)); Jv_py = simplify(diff(v, py));

Jv_x = simplify(diff(v, x)); Jv_y = simplify(diff(v, y)); Jv_z = simplify(diff(v, z));

J1 = [ [Ju_r11 Ju_r12 Ju_r13 Ju_r21 Ju_r22 Ju_r23 Ju_r31 Ju_r32 Ju_r33 Ju_tx Ju_ty Ju_tz Ju_fx Ju_fy Ju_px Ju_py]; 
       [Jv_r11 Jv_r12 Jv_r13 Jv_r21 Jv_r22 Jv_r23 Jv_r31 Jv_r32 Jv_r33 Jv_tx Jv_ty Jv_tz Jv_fx Jv_fy Jv_px Jv_py]; ];
   
J2 = [ [Ju_x Ju_y Ju_z]; 
       [Jv_x Jv_y Jv_z]; ];
   
%second approach - all in vector form
pR = [r11 r12 r13; r21 r22 r23; r31 r32 r33];
pt = [tx ty tz]';
P =  [pR, pt;];
pX = [x y z 1]';
pA = [fx 0 px; 0 fy py; 0 0 1];

uv = pA*(P*pX);
uv = uv / uv(3);
%uv = simplify(uv);

J1_vect = jacobian(uv(1:2), [r11 r12 r13 r21 r22 r23 r31 r32 r33 tx ty tz fx fy px py]);
J2_vect = jacobian(uv(1:2), [x y z]);

%now what? - simplify
for i = 1:length(J1_vect(:,1))
    for j = 1:length(J1_vect(1,:))
        J1_vect(i,j) = simplify(J1_vect(i,j));
    end
end

for i = 1:length(J2_vect(:,1))
    for j = 1:length(J2_vect(1,:))
        J2_vect(i,j) = simplify(J2_vect(i,j));
    end
end
