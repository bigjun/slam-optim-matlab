function [H1 H2]=Absolute2RelativeJacobian3D(p1,p2)

% Jacobian of the relative displacement between two poses.
eps_ = sqrt(eps);
eps_2 = 0.5 * eps_;
dof=length(p1);
Eps=eye(dof)*eps_2;

H1=zeros(dof,dof);
H2=zeros(dof,dof);
d = Absolute2Relative3D(p1,p2);
for j=1:dof
    d1=Absolute2Relative3D(p1+Eps(:,j),p2);
    %H1(:,j)= (d1-d)/(Eps(:,j));
    H1(:,j)= (d1-d)/(eps_2);
    d2=Absolute2Relative3D(p1,p2+Eps(:,j));
    %H2(:,j)= (d2-d)/(Eps(:,j));
    H2(:,j)= (d2-d)/(eps_2);
end 


