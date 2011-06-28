% This file show an example of incremental Cholesky using Csparse.
% It will be usefull to solve incrementally some 
%  slam problems with the Cholesky method.

% WARNING:
%  * Here only a full loop closure (update of all L) case is treated
%  * In the usage of Csparse chol_update() function, we use R=L' but in C
%      we need to directly use L
%  * We need to develop bloc updates instead of scalar update
%  * We need to create a function taking in parameter A,b,w,e returning
%      the validity of Chol update
%  * We need to create a second function taking in parameter
%      L, d, eta, w, and e, returning Lup, d_up, and eta_up
%  * We need to create a function taking in parameter A, L, and d
%      returning true if L.d=A'.A
%  * We need to add possible covariance parameters

% A.x=b (we want to find x), we have A and b
A=[ 1     0     0
   -1     1     0
    0    -1     1 ];
b=[1 1 1 ]';

% L.R.x=A'.b
%  L = chol(A'.A)
%  R = L'
% L.d=eta
%  d = R.x = L\(A'.b)
R=chol(A'*A);
L=R';
eta=A'*b;
d=L\(A'*b);

% update with new measurement and global loop closure

% new error : e
% e = w.x
% A_up.x = b_up
%  A_up = [A;w];
%  b_up = [b;e]
e = 1 ;
w=[1     0    -1 ];
A_up=[ A ; w] ;
b_up=[b ; e];

% real value for R_up and d_up respecting new Cholesky decomposition
R_up_real=chol(A_up'*A_up)
eta_up=(A_up'*b_up);
d_up_real=R_up_real'\eta_up


% find R_up, d_up incrementally with chol_update()

% //TODO dimplify by directly work with Ld and not Rd !
% Rd = [R,d]
%      [0,p]
%  p=any (positive?) real value not null
% Ld = Rd'
% we = [w,e]
% Ld_up=chol_update(Ld,we')
% Rd_up = Ld_up' = [R_up,d_up]
%                  [xxxxxxxxx]
%  respecting R_up'.R_up = A_up'.A_up
%  respecting d_up : R_up'.d_up=A_up'*b_up
Rd_full = [[R,d];[0 0 0],20];
we=[w,e];
Rd=sparse(Rd_full);
Ld=Rd';
Ld_up=chol_update(Ld,we'); % the result is an L
Rd_up=Ld_up';
R_up=Rd_up(1:3,1:3);
d_up=Rd_up(1:3,4);
R_up_full=full(R_up)
d_up_full=full(d_up)


% with the formulas
%  (given by an analytic analysis of Cholesky blocs update)
L11=[];
L21=[];
eta2=eta_up;
omega=w'*w;
R22_up=chol(L*L'+ omega)
d_formulas=R22_up'\eta2

