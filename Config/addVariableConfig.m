function Config=addVariableConfig(factorR,Config)

% Config=addVariableConfig(factorR,Config,Graph)
% It adds the variable to the Config if it is not in the Graph.idX
% Author: Viorela Ila
  
switch factorR.type
    case {'pose','loopClosure','pose3D', 'loopClosure3D'}
        if factorR.origine>factorR.final
            % in this case we need to invert the edge
            disp('InvertEdge');
            final=factorR.final;
            origine=factorR.origine;
            factorR.origine=final;
            factorR.final=origine;
            switch factorR.type
                case {'pose','loopClosure'}
                    factorR.measure=InvertEdgePose(factorR.measure')';
                case {'pose3D','loopClosure3D'}
                    factorR.measure=InvertEdgePose3D(factorR.measure')';
            end
        end
        if strcmp(factorR.type,'pose')||strcmp(factorR.type,'pose3D')
            Config=addPose(factorR,Config);
        end
        
%         if (ismember(factorR.origine,idX))
%             if~(ismember(factorR.final,idX))
%                 Config=addPose(factorR,Config);
%             end
%         else
%             error('Disconnected pose!!')
%         end
        
    case {'landmark','newLandmark','landmark3D'}
        if strcmp(factorR.type,'newLandmark')||strcmp(factorR.type,'newLandmark3D')
            Config=addLandmark(factorR,Config);
        end
%         if (ismember(factorR.origine,idX))
%             if~(ismember(factorR.final,idX))
%                 Config=addLandmark(factorR,Config);
%             end
%         else
%             error('Disconnected landmark!!')
%         end
end

