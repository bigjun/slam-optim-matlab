function [System]=addFactorPoseHessian(factorR,Config,System)

% Config=addPoseHessian(factorR,Config)
% The script adds a new pose factor to the current System represented in
% Hessian form
% Author: Viorela Ila

global Timing
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
    % augment Lambda and eta
    System.ndx=(System.ndx(end)+1):(System.ndx(end)+Config.PoseDim);
    System.Lambda(System.ndx,System.ndx)=zeros(Config.PoseDim,Config.PoseDim);
    System.eta(System.ndx,1) = zeros(Config.PoseDim,1);
end

ndx=1:Config.PoseDim;
ndxEnd=ndx2-ndx1(1)+1;
h=Absolute2Relative(p1,p2); % Expectation
[H1 H2]=Absolute2RelativeJacobian(p1,p2); % Jacobian
[H,Omega]=computeHOmega(H1,H2,R,Config.PoseDim,ndxEnd(end),ndx,ndxEnd);

% right hand term
ck=cputime;
d=z-h;
d(end)=pi2pi(d(end));
System.eta(ndx1(1):ndx2(end),1)=System.eta(ndx1(1):ndx2(end),1)+full(H'*d);
Timing.updateEta=Timing.updateEta+(cputime-ck);
Timing.updateEtaCnt=Timing.updateEtaCnt+1;

% Hessian matrix
ck=cputime;
System.Lambda(ndx1(1):ndx2(end),ndx1(1):ndx2(end))=System.Lambda(ndx1(1):ndx2(end),ndx1(1):ndx2(end))+Omega;
Timing.updateLambda=Timing.updateLambda+(cputime-ck);
Timing.updateLambdaCnt=Timing.updateLambdaCnt+1;





