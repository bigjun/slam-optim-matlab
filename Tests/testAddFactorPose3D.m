function Result=testAddFactorPose3D

% testAddFactorPose3D
% The script applyes nonlinear optimization to a Graph SLAM problem
% The test can be applied to any of the datasets in the ./Data folder 
% '10K', '10KHOGMan','intel','Killian', 'VP'
% The user can choose to either incrementaly optimize the graph or to
% optimize the whole graph at once(batch)
% Author: Viorela Ila

close all;

dataSet='rosace';
saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
maxID=0; % steps to process, if '0', the whole data is processed 

pathToolbox='~/LAAS/matlab/slam-optim-matlab/Data'; %TODO automaticaly get the toolbox path
Data=getDataFromFile(dataSet,pathToolbox,saveFile,maxID);
%Data=getFake3DDataFrom2D(dataSet,pathToolbox,saveFile,maxID);
Data.obsType='rb'; % range and bearing %TODO automaticaly detect obsType

%plot vertices

%figure
%plot3(Data.vert(1:500,2),Data.vert(1:500,3),Data.vert(1:500,4))

% Timing
global Timing
Timing.flag=0;

%Plot
%flags
Plot.InitConfig=0;
Plot.Config=1;
Plot.Error=0;
Plot.DMV=0;
Plot.spyMat=0;
Plot.measurement=1;


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


%params 
Plot.faxis='off';
Plot.colour=[0.5,0.5,0.5];
Plot.ftitle=Data.name;
Plot.fname=sprintf('%s_',Data.name);

% GRAPH
% factors 
Graph.F=[]; % keeps the factors
%variables
Graph.idX=Data.vert(1,1); % the id in the variables in the graph

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Config=initConfig(Data);
System.type='Jacobian';
System.ndx=1:Config.PoseDim;
R0=chol(inv(Config.s0));
System.A(System.ndx,System.ndx)=sparse(R0); % Given noise in the 1st pose
System.b(System.ndx,1)=zeros(Config.PoseDim,1); % the pose will not be updated

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,Graph.idX);
    Config=addVariableConfig(factorR,Config,Graph.idX);
    System=addFactor(factorR,Config, System);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
end
%[Config, System]=nonlinearOptimization(Config,System,Graph,Solver,Plot);


 PlotConfig(Plot,Config,Graph,'r','b');
 grid;
 axis equal
 