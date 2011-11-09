function Result=testAddFactorPose

% testNonlinearOptimization
% The script applyes nonlinear optimization to a Graph SLAM problem
% The test can be applied to any of the datasets in the ./Data folder 
% '10K', '10KHOGMan','intel','Killian', 'VP'
% The user can choose to either incrementaly optimize the graph or to
% optimize the whole graph at once(batch)
% Author: Viorela Ila

close all;

dataSet='10K';
saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
maxID=100; % steps to process, if '0', the whole data is processed 

pathToolbox='~/LAAS/matlab/slam-optim-matlab/Data'; %TODO automaticaly get the toolbox path
Data=getDataFromFile(dataSet,pathToolbox,saveFile,maxID);
Data.obsType='rb'; % range and bearing %TODO automaticaly detect obsType

% Timing
global Timing
Timing.flag=0;

% GRAPH
% factors 
Graph.F=[]; % keeps the factors
%variables
Graph.idX=Data.vert(1,1); % the id in the variables in the graph

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ConfigJ=initConfig(Data);
GraphJ=Graph;
SystemJ.type='Jacobian';
SystemJ.ndx=1:ConfigJ.PoseDim;
R0=chol(inv(ConfigJ.s0));
SystemJ.A(SystemJ.ndx,SystemJ.ndx)=sparse(R0); % Given noise in the 1st pose
SystemJ.b(SystemJ.ndx,1)=zeros(ConfigJ.PoseDim,1); % the pose will not be updated

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,GraphJ.idX);
    ConfigJ=addVariableConfig(factorR,ConfigJ,GraphJ.idX);
    SystemJ=addFactor(factorR,ConfigJ, SystemJ);
    GraphJ=addVarLinkToGraph(factorR,GraphJ);
    ind=ind+1;
    
end
clear ConfigJ GraphJ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ConfigH=initConfig(Data);
GraphH=Graph;
SystemH.type='Hessian';
SystemH.ndx=1:ConfigH.PoseDim;
SystemH.Lambda(SystemH.ndx,SystemH.ndx)=sparse(inv(ConfigH.s0 ));
SystemH.eta(SystemH.ndx,1)=zeros(ConfigH.PoseDim,1);

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,GraphH.idX);
    ConfigH=addVariableConfig(factorR,ConfigH,GraphH.idX);
    SystemH=addFactor(factorR,ConfigH, SystemH);
    GraphH=addVarLinkToGraph(factorR,GraphH);
    ind=ind+1;
    
end
clear ConfigH GraphH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConfigL=initConfig(Data);
GraphL=Graph;
SystemL.type='CholFactor';
SystemL.ndx=1:ConfigL.PoseDim;
SystemL.L(SystemL.ndx,SystemL.ndx)=sparse(chol(inv(ConfigL.s0 ))');
SystemL.d(SystemL.ndx,1)=zeros(ConfigL.PoseDim,1);


ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,GraphL.idX);
    ConfigL=addVariableConfig(factorR,ConfigL,GraphL.idX);
    SystemL=addFactor(factorR,ConfigL, SystemL);
    GraphL=addVarLinkToGraph(factorR,GraphL);
    ind=ind+1;
end
clear ConfigL GraphL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

testLambda=norm(full(SystemJ.A'*SystemJ.A-SystemH.Lambda))

testEta=norm(full(SystemJ.A'*SystemJ.b-SystemH.eta))


testL=norm(full(SystemJ.A'*SystemJ.A-SystemL.L*SystemL.L'))

testd=norm(full(SystemL.L\(SystemJ.A'*SystemJ.b)-SystemL.d))