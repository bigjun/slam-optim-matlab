
fprintf(1,'test with one new measurement');

% Original
A=[ 1     0     0
   -1     1     0
    0    -1     1 ];
b=[1 1 1 ]';
R=chol(A'*A);
L=R';
eta=(A'*b);
d=L\(eta);

% Updates
e = 1 ;
w=[ 
    1 0 -1 ];


[ L_up, d_up, eta_up ] = cholAddMeasurement(L,d,w,e,eta);
L_up = full(L_up);
d_up = full(d_up);

% real value for R_up and d_up respecting new Cholesky decomposition
A_up=[ A ; w] ;
b_up=[b ; e];
R_up_real = chol(A_up'*A_up) ;
L_up_real = R_up_real';
eta_up_real=(A_up'*b_up);
d_up_real=R_up_real'\eta_up_real;

norm(L_up_real-L_up)
norm(d_up_real-d_up)
norm(eta_up_real-eta_up)
