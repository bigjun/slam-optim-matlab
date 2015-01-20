function covTest

clear all
dof = 3;

% test incremental update

[A49,rows49,cols49,entries49,rep49,field49,symm49] = mmread('lambda_049.mtx');
[A50,rows50,cols50,entries50,rep50,field50,symm50] = mmread('lambda_050.mtx');


R49=chol(A49);
R50=chol(A50);


% ground truth
S49=inv(R49);
S50=inv(R50);

C49=S49 * S49';
C50=S50 * S50';


deltaC50 = C50 - C49; 


% Jacobians
% edge between 7 and 28

ui = 7; % update index 1
un = 28; % update index 1


% from the file
Ii = inv([ 1.000000 0.000000 0.000000;  0.000000 1.000000 0.000000;  0.000000 0.000000 1.000000]);
Cy = inv(Ii);
Ry = chol(Cy);

Hui = [ 0.032396 -0.999475 0.007794;  0.999475 0.032396 -1.045596;  0.000000 0.000000 -1.000000];
Hun = [ -0.032396 0.999475 0.000000;  -0.999475 -0.032396 0.000000;  0.000000 0.000000 1.000000];

Hu = [Hui Hun];

omega = Hu' * Ii * Hu;

[L,D]=ldl(omega);

% ith and nth block colums of the cov matrix

Tui = C49(:, iblk(dof,ui));
Tun = C49(:, iblk(dof,un));

Tu = [Tui Tun];



% innovation 
s11 = Tui(iblk(dof,ui),:);
s12 = Tun(iblk(dof,ui),:);
s21 = s12';
s22 = Tun(iblk(dof,un),:);


% Luki's formula

H = Ry * Hu;
I = eye(dof,dof);
S = I - H * [s11,s12;s21,s22] * H'



Su = Hu * [s11,s12;s21,s22] * Hu' + Cy;
Vy = chol(inv(Su));

Bu =  Tu * Hu' * Vy';

deltaCu = - Bu * Bu';

norm (deltaC50 - deltaCu)


% only the diagonal

it = 40; % test index 

D49 = spdiags(spdiags(C49,[-1,0,1]),[-1,0,1],rows49,cols49); 
D50 = spdiags(spdiags(C50,[-1,0,1]),[-1,0,1],rows50,cols50); 

%TODO

end



function Cii = covTRO(R, i)
% try the TRO's solve by column
% returns C(i,i) element of the cov matrix
ei = zeros(n,1);
ei(i)=1;
y = R'\ ei;
ci = R\ y;
Cii = ci (i)
end


function Cii = covPartBack(R, i)
% try the partial backsubst
ei = zeros(n,1);
ei(i)=1;
L=R';
y = L(i:end,i:end)\ei(i:end);
ci = R(i:end,i:end)\ y;
Cii = ci (i)
end

function Cii = covIncr(R, i)
% TODO

end 

function H = getJacobian(edgeNo)
Jfile = sprints('edge_info_.m')
load ('edge_info_0.m');
% TODO
end

function ib = iblk(dof,i) 

ib = (dof*i)-(dof-1):(dof*i);
end