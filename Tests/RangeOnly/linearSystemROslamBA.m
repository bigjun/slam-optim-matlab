
function [J,d] = linearSystemROslamBA(nd, dim, dimb, poses,buoy, range, RInit, RObs)

I3 = eye(3);
O3 = zeros(3,1);

nb = 4;
m = nb*nd + dim;
n = nb*dimb + nd*dim; 

J  =  zeros(m,n);
d = zeros (m,1);
row = 1:dim;
col = 1:dim;

% 
% poses = reshape(x(1:end-12),nd,dim);
% buoy = reshape(x((end-11):end),4,dimb);

% % state init
J(row,col) = - RInit(1:3,1:3) * I3;
d(row) = poses(1,1:3); %RObs * 


% buoys
for j = 1:nd
    bcol = nd*dim+(1:dimb);%reset bcol
    for i=1:4
        row = row(end)+1;
        [J1,J2,db] = AbsolutePoint2RB3DJacobian(poses(j,:),buoy(i,:),RObs,range(j,i));      
        J(row,col) = -J1(:,1:3);%
        J(row,bcol) =-J2(:,1:3);
        d(row) =  AbsolutePoint2RB3D(buoy(i,:),poses(j,:)) ;%db;
        bcol = bcol+dimb;
    end
        col = col(end)+(1:dim); % column of the new variable
end



end


