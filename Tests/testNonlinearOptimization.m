function Result=testNonlinearOptimization(varargin)

% testNonlinearOptimization
% The script applyes nonlinear optimization to a Graph SLAM problem
% The test can be applied to any of the datasets in the ./Data folder 
% '10K', '10KHOGMan','intel','Killian', 'VP'
%
% Examples of how to call the function:
% Result=testNonlinearOptimization('R1_2D','~/LAAS/datasets/Rosace')
% Result=testNonlinearOptimization('10K','~/LAAS/matlab/slam-optim-matlab/Data')
%
% The user can choose to either incrementaly optimize the graph or to
% optimize the whole graph at once(batch)
%
% Author: Viorela Ila

close all;
%--------------------------------------------------------------------------
% PARAMETERS
switch nargin
    case 0
        dataSet='10K';
        dataPath='./Data';
        maxID=100;% steps to process, if '0', the whole data is processed 
    case 1
        dataSet=varargin{1};
        dataPath='./Data';
        maxID=100;% steps to process, if '0', the whole data is processed 
    case 2
        dataSet=varargin{1};
        dataPath=varargin{2};
        maxID=100;% steps to process, if '0', the whole data is processed 
    case 3
        dataSet=varargin{1};
        dataPath=varargin{2};
        maxID=varargin{3};% steps to process, if '0', the whole data is processed 
end

incremental=0;% Incremental or batch
saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
obsType='rb'; % range and bearing %TODO automaticaly detect obsType


%representation='Hessian';
representation='Jacobian';
%representation='CholFactor';

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

% SOLVER 

Solver.maxIT=100;
Solver.tol=1e-4;
Solver.linearSolver='spqr';
Solver.nonlinearSolver='GaussNewton';
%Solver.nonlinearSolver='LevenbergMarquardt';
Solver.lambda=10;
Solver.linearTime=0;
Solver.linearizationTime=0;
Solver.nonlinearTime=0;

% PLOT
%flags
Plot.InitConfig=1;
Plot.Config=1;
Plot.Error=0;
Plot.DMV=0;
Plot.spyMat=0;
Plot.measurement=1;
%params 
Plot.faxis='off';
Plot.colour=[0.5,0.5,0.5];

%--------------------------------------------------------------------------
% INITIALIZATION

% DATA
Data=getDataFromFile(dataSet,dataPath,saveFile,maxID);
Data.obsType=obsType;

% CONFIG
Config=initConfig(Data);

% SYSTEM
System.type= representation;
System.ndx=1:Config.PoseDim;

% GRAPH
Graph.F=[]; % keeps the factors
Graph.idX=Data.vert(1,1); % the id in the variables in the graph


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

%--------------------------------------------------------------------------
% OPTIMIZATION

%[Config]=composePosesOdometry(Data,Config);

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,Graph.idX);
    Config=addVariableConfig(factorR,Config);
    System=addFactor(factorR,Config,System);
    Graph=addVarLinkToGraph(factorR,Graph);
    if incremental
        [Config, System]=nonlinearOptimization(Config,System,Graph,Solver,Plot);
    end
    ind=ind+1;
    
end

if ~incremental
    if Plot.InitConfig
        % plot final config and errors
        Plot.fname=sprintf('%s_',Data.name);
        Plot.ftitle=Data.name;
        PlotConfig(Plot,Config,Graph,'g','y');
    end
    [Config, System]=nonlinearOptimization(Config,System,Graph,Solver,Plot);
end

%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------

% Just for Debug
    
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

%--------------------------------------------------------------------------
% PLOT
% plot final config and errors
Plot.fname=sprintf('%s_',Data.name);
Plot.ftitle=Data.name;
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


Result.Config=Config;
Result.System=System;
Result.Graph=Graph;
Result.Plot=Plot;
Result.Timing=Timing;