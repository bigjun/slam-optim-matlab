function System=addFactorPoseCholUpdate(factorR,Config,System)

% Config=addPose(factorR,Config)
% The script adds a new pose factor to the current System
% Author: Viorela Ila


Sz=diag([1/factorR.data(6);1/factorR.data(8);1/factorR.data(9)]); % only diag cov.
R=chol(inv(Sz)); %S^(-1/2)

% The 2 poses linked by the constraint
s1=factorR.data(2);
s2=factorR.data(1);

% % check for the order of ids and invert the transformation if needed
if (s1>s2)
    z=factorR.data(3:5)';
    s1=factorR.data(1);
    s2=factorR.data(2);
else
     z=InvertEdge(factorR.data(3:5)');
end

ndx1=[Config.PoseDim*Config.id2config((s1+1),1)+Config.LandDim*Config.id2config((s1+1),2)]+[1:Config.PoseDim];
ndx2=[Config.PoseDim*Config.id2config((s2+1),1)+Config.LandDim*Config.id2config((s2+1),2)]+[1:Config.PoseDim];


p1=Config.vector(ndx1,1); % The estimation of the two poses
p2=Config.vector(ndx2,1);


if strcmp(factorR.type,'odometric')
    % augment L and d
    System.ndx=(System.ndx(end)+1):(System.ndx(end)+Config.PoseDim);
    ze=zeros(Config.PoseDim,1);
    System.d=[System.d;ze];
    zl=zeros(Config.PoseDim,System.ndx(end));
    zc=zeros((System.ndx(end)-(Config.PoseDim)),Config.PoseDim);
    System.L=[System.L,zc;zl];
end

h=Absolute2Relative(p1,p2); % Expectation
[H1 H2]=Absolute2RelativeJacobian(p1,p2); % Jacobian

H=zeros(Config.PoseDim,System.ndx(end));
H(:,ndx1)=H1;
H(:,ndx2)=H2;
H=sparse(H(1:Config.PoseDim,ndx1(1):System.ndx(end)));
iSz=Sz\eye(Config.PoseDim); 
Omega=H'*iSz*H;

% update L
L22 = System.L(ndx1(1):ndx2(end),ndx1(1):ndx2(end)) ;
L22_new=(chol(L22*L22'+Omega))';
System.L(ndx1(1):ndx2(end),ndx1(1):ndx2(end))  = L22_new;
System.L = chol_update(System.L,R*H) 

% update d
d2 = System.d(ndx1(1):ndx2(end),1);
dz=z-h;
dz(end)=pi2pi(dz(end));
System.d(ndx1(1):ndx2(end),1) = L22_new\(L22*d2+H'*iSz*dz);

