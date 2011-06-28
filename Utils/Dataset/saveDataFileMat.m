function [G,A,b,ed,config]=saveDataFileMat(dataFileMat,dataSet,maxID,dim,weights_mode)


Eiffel_flag=0;
if strfind(dataSet,'Eiffel')
    Eiffel_flag=1;
end

saveFiles=0;
[vertices,undirectedArcs] = loadDataSet(dataSet,saveFiles);
[vert,ed] = cut2maxID(maxID,vertices,undirectedArcs);

%initialization
p0 = vertices(1,2:end)';
s0 = diag([undirectedArcs(1,6),undirectedArcs(1,8),undirectedArcs(1,9)]);
disp('Generate factor graph...')

if Eiffel_flag   
    % Form the graph from edges and vertices
    root=1;
    rows=ed(:,1)+1;
    cols=ed(:,2)+1;
    weights = ones(1, size(rows,1));
    DG = sparse(rows, cols, weights, size(vert,1), size(vert,1));
    UG = tril(DG + DG');
    
    % find a spanning tree
    
    tree =  graphmaxspantree(UG, root, 'Kruskal');
    [tree_edges, tree_vertices]=separateTreeConstraints(tree,ed,vert);
    
    % compose poses to form the initial config
    
    config=composePosesTree(tree_edges,dim,p0);
else
    config=InitialConfig(ed,dim,p0);
end

[A,b]=graph2FactorGraph(config,ed,dim,s0);

%'information','mutual_information','covariance',
%'distance','inverse_distance','identical'

disp('Compute weights...')
switch weights_mode
    case {'information','covariance','mutual_information'}
        Cov = getCovarianceFromJacobianMatrix(ed, dim, s0);
        G = generateGraph(vert,ed,weights_mode, Cov);
    case {'identical'} %'distance','inverse_distance' not used
        G = generateGraph(vert,ed,weights_mode);
    otherwise
        error('''weights_mode'' : {''information'',''covariance'',''mutual_information'',''identical''}\n')
end
save(dataFileMat,'G','A','b','ed','config','dim','weights_mode');