function Config=initConfig(Data)

% get the pose and landmark DOF
isLandmark=find(Data.ed(:,end)==99999);
if isLandmark
    landmark.data=Data.ed(isLandmark(1),:);
    landmark=getDofRepresentation(landmark,Data.obsType);
    Config.LandDim=landmark.dof;   % landmark size
    pose.data=Data.ed(1,:);
    pose=getDofRepresentation(pose);
    Config.PoseDim=pose.dof;   % pose size
else
    pose.data=Data.ed(1,:);
    pose=getDofRepresentation(pose);
    Config.PoseDim=pose.dof;   % pose size
    Config.LandDim=0;
end

Config.p0 = Data.vert(1,2:end)'; % prior
Config.s0 = diag([Data.ed(1,6),Data.ed(1,8),Data.ed(1,9)]); % noise on prio

Config.ndx=0;       % config index
Config.nPoses=0;    % number of poses 
Config.nLands=0;    % number of landmarks
Config.id2config=zeros(Data.nVert,2); % variable id to position in the config vector converter
Config.id2config(Data.vert(1,1)+1,:)=[Config.nPoses,Config.nLands];
Config.vector=[Config.p0,ones(Config.PoseDim,1)]; % the second column is used for rapid identification of the landmark=0 vs pose=1
Config.size=size(Config.vector,1);