function Config=addVariableConfig(factorR,Config,idX)

% Config=addVariableConfig(factorR,Config,Graph)
% It adds the variable to the Config if it is not in the Graph.idX
% Author: Viorela Ila
  
switch factorR.type
    case {'pose','loopClosure'} 
        if factorR.data(2)>factorR.data(1)
            % in this case we need to invert the edge
            factorR.data(1:2)=factorR.data(2:-1:1);
            factorR.data(3:5)=InvertEdge(factorR.data(3:5)')';
        end
        if (ismember(factorR.data(2),idX))
            if~(ismember(factorR.data(1),idX))
                Config=addPose(factorR,Config);
            end
        else
            error('Disconnected pose!!')
        end
        
    case {'landmark','newLandmark'}
        if (ismember(factorR.data(2),idX))
            if~(ismember(factorR.data(1),idX))
                Config=addLandmark(factorR,Config);
            end
        else
            error('Disconnected landmark!!')
        end
end