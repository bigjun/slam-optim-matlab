function Config=addVariableConfig(factorR,Config,idX)

% Config=addVariableConfig(factorR,Config,Graph)
% It adds the variable to the Config if it is not in the Graph.idX
% Author: Viorela Ila
  
switch factorR.type
    case {'pose','loopClosure'} 
        if factorR.origine>factorR.final
            % in this case we need to invert the edge
            factorR.origine=final;
            factorR.final=origine;
            factorR.measure=InvertEdge(factorR.measure')';
        end
        if (ismember(factorR.origine,idX))
            if~(ismember(factorR.final,idX))
                Config=addPose(factorR,Config);
            end
        else
            error('Disconnected pose!!')
        end
        
    case {'landmark','newLandmark'}
        if (ismember(factorR.origine,idX))
            if~(ismember(factorR.final,idX))
                Config=addLandmark(factorR,Config);
            end
        else
            error('Disconnected landmark!!')
        end
end