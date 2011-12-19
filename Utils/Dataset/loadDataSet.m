function [vertices,edges, dataFile]=loadDataSet(dataSet,dataPath,saveFile)

% [vertices,edges, dataFile]=loadDataSet(dataSet,saveFile)
% The script the function loads the data from file (graph format)
% Returns the vertices, edges and dataFile name
% Author: Viorela Ila

switch dataSet
    case 'intel'
        dataFileGraph = [dataPath,'/intel.graph'];
    case 'Killian'
        dataFileGraph = [dataPath,'/Killian.graph'];
    case '10K'
        dataFileGraph = [dataPath,'/10K.graph'];
    case '10KHOGMan'
        dataFileGraph = [dataPath,'/10KHOGMan.graph'];
    case 'VP'
        dataFileGraph = [dataPath,'/VP.graph'];
    case 'sphere'
        dataFileGraph = [dataPath,'/sphere.graph'];
    case 'parking'
        dataFileGraph = [dataPath,'/parking.graph'];
    case 'R1_2D'
        dataFileGraph = [dataPath,'/R1_2D.graph'];
    case 'R1_3D'
        dataFileGraph = [dataPath,'/R1_3D.graph'];
    case 'R2_2D'
        dataFileGraph = [dataPath,'/R2_2D.graph'];
    case 'R2_3D'
        dataFileGraph = [dataPath,'/R2_3D.graph'];
    case 'R3_2D'
        dataFileGraph = [dataPath,'/R3_2D.graph'];
    case 'R3_3D'
        dataFileGraph = [dataPath,'/R3_3D.graph'];
    otherwise
        error('%s Dataset does not exist!',dataSet);
end

dataFileMat=cat(2,dataFileGraph(1:end-6),'.mat');

%make sure that there are no other variables called vertices, edges
clear vertices;
clear edges;


% read the file
if exist(dataFileMat,'file')    
    disp('Loading ed, ver from .MAT file ...')
    load(dataFileMat);
else
    disp('Loading ed, ver from .GRAPH file ...')
    [vertices, edges]=loadFromFile(dataFileGraph);
end

%save data to a mat file
if saveFile
    save(dataFileMat,'vertices','edges');
end
dataFile=dataFileGraph(1:end-6);