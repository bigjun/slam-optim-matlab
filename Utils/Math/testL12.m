a=[1, 0 0 0 0 0 0
-1, 1, 0 0 0 0 0
0 -1, 1, 0 0 0 0
1, 0 0 -1, 0 0 0
0  0 -1 1 0 0 0
0  1  0 0 -1 0 0
0  0  0 0  -1 1 0
0  0  0  0  0 -1 1];
R0 = chol(sparse(a'*a));
L=R0';
L11=L(1:2,1:2);
L12=L(1:2,3:end);

L21=L(3:end,1:2);
L22=L(3:end,3:end);
% new measuremsnt
w=[0 0 -1 0 0 0 1];
b=L22*L22'+w(3:end)'*w(3:end);

[R1,p,S]=chol(sparse(b));
R=chol(sparse(b));
     
L22_new1=(R1)';
L22_new=(R)';


L_new=[L11,L12;L21 L22_new];

Lambda_new=(a'*a)+(w'*w);

norm(L_new*L_new'-Lambda_new)



L_new=[L11,L12;S*L21*S' L22_new1];

Lambda_new=(a'*a)+(w'*w);

SL=[eye(2),zeros(2,5);zeros(5,2),S];

norm(L_new*L_new'-SL'*Lambda_new*SL)