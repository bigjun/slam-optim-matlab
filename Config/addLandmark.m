function Config=addLandmark(factorR,Config)

% Config=addPose(factorR,Config)
% The script adds a new landmark to the current Config
% Author: Viorela Ila

s1=factorR.origine; % pose in the config
s2=factorR.final; % new landmark

switch factorR.type
    case 'landmark'
        switch factorR.obsType
            case 'rb'
                r=factorR.measure(1);
                b=factorR.measure(2);
                dxl=r*cos(b);
                dyl=r*sin(b);
            case 'dxdy'
                dxl=factorR.measure(1);
                dyl=factorR.measure(2);
            otherwise
                error('unknown observation type');
        end
    case'landmark3D'
        error('Add 3D landmark not implemented'); %TODO implement add 3D landmark
    otherwise
        error('unknown factor type');
end

ndx1=[Config.PoseDim*Config.id2config((s1+1),1)+Config.LandDim*Config.id2config((s1+1),2)]+[1:Config.PoseDim];

P1=Config.vector(ndx1,1);
pRel=[dxl;dyl];
pWorld=RelativePoint2AbsolutePoint(P1,pRel);

% update Config
Config.vector=[Config.vector;[pWorld,[0,0]']];
Config.size=size(Config.vector,1);
Config.ndx=Config.ndx+1;
Config.nLands=Config.nLands+1;
Config.id2config((s2+1),:)=[Config.nPoses,Config.nLands];


