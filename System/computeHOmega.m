function [H,Omega]=computeHOmega(H1,H2,R,dim,size, ndx1,ndx2)
H=sparse(zeros(dim,size));
H(:,ndx1)=sparse(R*H1);
H(:,ndx2)=sparse(R*H2);
Omega=H'*H;