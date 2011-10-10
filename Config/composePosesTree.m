function [Config]=composePosesTree(Data,Config)
% TODO make it work for 3D 
ndx=1:Config.PoseDim;
Data.nEdTree=size(Data.edTree,1);

Config.vector(ndx,:)=[Config.p0,ones(Config.PoseDim,1)]; %init config
Config.id2config=zeros(Data.nVert,2); % variable id to position in the config vector converter
Config.id2config(Data.edTree(1,2)+1,:)=[Config.nPoses,Config.nLands];

list1 = zeros(Data.nEdTree+1,1);
list1(1)=0; % we know we start from 0
len1 = 1; % length of the list of visited edges

list2=[(1:Data.nEdTree)',Data.edTree(:,1:2)];
nl2=size(list2,1);

while nl2
    i2=1;
    while i2<=nl2
        s0=list2(i2,1);
        s1=list2(i2,3);
        s2=list2(i2,2);
        current=s1; % one endpoint
        base=(find(current==list1));
        factorR.data=Data.edTree(s0,:);
        factorR=getDofRepresentation(factorR,Data.obsType);
        if base
            switch factorR.type
                case {'pose','loopClosure'}
                    Config=addPose(factorR,Config);
                case {'landmark','newLandmark'}
                    Config=addLandmark(factorR,Config);
            end
            % add to list1 and delete from list2
            list1(len1+1) = s2;
            len1 = len1 + 1;
            list2(i2,:)=[]; % remove edge from list2
            nl2 = nl2-1; % reduce the length of list2 by 1
        else
            current=list2(i2,2); % look at the other endpoint of current edge
            base=(find(current==list1)); % check if I have visited it already
            if base
                switch factorR.type
                    case {'pose','loopClosure'}
                        d=InvertEdgePose(Data.edTree(s0,3:5)')';
                        factorR.data=[Data.edTree(s0,2:-1:1),d,Data.edTree(s0,6:end)];
                        Config=addPose(factorR,Config);
                    case {'landmark','newLandmark'}
                        d=InvertEdgeLandmark(Data.edTree(s0,3:4)',Data.obsType,Config.PoseDim)';
                        factorR.data=[Data.edTree(s0,2:-1:1),d,Data.edTree(s0,5:end)]; %TODO change acording to the LandDim
                        Config=addLandmark(factorR,Config);
                end
                % add to list1 and delete from list2
                list1(len1+1) = s1;
                len1 = len1 + 1;
                list2(i2,:)=[]; % remove edge from list2
                nl2 = nl2-1; % reduce the length of list2 by 1
            else
                i2=i2+1; % if edge is not connected to any of the visited vertices, skip it
            end
        end
        
    end
    nl2=size(list2,1); % look at the remaining edges
end