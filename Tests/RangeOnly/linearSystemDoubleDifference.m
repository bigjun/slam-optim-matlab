
function [J,d] = linearSystemDoubleDifference(meas,poses,buoy,RInit,RState,RObs,dim,dimb,A,nd,nb)

I6 = eye(6);
I3 = eye(3);

%nb = (size(x,1)-nd*dim) / dimb;
nb = 4;
m = nb*nd + nd*dim;
n = nb*dimb + nd*dim; 


J  =  zeros(m,n);
d = zeros (m,1);

col = 1:dim;
%poses = reshape(x(1:end-12),dim,nd)';
%buoy = reshape(x((end-11):end),dimb,nb)';

% prior on pose
% row = 1:dim;
% J(row,col) = -RInit * I6; 
% d(row) = RInit * zeros(dim,1);
% d(row) = RInit * poses(1,:)';
% d(row) =  poses(1,:)'; %RObs *


% prior on buoys
row = 1:dimb;
bcol = nd*dim+(1:dimb); %reset bcol
for i=1:nb
    J(row,bcol)= RInit(1:3,1:3) * I3;
    %d(row) = RInit * zeros(dim,1);
    %d(row) = RInit * poses(1,:)';
    d(row) = [0 0 0]';% buoy(i,:)'; %RObs *
    bcol = bcol+dimb;
    row = row(end)+(1:dimb);
end




% buoys meas
bcol = nd*dim+(1:dimb); %reset bcol
for i=1:nb
    row = row(end)+1;
    [J1,J2,db] = AbsoluteBuoy2DDJacobian(poses(1,:),buoy(i,:),RObs,range(1,i));
    J(row,col) = J1;%
    J(row,bcol)= J2;
    d(row) = db;
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
        [J1,J2,db] = AbsolutePoint2RB3DJacobian(poses(j,:),buoy(i,:),RObs,range(j,i));
        J(row,coln) = J1;%
        J(row,bcol) =J2;
        d(row) = db;
        bcol = bcol+dimb;
    end
    col=coln;
end
end



