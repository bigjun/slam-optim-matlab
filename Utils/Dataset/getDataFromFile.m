function Data=getDataFromFile(dataSet,pathToolbox,saveFile,maxID)

% getDataFromFile
% The script gets data from datafile and returns Data structure
[vertices,edges]=loadDataSet(dataSet,pathToolbox,saveFile);
if strcmp(dataSet,'10KHOGMan')
    % Incremental feed for edges
    edges=sortrows(edges,[1,-2]); %TODO Change the dataset so that the edges come incrementaly
end
[Data.vert, Data.ed]=cut2maxID(maxID, vertices, edges);
clear vertices edges;
Data.nVert=size(Data.vert,1);
Data.nEd=size(Data.ed,1);
Data.name=dataSet;



