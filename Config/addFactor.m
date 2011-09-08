function [Config, System, Graph]=addFactor( factorR,Config, System, Graph)

% [Config, System, Graph]=addFactor( factorR,Config, System, Graph)
% The script adds a new factor to the current representation: 
% Config, System and Graph
% Author: Viorela Ila
global Timing
      
[factorR,isPose]=getDofRepresentation(factorR);

if isPose
    if factorR.data(2)>factorR.data(1)
        % in this case we need to invert the edge
        factorR.data(1:2)=factorR.data(2:-1:1);
        factorR.data(3:5)=InvertEdge(factorR.data(3:5)')';
    end
    if (ismember(factorR.data(2),Graph.idX))
        if(ismember(factorR.data(1),Graph.idX))
            factorR.type='loopClosure';
        else
            factorR.type='odometric';
        end
    else
        error('Disconnected graph!!')
    end
    
else
    if(ismember(factorR.data(1),Graph.idX))
        factorR.type='landmark';
    else
        factorR.type='new_landmark';
    end
end

factorR=processFactor(factorR);

switch factorR.type
    
    case 'odometric'   
        Config=addPose(factorR,Config); 
        if strcmp(System.type,'Hessian')
            System=addFactorPoseHessian(factorR,Config,System);
        elseif strcmp(System.type,'CholFactor');
            System=addFactorPoseChol(factorR,Config,System);
        else
            System=addFactorPose(factorR,Config,System);
        end
        Graph.idX= [Graph.idX;factorR.data(1)];
        %Graph.F=[Graph.F;factorR.data];
        Graph.F=[Graph.F;factorR];
        
    case 'loopClosure'
        if strcmp(System.type,'Hessian')
            System=addFactorPoseHessian(factorR,Config,System);
        elseif strcmp(System.type,'CholFactor');
            System=addFactorPoseChol(factorR,Config,System);
        else
            System=addFactorPose(factorR,Config,System);
        end
        %Graph.F=[Graph.F;factorR.data];
        Graph.F=[Graph.F;factorR];
        
    case 'new_landmark'
        Config=addLandmark(factorR,Config);
        if strcmp(System.type,'Hessian')
            System=addFactorLandmarkHessian(factorR,Config,System);
        elseif strcmp(System.type,'CholFactor');
            System=addFactorLandmarkChol(factorR,Config,System);
        else
            System=addFactorLandmark(factorR,Config,System);
        end
        Graph.idX= [Graph.idX;factorR.data(1)];
        %Graph.F=[Graph.F;factorR.data];
        Graph.F=[Graph.F;factorR];
        
    case 'landmark'
        if strcmp(System.type,'Hessian')
            System=addFactorLandmarkHessian(factorR,Config,System);
        elseif strcmp(System.type,'CholFactor');
            System=addFactorLandmarkChol(factorR,Config,System);
        else
            System=addFactorLandmark(factorR,Config,System);
        end
        %Graph.F=[Graph.F;factorR.data];
        Graph.F=[Graph.F;factorR];
    otherwise
        error('This type of factor is not handeled ')
end

