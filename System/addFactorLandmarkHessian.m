function System=addFactorLandmarkHessian(factorR,Config,System)

% Config=addPose(factorR,Config)
% The script adds a new landmark factor to the current System
% Author: Viorela Ila

% The 2 poses linked by the constraint
s1=factorR.data(2); % robot
s2=factorR.data(1); % landmark
z=factorR.data(3:4)';

ndx1=[Config.PoseDim*Config.id2config((s1+1),1)+Config.LandDim*Config.id2config((s1+1),2)]+[1:Config.PoseDim];
ndx2=[Config.PoseDim*Config.id2config((s2+1),1)+Config.PoseDim+Config.LandDim*Config.id2config((s2+1),2)-Config.LandDim]+[1:Config.LandDim];

P1=Config.vector(ndx1); % The estimation of the two poses
pt=Config.vector(ndx2);

% Update System

switch factorR.type
    case 'pose'
        F1=Absolute2RelativeJacobian(P1,z); % Jacobian
        Q=F1*factorR.Sz*F1'; % displacement noise in global coordinates
        iQ=Q\eye(Config.PoseDim);
        
        % right hand term
        v=p2-F1*p1;
        System.eta(System.ndx)=iQ*v;
           
        % Hessian matrix
        System.Lambda(System.ndx,ndx1)=sparse2(-F1'*iQ);
        System.Lambda(System.ndx,ndx2)=sparse2(-iQ*F1);
        System.Lambda(System.ndx,System.ndx)=EIF.Lambda(System.ndx,System.ndx)+sparse2(F1'*iQ*F1);
      
    case 'loopClosure'
        [d, H1, H2]=Absolute2RelativeLandmark(type,P1,pt);
        
        H(:,ndx1)=H1;
        H(:,ndx2)=H2;
        iSz=factorR.Sz\eye(dim);
        
        % right hand term
        System.eta(System.ndx)=EIF.eta+H'*iR*(d+H*Config.vector(:,1));
        
        % Hessian matrix
        System.Lambda=sparse(System.Lambda+H'*iSz*H);
        
    otherwise
        error('This is not a pose factor')
end

