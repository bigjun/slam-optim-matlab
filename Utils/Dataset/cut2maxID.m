function [vert, ed]=cut2maxID(maxID,varargin)
% cuts the graph to maxID and add some new set of indexes

% load graph from file
if ischar(varargin{1})
    dataFile=varargin{1};
    if maxID
        graphFileMat=cat(2,dataFile,'graph',num2str(maxID),'.mat');
    else
        graphFileMat=cat(2,dataFile,'graph','.mat');
    end
    % read the file
    if exist(graphFileMat,'file')
        load(graphFileMat);
        disp('Loading variables from file ...')
    else
        error('No such file or directory');
    end
else
    vertices=varargin{1};
    edges=varargin{2};
end

nv = size(vertices,1);
if (maxID==0) || (maxID>nv)
    maxID = nv;
end

[srtVert,order] = sort(vertices(1:maxID),'ascend');
goodIndices = ismember(edges(:,1),srtVert)&ismember(edges(:,2),srtVert); % +1 needed because old labels start at 0
ed = edges(goodIndices,:);
vert=vertices(order,:);

% %map to new labels
% 
% maxLabel = srtVert(maxID); %
% invVert = spalloc(maxLabel+1,1, maxID);
% invVert(srtVert+1) = order;
% 
% goodIndices = ismember(edges(:,1),srtVert)&ismember(edges(:,2),srtVert); % +1 needed because old labels start at 0
% ed = [invVert(edges(goodIndices,1)+1), ...
%     invVert(edges(goodIndices,2)+1), ...
%     edges(goodIndices,:)];
% vert=[invVert(srtVert+1),vertices(order,:)];
    
