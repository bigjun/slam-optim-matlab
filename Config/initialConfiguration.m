function [Config, System, Graph]=initialConfiguration(Data,Config,System,Graph)

%TODO check if we need this function
ind=1;
global Timing

Config=composePosesOdometry(Data,Config);
while ind<=Data.nEd
    factorR=processEdgeData(Data.ed(ind,:),Data.obsType,Graph.idX);
    System=addFactor(factorR,Config,System);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
end