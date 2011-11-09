function Config=addPose(factorR,Config)

% Config=addPose(factorR,Config)
% The script adds a new pose to the current Config
% Author: Viorela Ila

% process indexes
s1=factorR.origine; % pose in the config
s2=factorR.final; % new pose
ndx1=[Config.PoseDim*Config.id2config((s1+1),1)+Config.LandDim*Config.id2config((s1+1),2)]+[1:Config.PoseDim]; %Change this formula

p1.config=Config.vector(ndx1,1);
switch factorR.type
    case 'pose'
        odo=factorR.measure;
        d=InvertEdge(odo');
        p2=Relative2Absolute(p1.config,d);
    case 'pose3D'
        d=factorR.measure';
        p2=Relative2Absolute3D(p1.config,d); %TODO verify Relative2Absolute3D

    otherwise
        error('Cannot add this pose type')
end

% update Config
Config.vector=[Config.vector;[p2,ones(factorR.dof,1)]];
Config.size=size(Config.vector,1);
Config.ndx=Config.ndx+1;
Config.nPoses=Config.nPoses+1;
Config.id2config((s2+1),:)=[Config.nPoses,Config.nLands];