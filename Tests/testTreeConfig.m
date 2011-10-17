function Result=testTreeConfig

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
maxID=100; % steps to process, if '0', the whole data is processed 

pathToolbox='~/LAAS/matlab/slam-optim-matlab/Data'; %TODO automaticaly get the toolbox path
Data=getDataFromFile(dataSet,pathToolbox,saveFile,maxID);
Data.obsType='rb'; % range and bearing %TODO automaticaly detect obsType

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


%params 
Plot.faxis='off';
Plot.colour=[0.5,0.5,0.5];
Plot.ftitle=Data.name;
Plot.fname=sprintf('%s_',Data.name);

%CONFIG
Config=initConfig(Data);

% GRAPH
% factors 
Graph.F=[]; % keeps the factors
%variables
Graph.idX=Data.vert(1,1); % the id in the variables in the graph
Graph.Matrix=sparse(zeros(Data.nVert,Data.nVert));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

System.type='Jacobian';
System.ndx=1:Config.PoseDim;
R0=chol(inv(Config.s0));
System.A(System.ndx,System.ndx)=sparse(R0); % Given noise in the 1st pose
System.b(System.ndx,1)=zeros(Config.PoseDim,1); % the pose will not be updated

Graph=getGraphFromData(Data,Graph);

[tree] = graphminspantree(Graph.Matrix);
[Data.edTree,Data.edCnstr]=separateTreeConstraints(tree,Data.ed);
[Config]=composePosesTree(Data,Config);

% RESET GRAPH
Graph.F=[]; 
Graph.idX=Data.vert(1,1); 
Graph.Matrix=sparse(zeros(Data.nVert,Data.nVert));

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,Graph.idX);
    System=addFactor(factorR,Config,System);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
end
PlotConfig(Plot,Config,Graph,'r','b');


%test compose poses and addFactors


