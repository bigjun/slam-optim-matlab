function Result=testAddFactorPose

% testNonlinearOptimization
% The script applyes nonlinear optimization to a Graph SLAM problem
% The test can be applied to any of the datasets in the ./Data folder 
% '10K', '10KHOGMan','intel','Killian', 'VP'
% The user can choose to either incrementaly optimize the graph or to
% optimize the whole graph at once(batch)
% Author: Viorela Ila

close all;
clear all; 

dataSet='10K';
saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
maxID=500; % steps to process, if '0', the whole data is processed 

incremental=0; 

pathToolbox='~/LAAS/matlab/slam-optim-matlab'; %TODO automaticaly get the toolbox path
[vertices,edges]=loadDataSet(dataSet,pathToolbox,saveFile);
[Data.vert, Data.ed]=cut2maxID(maxID, vertices, edges);
Data.nVert=size(Data.vert,1);
Data.nEd=size(Data.ed,1);
Data.name=dataSet;
Data.dof='2D';
Data.obsType='rb'; % range and bering



%CONFIG


Config.p0 =[0;0;(0*pi/180)];
Config.s0=[[0.1^2,0,0];[0,0.1^2,0];[0,0,(5*pi/180)^2]];
%Config.p0 = Data.vert(1,2:end)'; % prior
%Config.s0 = diag([Data.ed(1,6),Data.ed(1,8),Data.ed(1,9)]); % noise on prior
Config.LandDim=2;   % landmark size
Config.PoseDim=3;   % pose size
Config.ndx=0;       % config index
Config.nPoses=0;    % number of poses 
Config.nLands=0;    % number of landmarks
Config.id2config=zeros(Data.nVert,2); % variable id to position in the config vector converter
Config.id2config(Data.vert(1,1)+1,:)=[Config.nPoses,Config.nLands];
Config.vector=[Config.p0,[1,1,1]']; % the second column is used for rapid identification of the landmark=0 vs pose=1
Config.size=size(Config.vector,1);




% GRAPH
% factors 
Graph.F=[]; % keeps the factors
%variables
Graph.idX=Data.vert(1,1); % the id in the variables in the graph

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ConfigJ=Config;
GraphJ=Graph;
SystemJ.type='Jacobian';
SystemJ.ndx=1:Config.PoseDim;
R0=chol(inv(Config.s0));
SystemJ.A(SystemJ.ndx,SystemJ.ndx)=sparse(R0); % Given noise in the 1st pose
SystemJ.b(SystemJ.ndx,1)=zeros(ConfigJ.PoseDim,1); % the pose will not be updated

ind=1;
while ind<=Data.nEd
    factorR.data=Data.ed(ind,:);
    factorR.dof=Data.dof;
    factorR.obsType=Data.obsType; % range and bering
    [ConfigJ, SystemJ, GraphJ]=addFactor(factorR,ConfigJ, SystemJ, GraphJ);
    ind=ind+1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ConfigH=Config;
GraphH=Graph;
SystemH.type='Hessian';
SystemH.ndx=1:Config.PoseDim;
SystemH.Lambda(SystemH.ndx,SystemH.ndx)=sparse(inv(ConfigH.s0 ));
SystemH.eta(SystemH.ndx,1)=zeros(ConfigH.PoseDim,1);

ind=1;
while ind<=Data.nEd
    factorR.data=Data.ed(ind,:);
    factorR.dof=Data.dof;
    factorR.obsType=Data.obsType; % range and bering
    [ConfigH, SystemH, GraphH]=addFactor(factorR,ConfigH, SystemH, GraphH);
    ind=ind+1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConfigL=Config;
GraphL=Graph;
SystemL.type='CholFactor';
SystemL.ndx=1:Config.PoseDim;
SystemL.L(SystemL.ndx,SystemL.ndx)=sparse(chol(inv(ConfigL.s0 ))');
SystemL.d(SystemL.ndx,1)=zeros(ConfigL.PoseDim,1);

ind=1;
while ind<=Data.nEd
    factorR.data=Data.ed(ind,:);
    factorR.dof=Data.dof;
    factorR.obsType=Data.obsType; % range and bering
    [ConfigL, SystemL, GraphL]=addFactor(factorR,ConfigL, SystemL, GraphL);
    ind=ind+1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

testLambda=norm(full(SystemJ.A'*SystemJ.A-SystemH.Lambda))

testEta=norm(full(SystemJ.A'*SystemJ.b-SystemH.eta))



testL=norm(full(SystemJ.A'*SystemJ.A-SystemL.L*SystemL.L'))

testd=norm(full(SystemL.L\(SystemJ.A'*SystemJ.b)-SystemL.d))