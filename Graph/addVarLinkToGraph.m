function Graph=addVarLinkToGraph(factorR,Graph)

% The function adds new Variables and Links to the Graph
Graph.idX= [Graph.idX;factorR.data(1)];
Graph.F=[Graph.F;factorR];
row=factorR.data(1)+1;
col=factorR.data(2)+1;
Graph.Matrix(row,col)=1;
