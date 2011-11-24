function System=addFactorPose(factorR,Config,System)

% Config=addPose(factorR,Config)
% The script adds a new pose factor to the current System
% Author: Viorela Ila

global Timing

% The 2 poses linked by the constraint
s1=factorR.origine;
s2=factorR.final;
ndx1=[Config.PoseDim*Config.id2config((s1+1),1)+Config.LandDim*Config.id2config((s1+1),2)]+[1:Config.PoseDim];
ndx2=[Config.PoseDim*Config.id2config((s2+1),1)+Config.LandDim*Config.id2config((s2+1),2)]+[1:Config.PoseDim];
p1=Config.vector(ndx1,1); % The estimation of the two poses
p2=Config.vector(ndx2,1);

switch factorR.type
    case {'pose','loopClosure'}
        % 2D case
        % % check for the order of ids and invert the transformation if needed
        if (s1>s2)
            z=factorR.measure';
            s1=factorR.final;
            s2=factorR.origine;   
            disp('NO Invert!!!!!!!');
        else
            z=InvertEdgePose(factorR.measure');
        end
        h=Absolute2Relative(p1,p2); % Expectation
        [H1 H2]=Absolute2RelativeJacobian(p1,p2); % Jacobian
        d=z-h;
        d(end)=pi2pi(d(end));
    case {'pose3D','loopClosure3D'}
        % 3D case
         if (s1>s2)
            z=factorR.measure';
            s1=factorR.final;
            s2=factorR.origine;
         else
             z=InvertEdgePose3D(factorR.measure');
         end
        h=Absolute2Relative3D(p1,p2); % Expectation
        [H1 H2]=Absolute2RelativeJacobian3D(p1,p2); % Jacobian
        d=smartMinus(z,h); % the desplacement from h to z. 
    otherwise
        error('This type of poseFactor is not implemented')
end

% Update System

System.ndx=System.ndx(end)+1:System.ndx(end)+Config.PoseDim;

ck=cputime;
System.A(System.ndx,ndx1)=sparse2(factorR.R*H1); % Jacobian matrix
System.A(System.ndx,ndx2)=sparse2(factorR.R*H2);
if Timing.flag
    Timing.updateA=Timing.updateA+(cputime-ck);
    Timing.updateACnt=Timing.updateACnt+1;
end

% right hand side
ck=cputime;
System.b(System.ndx)=factorR.R*d; % Independent term
if Timing.flag
    Timing.updateB=Timing.updateB+(cputime-ck);
    Timing.updateBCnt=Timing.updateBCnt+1;
end

