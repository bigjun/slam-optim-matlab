function [Config, System, Graph]=initialConfiguration(Data,Config,System,Graph)
ind=1;
global Timing
while ind<=Data.nEd
    factorR.data=Data.ed(ind,:);
    %factorR.dof=Data.dof;
    factorR.obsType=Data.obsType; % range and bering
    [Config, System, Graph]=addFactor(factorR,Config, System, Graph);
    ind=ind+1;

end