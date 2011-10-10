function [Config, System, Graph]=initialConfiguration(Data,Config,System,Graph)

%TODO check if we need this function
ind=1;
global Timing

Config=composePosesOdometry(Data,Config);
while ind<=Data.nEd
    factorR.data=Data.ed(ind,:);
    factorR=getDofRepresentation(factorR,Data.obsType);
    factorR=processFactor(factorR,Graph.idX);
    System=addFactor(factorR,Config,System);
    Graph=addVarLinkToGraph(factorR,Graph);
    ind=ind+1;
    
end