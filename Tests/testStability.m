function [SystemA]=testStability

% testNonlinearOptimization
% The script tests the stability of the Chol Factor


close all;
%--------------------------------------------------------------------------
% PARAMETERS

dataSet='10K';
dataPath='./Data';
maxID=11;% steps to process, if '0', the whole data is processed

saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
obsType='rb'; % range and bearing %TODO automaticaly detect obsType


global Timing
Timing.flag=0;

% DATA
Data=getDataFromFile(dataSet,dataPath,saveFile,maxID);
Data.obsType=obsType;


% %--------------------------------------------------------------------------
% disp('Incremental Cholesky factor...')
% % Chol Factor
% representation='CholFactor';
% % CONFIG
% ConfigL=initConfig(Data);
% 
% % SYSTEM
% SystemL.type= representation;
% SystemL.ndx=1:ConfigL.PoseDim;
% 
% % GRAPH
% GraphL.F=[]; % keeps the factors
% GraphL.idX=ConfigL.IdPose1; % the id in the variables in the graph
% 
% 
% 
% R0=chol(inv(ConfigL.s0));
% SystemL.L(SystemL.ndx,SystemL.ndx)=sparse(R0');
% SystemL.d(SystemL.ndx,1)=zeros(ConfigL.PoseDim,1);
% 
% 
% %[ConfigL]=composePosesOdometry(Data,ConfigL);
% 
% ind=1;
% while ind<=Data.nEd
%     factorR=processEdgeData(Data.ed(ind,:),Data.obsType,GraphL.idX);
%     ConfigL=addVariableConfig(factorR,ConfigL);
%     SystemL=addFactor(factorR,ConfigL,SystemL);
%     GraphL=addVarLinkToGraph(factorR,GraphL);
%     ind=ind+1;
% end

%--------------------------------------------------------------------------
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
disp('QR factorization...')
% Jacobian
representation='Jacobian';

% CONFIG
ConfigA=initConfig(Data);

% SYSTEM
SystemA.type= representation;
SystemA.ndx=1:ConfigA.PoseDim;

% GRAPH
GraphA.F=[]; % keeps the factors
GraphA.idX=ConfigA.IdPose1; % the id in the variables in the graph



R0=chol(inv(ConfigA.s0));
SystemA.A(SystemA.ndx,SystemA.ndx)=sparse(R0); % Given noise in the 1st pose
SystemA.b(SystemA.ndx,1)=zeros(ConfigA.PoseDim,1); % the pose will not be updated


%[ConfigA]=composePosesOdometry(Data,ConfigA);

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,GraphA.idX);
    ConfigA=addVariableConfig(factorR,ConfigA);
    SystemA=addFactor(factorR,ConfigA,SystemA);
    GraphA=addVarLinkToGraph(factorR,GraphA);
    ind=ind+1;
end
n=size(SystemA.A,2);
R=spqr(SystemA.A,struct('ordering','colamd'));
SystemA.L=R(1:n,1:n)';

PlotConfig(Plot,ConfigA,GraphA,'r','b');
% disp('Plots...')
% figure
% spy(SystemL.L)
% %figure
% %spy(SystemA.L)
