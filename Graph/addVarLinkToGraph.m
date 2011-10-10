function Graph=addVarLinkToGraph(factorR,Graph)

% The function adds 
Graph.idX= [Graph.idX;factorR.data(1)];
Graph.F=[Graph.F;factorR];

%Graph.Matrix=[Graph.Matrix;