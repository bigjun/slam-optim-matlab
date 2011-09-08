function System=addFactorPoseChol(factorR,Config,System)

% Config=addPose(factorR,Config)
% The script adds a new pose factor to the current System represented in
% Cholesky Factor form
% Author: Viorela Ila

global Timing

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
    System.L(System.ndx,System.ndx)=zeros(Config.PoseDim,Config.PoseDim);
    System.d(System.ndx,1) = zeros(Config.PoseDim,1);
end

ndx=1:Config.PoseDim;
ndxEnd=ndx2-ndx1(1)+1;
h=Absolute2Relative(p1,p2); % Expectation
[H1 H2]=Absolute2RelativeJacobian(p1,p2); % Jacobian
[H,Omega]=computeHOmega(H1,H2,factorR.R,Config.PoseDim,ndxEnd(end),ndx,ndxEnd);


% update L
ck=cputime;
L22 = System.L(ndx1(1):ndx2(end),ndx1(1):ndx2(end)) ;
L22_new=(chol(L22*L22'+Omega))';
System.L(ndx1(1):ndx2(end),ndx1(1):ndx2(end))  = L22_new;
if Timing.flag
    Timing.updateL=Timing.updateL+(cputime-ck);
    Timing.updateLcnt=Timing.updateLcnt+1;
end 
% update d

ck=cputime;

d2 = System.d(ndx1(1):ndx2(end),1);
dz=z-h;
dz(end)=pi2pi(dz(end));
System.d(ndx1(1):ndx2(end),1) = L22_new\(L22*d2+H'*dz);
if Timing.flag
    Timing.updateD=Timing.updateD+(cputime-ck);
    Timing.updateDcnt=Timing.updateDcnt+1;
end

