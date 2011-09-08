function [vertices,edges, dataFile]=loadDataSet(dataSet,pathToolbox,saveFile)

% [vertices,edges, dataFile]=loadDataSet(dataSet,saveFile)
% The script the function loads the data from file (graph format)
% Returns the vertices, edges and dataFile name
% Author: Viorela Ila

switch dataSet
    case 'intel'
        dataFileGraph = [pathToolbox,'/Data/intel.graph'];
    case 'Killian'
        dataFileGraph = [pathToolbox,'/Data/Killian.graph'];
    case '10K'
        dataFileGraph = [pathToolbox,'/Data/10K.graph'];
    case '10KHOGMan'
        dataFileGraph = [pathToolbox,'/Data/10KHOGMan.graph'];
    case 'VP'
        dataFileGraph = [pathToolbox,'/Data/VP.graph'];
    case 'sphere'
        dataFileGraph = [pathToolbox,'/Data/sphere.graph'];
    otherwise
        error('Dataset does not exist!');
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