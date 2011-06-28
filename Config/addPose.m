function Config=addPose(factorR,Config)

% Config=addPose(factorR,Config)
% The script adds a new pose to the current Config
% Author: Viorela Ila

s1=factorR.data(2); % pose in the config
s2=factorR.data(1); % new pose
odo=factorR.data(3:5);

ndx1=[Config.PoseDim*Config.id2config((s1+1),1)+Config.LandDim*Config.id2config((s1+1),2)]+[1:Config.PoseDim]; %Change this formula

p1=Config.vector(ndx1,1);
d=InvertEdge(odo');
p2=Relative2Absolute(p1,d);

% update Config
Config.vector=[Config.vector;[p2,[1,1,1]']];
Config.size=size(Config.vector,1);
Config.ndx=Config.ndx+1;
Config.nPoses=Config.nPoses+1;
Config.id2config((s2+1),:)=[Config.nPoses,Config.nLands];