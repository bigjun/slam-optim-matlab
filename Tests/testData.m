function testData

% testData 
% dataSet='rosace2D';
% dataSet='rosace3D';

dataSet='10K';
pathData='./Data';
saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
maxID=0; % steps to process, if '0', the whole data is processed 

Data=getDataFromFile(dataSet,pathData,saveFile,maxID);
Data.obsType='rb'; % range and bearing %TODO automaticaly detect obsType

representation='Jacobian';
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
Graph.F=[]; % keeps the factors
Graph.idX=Data.vert(1,1); % the id in the variables in the graph

%[Config]=composePosesOdometry(Data,Config);

ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,Graph.idX);
    Config=addVariableConfig(factorR,Config);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
    
end
PlotConfig(Plot,Config,Graph,'r','b');
