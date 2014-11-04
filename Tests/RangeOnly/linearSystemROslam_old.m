
function [J,d] = linearSystemROslam_old(nd, dim, dimb, A, poses,buoy, range, RInit, RState, RObs)

I6 = eye(6);
O3 = zeros(3,1);

%nb = (size(x,1)-nd*dim) / dimb;
nb = 4;
m = nb*nd + nd*dim;
n = nb*dimb + nd*dim; 


J  =  zeros(m,n);
d = zeros (m,1);
row = 1:dim;
col = 1:dim;
%poses = reshape(x(1:end-12),dim,nd)';
%buoy = reshape(x((end-11):end),dimb,nb)';

% state init
J(row,col) = -RInit * I6; 
%d(row) = RInit * zeros(dim,1);
%d(row) = RInit * poses(1,:)';
d(row) =   poses(1,:)'; %RObs *

% buoys meas
bcol = nd*dim+(1:dimb); %reset bcol
for i=1:nb
    row = row(end)+1;
    [rb,v] = AbsolutePoint2RB3D(poses(1,:),buoy(i,:)) ;
    J1 = [v/rb;O3]';
    J2 = -(v/rb)';
    J(row,col) = RObs * J1;%
    J(row,bcol) = RObs * J2;
    d(row) = RObs * (range(1,i) - rb)';
   
    bcol = bcol+dimb;
    
end

% model
for j = 2:nd
    row = row(end)+(1:dim);
    coln = col(end)+(1:dim); % column of the new variable
    J(row,col) = RState * A;
    J(row,coln) = - RState * I6;
    d(row) = RState *(poses(j,:)' - A * poses(j-1,:)');
    
    bcol = nd*dim+(1:dimb);%reset bcol
    for i=1:nb
        row = row(end)+1;
        [rb,v] = AbsolutePoint2RB3D(poses(j,:),buoy(i,:)) ;
        J1 = [v/rb;O3]';
        J2 = -(v/rb)';
        J(row,coln) = RObs * J1;
        J(row,bcol) = RObs * J2;
        d(row) = RObs * (range(j,i) - rb)';
        
        bcol = bcol+dimb;
    end
    col=coln;
end
end


