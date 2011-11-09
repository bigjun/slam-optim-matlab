function Config=initConfig(Data)

% get the pose and landmark DOF
isLandmark=find(Data.ed(:,end)==99999);
if isLandmark
    dofL=getDofRepresentation(Data.ed(isLandmark(1),:));
    Config.LandDim=dofL;   % landmark size
    dofP=getDofRepresentation(Data.ed(1,:));
    Config.PoseDim=dofP;   % pose size
else
    dofP=getDofRepresentation(Data.ed(1,:));
    Config.PoseDim=dofP;   % pose size
    Config.LandDim=0;
end
if Config.PoseDim >3
    et=Data.vert(1,2:4)';
    eq=Data.vert(1,5:end)';
    Config.p0 = [et;arot(q2R(eq))];
    U = Data.ed(1,10:end);
    Config.s0 = inv(getCovFromData(U, 6)); % TODO chec if this cov need to be transformed to cov of axix
else
    Config.p0 = Data.vert(1,2:end)'; % prior
    Config.s0 = diag([Data.ed(1,6),Data.ed(1,8),Data.ed(1,9)]); % noise on prio
end
Config.ndx=0;       % config index
Config.nPoses=0;    % number of poses 
Config.nLands=0;    % number of landmarks
Config.id2config=zeros(Data.nVert,2); % variable id to position in the config vector converter
Config.id2config(Data.vert(1,1)+1,:)=[Config.nPoses,Config.nLands];
Config.vector=[Config.p0,ones(Config.PoseDim,1)]; % the second column is used for rapid identification of the landmark=0 vs pose=1
Config.size=size(Config.vector,1);