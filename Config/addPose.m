function Config=addPose(factorR,Config)

% Config=addPose(factorR,Config)
% The script adds a new pose to the current Config
% Author: Viorela Ila

% process indexes
s1=factorR.data(2); % pose in the config
s2=factorR.data(1); % new pose
ndx1=[Config.PoseDim*Config.id2config((s1+1),1)+Config.LandDim*Config.id2config((s1+1),2)]+[1:Config.PoseDim]; %Change this formula

p1.config=Config.vector(ndx1,1);
switch factorR.dof
    case 3
        odo=factorR.data(3:5);
        d=InvertEdge(odo');
        p2=Relative2Absolute(p1.config,d);
    case 6
        % TODO to be moved to processFactor. only processed factors in the
        % Graph!
        p1.pose=p1.config(1:3);
        ypr=p1.config(4:6);
        p1.Q=ypr2Q(ypr);
        d=factorR.data(3:end); % TODO This must depend on factorR.
        p2=Relative2Absolute3D(p1,d); %TODO verify Relative2Absolute3D
    otherwise
        error('Cannot add this data dof')
end

% update Config
Config.vector=[Config.vector;[p2,ones(factorR.dof,1)]];
Config.size=size(Config.vector,1);
Config.ndx=Config.ndx+1;
Config.nPoses=Config.nPoses+1;
Config.id2config((s2+1),:)=[Config.nPoses,Config.nLands];