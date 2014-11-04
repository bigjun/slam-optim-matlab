
function [J,d] = linearSystemPseudoRange(range,poses,buoy,RInit,RState,RBias,RObs,dim,dimb,A,nd,nb)

I6 = eye(6);

Idimb = eye(dimb);

%nb = (size(x,1)-nd*dim) / dimb;

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
row = 0;
bcol = nd*dim+(1:dimb); %reset bcol
for i=1:nb
    row = row(end)+(1:dimb);
    J(row,bcol)= RInit(1:dimb,1:dimb) * Idimb;
    %d(row) = RInit * zeros(dim,1);
    %d(row) = RInit * poses(1,:)';
    d(row) = zeros(dimb,1);% buoy(i,:)'; %RObs *
    bcol = bcol+dimb;
end

%%%%%%%%%%%%%%
% buoys meas
bcol = nd*dim+(1:dimb); %reset bcol
for i=1:nb
    row = row(end)+1;
    [J1,J2,db] = AbsoluteBuoy2PRJacobian(poses(1,1:3),buoy(i,:),poses(1,end),RObs,range(1,i));
    J(row,col) = J1;%
    J(row,bcol)= J2;
    d(row) = db;
    bcol = bcol+dimb;
    
end


for j = 2:nd
    
    %constant velocity model
    row = row(end)+(1:dim-1);
    coln = col(end)+(1:dim); % column of the new variable
    J(row,col(1:end-1)) =  RState * A;
    J(row,coln(1:end-1)) = - RState * I6;
    d(row) = RState *(poses(j,1:end-1)' - A * poses(j-1,1:end-1)');
    
    % constant clock bias model
    row = row(end)+1;
    colbc  =  col(end);
    colbcn =  coln(end);
    J(row,colbc) =   RBias;
    J(row,colbcn) = -  RBias;
    d(row) = (poses(j,end)' -  poses(j-1,end)');
    
    % measurement model
    bcol = nd*dim+(1:dimb);%reset bcol
    for i=1:nb
        row = row(end)+1;
        [PR_p,PR_b,db] = AbsoluteBuoy2PRJacobian(poses(j,1:3),buoy(i,:),poses(j,end),RObs,range(j,i));
        J(row,coln) = PR_p;%
        J(row,bcol) = PR_b;
        d(row) = db;
        bcol = bcol+dimb;
    end
    col=coln;
end
end










% 
% 
% %%%%%%%%%%%%%%
% % buoys meas
% bcol = nd*dim+(1:dimb); %reset bcol
% for i=1:nb
%     row = row(end)+1;
%     [J1,J2,db] = AbsoluteBuoy2PRJacobian(poses(1,1:3),buoy(i,:),poses(1,end),RObs,range(1,i));
%     J(row,col) = J1;%
%     J(row,bcol)= J2;
%     d(row) = db;
%     bcol = bcol+dimb;
%     
% end
% 
% % model
% for j = 2:nd
%     row = row(end)+(1:dim-1);
%     coln = col(end)+(1:dim); % column of the new variable
%     J(row,col(1:end-1)) = RState * A;
%     J(row,coln(1:end-1)) = - RState * I6;
%     d(row) = RState *(poses(j,1:end-1)' - A * poses(j-1,1:end-1)');
%     
%     bcol = nd*dim+(1:dimb);%reset bcol
%     for i=1:nb
%         row = row(end)+1;
%         [J1,J2,db] = AbsoluteBuoy2PRJacobian(poses(j,1:3),buoy(i,:),poses(j,end),RObs,range(j,i));
%         J(row,coln) = J1;%
%         J(row,bcol) =J2;
%         d(row) = db;
%         bcol = bcol+dimb;
%     end
%     col=coln;
% end
% end
% 
% 
% 
