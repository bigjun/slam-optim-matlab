function Result=testNonlinearOptimization

% testNonlinearOptimization
% The script applyes nonlinear optimization to a Graph SLAM problem
% The test can be applied to any of the datasets in the ./Data folder 
% '10K', '10KHOGMan','intel','Killian', 'VP'
% The user can choose to either incrementaly optimize the graph or to
% optimize the whole graph at once(batch)
% Author: Viorela Ila

close all;

switch 1
    case 1
        % ROSACE
        dataSet='R1_2D';
        dataPath='~/LAAS/datasets/Rosace';
    case 0
        % Others
        dataSet='intel';
        dataPath='~/LAAS/matlab/slam-optim-matlab/Data'; %TODO automaticaly get the toolbox path
end

saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
maxID=0; % steps to process, if '0', the whole data is processed 
Data=getDataFromFile(dataSet,dataPath,saveFile,maxID);
Data.obsType='rb'; % range and bearing %TODO automaticaly detect obsType


incremental=0; 
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
Config=initConfig(Data);


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
Graph.F=[]; % keeps the factors
Graph.idX=Data.vert(1,1); % the id in the variables in the graph

%[Config]=composePosesOdometry(Data,Config);

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,Graph.idX);
    Config=addVariableConfig(factorR,Config,Graph.idX);
    System=addFactor(factorR,Config,System);
    Graph=addVarLinkToGraph(factorR,Graph);
    if incremental
        [Config, System]=nonlinearOptimization(Config,System,Graph,Solver,Plot);
    end
    ind=ind+1;
    
end

if ~incremental
    [Config, System]=nonlinearOptimization(Config,System,Graph,Solver,Plot);
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