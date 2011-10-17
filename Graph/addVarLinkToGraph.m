function Graph=addVarLinkToGraph(factorR,Graph)

% The function adds new Variables and Links to the Graph
Graph.idX= [Graph.idX;factorR.final];
row=factorR.final+1;
col=factorR.origine+1;
factorR.RowCol=[row,col];
Graph.F=[Graph.F;factorR];
Graph.Matrix(row,col)=1;
