function Graph=getGraphFromData(Data,Graph)
% Gets graph from data
ind=1;
while ind<=Data.nEd
    factorR.data=Data.ed(ind,:);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
end


%TODO change to not use while:

% % Gets graph from data
% rows=Data.ed(:,1)+1;
% cols=Data.ed(:,2)+1;
% weights = ones(1, size(rows,1));
% DG = sparse(rows, cols, weights, size(vert,1), size(vert,1));
% Graph.Matrix = tril(DG + DG');
%  
% 
% %What about:     
% Graph.idX= [Graph.idX;factorR.data(1)];
% Graph.F=[Graph.F;factorR];