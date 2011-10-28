function Result=testGraph

% testGraph
% The script test the Graph construction. 
% Author: Viorela Ila

close all;

dataSet='VP';
saveFile=1; % save edges and vertices to a .mat file to speed up the reading when used again.
maxID=100; % steps to process, if '0', the whole data is processed 

pathToolbox='~/LAAS/matlab/slam-optim-matlab/Data'; %TODO automaticaly get the toolbox path
Data=getDataFromFile(dataSet,pathToolbox,saveFile,maxID);
Data.obsType='rb'; % range and bearing %TODO automaticaly detect obsType

%CONFIG
Config=initConfig(Data);

% GRAPH

Graph.F=[]; 
Graph.idX=Data.vert(1,1);
Graph.Matrix=sparse(zeros(Data.nVert,Data.nVert));


Config=composePosesOdometry(Data,Config);
ind=1;
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,Graph.idX);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
end



