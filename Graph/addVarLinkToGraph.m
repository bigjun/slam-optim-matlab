function Graph=addVarLinkToGraph(factorR,Graph)

% The function adds new Variables and Links to the Graph
switch factorR.type
    case {'pose','pose3D','newLandmark','newLandmark3D'}
        Graph.idX= [Graph.idX;factorR.final];
        row=factorR.final+1;
        col=factorR.origine+1;
        factorR.RowCol=[row,col];
        Graph.F=[Graph.F;factorR];
        Graph.Matrix(row,col)=1;
    case {'loopClosure','loopClosure3D','landmark','landmark3D'}
        row=factorR.final+1;
        col=factorR.origine+1;
        factorR.RowCol=[row,col];
        Graph.F=[Graph.F;factorR];
        Graph.Matrix(row,col)=1;
    otherwise
        error('undefined factor type');
end