function System=linearSystem(Config,Graph,System) 

% System=linearSystem(Config,Graph,System) 
% The script linearizes the nonlinear system on the current linearization
% points given by Config 
% Returns the relinearized system: System
% Author: Viorela Ila

global Timing
nObs=size(Graph.F,1);
System.ndx=1:Config.PoseDim;
 
if strcmp(System.type,'Hessian')
    [m,n]=size(System.Lambda);
    System.Lambda=sparse(zeros(m,n));
    System.Lambda(System.ndx,System.ndx)=sparse(inv(Config.s0 ));
    System.eta=zeros(m,1);    
elseif strcmp(System.type,'CholFactor');
    [m,n]=size(System.L);
    R0=chol(inv(Config.s0));
    System.L=sparse(zeros(m,n));
    System.L(System.ndx,System.ndx)=sparse(R0');
    System.d=sparse(zeros(m,1)); 
else
    R0=chol(inv(Config.s0));
    [m,n]=size(System.A);
    System.A=sparse(zeros(m,n));
    System.A(System.ndx,System.ndx)=sparse(R0); % Given noise in the 1st pose
    System.b=sparse(zeros(m,1)); % the pose will not be updated
end


for i=1:nObs
    factorR=Graph.F(i,:);
    if factorR.data(end)~=99999
        if strcmp(System.type,'Hessian')
            ck=cputime;
            System=addFactorPoseHessian(factorR,Config,System);
            if Timing.flag
                Timing.addFactor=Timing.addFactor+(cputime-ck);
                Timing.addFactorCnt=Timing.addFactorCnt+1;
            end
        elseif strcmp(System.type,'CholFactor');
            ck=cputime;
            System=addFactorPoseChol(factorR,Config,System);
            if Timing.flag
                Timing.addFactor=Timing.addFactor+(cputime-ck);
                Timing.addFactorCnt=Timing.addFactorCnt+1;
            end
        else
            ck=cputime;
            System=addFactorPose(factorR,Config,System);
            if Timing.flag
                Timing.addFactor=Timing.addFactor+(cputime-ck);
                Timing.addFactorCnt=Timing.addFactorCnt+1;
            end
        end
        
    else
        if strcmp(System.type,'Hessian')
            error('This method is not implemented')
        elseif strcmp(System.type,'CholFactor');
            error('This method is not implemented');
        else
            System=addFactorLandmark(factorR,Config,System);
        end
    end
end


    

