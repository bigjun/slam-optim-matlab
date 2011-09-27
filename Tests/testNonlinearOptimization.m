function Result=testNonlinearOptimization

% testNonlinearOptimization
% The script applyes nonlinear optimization to a Graph SLAM problem
% The test can be applied to any of the datasets in the ./Data folder 
% '10K', '10KHOGMan','intel','Killian', 'VP'
% The user can choose to either incrementaly optimize the graph or to
% optimize the whole graph at once(batch)
% Author: Viorela Ila

close all;

dataSet='VP';
saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
maxID=500; % steps to process, if '0', the whole data is processed 
incremental=1; 
%representation='Hessian';
representation='Jacobian';
%representation='CholFactor';

% Timing
global Timing
Timing.flag=1;
if Timing.flag
    switch representation
        case 'CholFactor'
            Timing.updateL=0;
            Timing.updateLcnt=1;
            Timing.updateD=0;
            Timing.updateDcnt=1;
        case 'Hessian'
            Timing.updateEta=0;
            Timing.updateEtaCnt=1;
            Timing.updateLambda=0;
            Timing.updateLambdaCnt=1;
        case 'Jacobian'
            Timing.updateA=0;
            Timing.updateACnt=1;
            Timing.updateB=0;
            Timing.updateBCnt=1;
        otherwise
            error('This state representation is not implemented');
    end
    Timing.nonlinearSolver=0;
    Timing.nonlinearSolverCnt=1;
    Timing.linearSolver=0;
    Timing.linearSolverCnt=1;
    Timing.linearization=0;
    Timing.linearizationCnt=1;
    Timing.addFactor=0;
    Timing.addFactorCnt=1;
end


%DATA
pathToolbox='~/LAAS/matlab/slam-optim-matlab'; %TODO automaticaly get the toolbox path
Data=getDataFromFile(dataSet,pathToolbox,saveFile,maxID);
Data.obsType='rb'; % range and bering

% PARAMETERS

%Solver
Solver.maxIT=100;
Solver.tol=1e-4;
Solver.linearSolver='spqr';
Solver.nonlinearSolver='GaussNewton';
%Solver.nonlinearSolver='LevenbergMarquardt';
Solver.lambda=10;
Solver.linearTime=0;
Solver.linearizationTime=0;
Solver.nonlinearTime=0;

%Plot
%flags
Plot.InitConfig=0;
Plot.Config=1;
Plot.Error=0;
Plot.DMV=0;
Plot.spyMat=0;
Plot.measurement=1;


%params 
Plot.faxis='off';
Plot.colour=[0.5,0.5,0.5];
Plot.ftitle=Data.name;
Plot.fname=sprintf('%s_',Data.name);


%CONFIG
isLandmark=find(Data.ed(:,end)==99999);
if isLandmark
    landmark.data=Data.ed(isLandmark(1),:);
    landmark=getDofRepresentation(landmark);
    Config.LandDim=landmark.dof;   % landmark size
    pose.data=Data.ed(1,:);
    pose=getDofRepresentation(pose);
    Config.PoseDim=pose.dof;   % pose size
else
    pose.data=Data.ed(1,:);
    pose=getDofRepresentation(pose);
    Config.PoseDim=pose.dof;   % pose size
    Config.LandDim=0;
end
    

Config.p0 =[0;0;(0*pi/180)];
Config.s0=[[0.1^2,0,0];[0,0.1^2,0];[0,0,(5*pi/180)^2]];
%Config.p0 = Data.vert(1,2:end)'; % prior
%Config.s0 = diag([Data.ed(1,6),Data.ed(1,8),Data.ed(1,9)]); % noise on
%prior
Config.ndx=0;       % config index
Config.nPoses=0;    % number of poses 
Config.nLands=0;    % number of landmarks
Config.id2config=zeros(Data.nVert,2); % variable id to position in the config vector converter
Config.id2config(Data.vert(1,1)+1,:)=[Config.nPoses,Config.nLands];
Config.vector=[Config.p0,ones(Config.PoseDim,1)]; % the second column is used for rapid identification of the landmark=0 vs pose=1
Config.size=size(Config.vector,1);

%SYSTEM
System.type= representation;
System.ndx=1:Config.PoseDim;


R0=chol(inv(Config.s0));
if strcmp(System.type,'Hessian')
    System.Lambda(System.ndx,System.ndx)=sparse(inv(Config.s0 ));
    System.eta(System.ndx,1)=zeros(Config.PoseDim,1);
elseif strcmp(System.type,'CholFactor');
    System.L(System.ndx,System.ndx)=sparse(R0'); 
    System.d(System.ndx,1)=zeros(Config.PoseDim,1);
else
    System.A(System.ndx,System.ndx)=sparse(R0); % Given noise in the 1st pose
    System.b(System.ndx,1)=zeros(Config.PoseDim,1); % the pose will not be updated
end


% GRAPH
% factors 
Graph.F=[]; % keeps the factors
%variables
Graph.idX=Data.vert(1,1); % the id in the variables in the graph

if ~incremental    
    
    % Build the system and initial configuration
    [Config, System, Graph]=initialConfiguration(Data,Config,System,Graph);
    Result.initConfig=Config;
    % plot initial config
    if Plot.InitConfig
        PlotConfig(Plot,Config,Graph,'g','y');
    end
    % OPTIMIZE
    [Config, System]=nonlinearOptimization(Config,System,Graph,Solver,Plot); 
else
    ind=1;
    while ind<=Data.nEd
        factorR.data=Data.ed(ind,:);
        factorR.obsType=Data.obsType;
        [Config, System, Graph]=addFactor(factorR,Config, System, Graph);
        [Config, System]=nonlinearOptimization(Config,System,Graph,Solver,Plot); 
        ind=ind+1;
        
    end
end

% Timing


switch representation
    case 'CholFactor'
        Timing.updateL=Timing.updateL/Timing.updateLcnt;
        Timing.updateD=Timing.updateD/Timing.updateDcnt;
    case 'Hessian'
        Timing.updateLambda=Timing.updateLambda/Timing.updateLambdaCnt;
        Timing.updateEta=Timing.updateEta/Timing.updateEtaCnt;
    case 'Jacobian'
        Timing.updateA=Timing.updateA/Timing.updateACnt;
        Timing.updateB=Timing.updateB/Timing.updateBCnt;
    otherwise
        error('This state representation is not implemented');
end



Timing.linearSolver=Timing.linearSolver/Timing.linearSolverCnt;
Timing.linearization=Timing.linearization/Timing.linearizationCnt;
Timing.addFactor=Timing.addFactor/Timing.addFactorCnt;


% Just for Debug%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% switch representation
%     case 'CholFactor'
%         Timing_updateL=Timing.updateL
%         Timing_updateD=Timing.updateD
%     case 'Hessian'
%         Timing_updateLambda=Timing.updateLambda
%         Timing_updateEta=Timing.updateEta
%     case 'Jacobian'
%         Timing_updateA=Timing.updateA
%         Timing_updateB=Timing.updateB
%     otherwise
%         error('This state representation is not implemented');
% end
% 
% Timing_linearSolver=Timing.linearSolver
% Timing_linearization=Timing.linearization
% Timing_addFactor=Timing.addFactor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Result.Config=Config;
Result.System=System;
Result.Graph=Graph;
Result.Plot=Plot;
Result.Timing=Timing;
% plot final config and errors
PlotConfig(Plot,Config,Graph,'r','b');
if Plot.DMV
    figure
    plot(Config.dmv)
    title('DMV');
end
if Plot.Error
    figure
    plot(Config.all_error)
    title('Error');
    
end