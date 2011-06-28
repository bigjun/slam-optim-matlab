
fprintf(1,'test with one new measurement with formulas\n');

% Original
A=[ 1     0     0
   -1     1     0
    0    -1     1 ];
b=[1 1 1 ]';
R=chol(A'*A);
L=R';
eta=(A'*b);
d=L\(eta);

% Update with full loop closure
if (1),
    e = 1 ;
    w=[ 1 0 -1 ];


    [ L_up, d_up, eta_up ] = cholAddMeasurementFormulas(L,d,w,e,eta);
    L_up = full(L_up);
    d_up = full(d_up);

    % real value for R_up and d_up respecting new Cholesky decomposition
    A_up=[ A ; w] ;
    b_up=[b ; e];
    R_up_real = chol(A_up'*A_up) ;
    L_up_real = R_up_real';
    eta_up_real=(A_up'*b_up);
    d_up_real=R_up_real'\eta_up_real;

    n1 = norm(L_up_real-L_up);
    n2 = norm(d_up_real-d_up);
    n3 = norm(eta_up_real-eta_up);
    fprintf(1,'full loop closure : error in updates with formulas (%1.0e %1.0e %1.0e)\n', n1, n2, n3);
end

% Update with local loop closure
if (1),
    e = 1 ;
    w=[ 1 10 ];


    [ L_up, d_up, eta_up ] = cholAddMeasurementFormulas(L,d,w,e,eta);
    L_up = full(L_up);
    d_up = full(d_up);

    % real value for R_up and d_up respecting new Cholesky decomposition
    w_full = [0, w];
    A_up=[ A ; w_full] ;
    b_up=[b ; e];
    R_up_real = chol(A_up'*A_up) ;
    L_up_real = R_up_real';
    eta_up_real=(A_up'*b_up);
    d_up_real=R_up_real'\eta_up_real;

    n1 = norm(L_up_real-L_up);
    n2 = norm(d_up_real-d_up);
    n3 = norm(eta_up_real-eta_up);
    fprintf(1,'small loop closure : error in updates with formulas (%1.0e %1.0e %1.0e)\n', n1, n2, n3);
end

% Update with new state
if (1),
    e = 1 ;
    w =[ -1 1 ];

    % new state elements
    sizeL = size(L);
    L_tmp = zeros(sizeL(1)+1,sizeL(2)+1) ;
    L_tmp(1:sizeL(1), 1:sizeL(2)) = L ;

    [ L_up, d_up, eta_up ] = cholAddMeasurementFormulas(L_tmp,d,w,e,eta,1);
    L_up = full(L_up);
    d_up = full(d_up);

    % real value for R_up and d_up respecting new Cholesky decomposition
    w_full = [0, 0, w];
    A_full = [A, [0;0;0]] ;
    A_up=[ A_full ; w_full] ;
    b_up=[b ; e];
    R_up_real = chol(A_up'*A_up) ;
    L_up_real = R_up_real';
    eta_up_real=(A_up'*b_up);
    d_up_real=R_up_real'\eta_up_real;

    n1 = norm(L_up_real-L_up);
    n2 = norm(d_up_real-d_up);
    n3 = norm(eta_up_real-eta_up);
    fprintf(1,'adding state : error in updates with formulas (%1.0e %1.0e %1.0e)\n', n1, n2, n3);
end

% Update with bloc measurement, full loop closure
if (1),
    e = [1;1] ;
    w = [ 1 0 -1   ; ...
          0 1 -1 ] ;


    [ L_up, d_up, eta_up ] = cholAddMeasurementFormulas(L,d,w,e,eta);
    L_up = full(L_up);
    d_up = full(d_up);

    % real value for R_up and d_up respecting new Cholesky decomposition
    A_up=[ A ; w] ;
    b_up=[b ; e];
    R_up_real = chol(A_up'*A_up) ;
    L_up_real = R_up_real';
    eta_up_real=(A_up'*b_up);
    d_up_real=R_up_real'\eta_up_real;

    n1 = norm(L_up_real-L_up);
    n2 = norm(d_up_real-d_up);
    n3 = norm(eta_up_real-eta_up);
    fprintf(1,'full loop closure, multiMeasurement : error in updates with formulas (%1.0e %1.0e %1.0e)\n', n1, n2, n3);
end

% Update with bloc measurement, small loop closure
if (1),
    e = [1;1] ;
    w = [ 2 -1   ; ...
          1 -1 ] ;


    [ L_up, d_up, eta_up ] = cholAddMeasurementFormulas(L,d,w,e,eta);
    L_up = full(L_up);
    d_up = full(d_up);

    % real value for R_up and d_up respecting new Cholesky decomposition
    w_full = zeros(2,3) ;
    w_full(:,2:end) = w ;
    A_up=[ A ; w_full] ;
    b_up=[b ; e];
    R_up_real = chol(A_up'*A_up) ;
    L_up_real = R_up_real';
    eta_up_real=(A_up'*b_up);
    d_up_real=R_up_real'\eta_up_real;

    n1 = norm(L_up_real-L_up);
    n2 = norm(d_up_real-d_up);
    n3 = norm(eta_up_real-eta_up);
    fprintf(1,'small loop closure, multiMeasurement : error in updates with formulas (%1.0e %1.0e %1.0e)\n', n1, n2, n3);
end

