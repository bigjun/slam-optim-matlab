function Graph=getGraphFromData(Data,Graph)
% Gets graph from data
ind=1;
while ind<=Data.nEd
    factorR.data=Data.ed(ind,:);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
end