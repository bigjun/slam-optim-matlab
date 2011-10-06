function [Config, System, Graph]=initialConfiguration(Data,Config,System,Graph)
ind=1;
global Timing
if Data.edTree   
    [Config]=composePosesTree(Data,Config);
else  
    [Config]=composePosesOdometry(Data,Config);
end 
while ind<=Data.nEd
    factorR=processFactor(ind,Data,Graph);
    [System, Graph]=addFactor(factorR,Config,System, Graph);
    ind=ind+1;

end