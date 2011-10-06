function [System, Graph]=addFactor( factorR, Config, System, Graph)

% [Config, System, Graph]=addFactor( factorR,Config, System, Graph)
% The script adds a new factor to the current representation: 
% Config, System and Graph
% Author: Viorela Ila
global Timing    
switch factorR.type
    case {'pose','loopClosure'}
        switch System.type
            case 'Hessian'
                System=addFactorPoseHessian(factorR,Config,System);
            case'CholFactor'
                System=addFactorPoseChol(factorR,Config,System);
            otherwise
                System=addFactorPose(factorR,Config,System);
        end
        Graph.idX= [Graph.idX;factorR.data(1)];
        %Graph.F=[Graph.F;factorR.data];
        Graph.F=[Graph.F;factorR];
    case {'landmark','newLandmark'}
        switch System.type
            case 'Hessian'
                System=addFactorLandmarkHessian(factorR,Config,System);
            case'CholFactor'
                System=addFactorLandmarkChol(factorR,Config,System);
            otherwise
                System=addFactorLandmark(factorR,Config,System);
        end
        Graph.idX= [Graph.idX;factorR.data(1)];
        %Graph.F=[Graph.F;factorR.data];
        Graph.F=[Graph.F;factorR];
    otherwise
        error('This type of factor is not handeled ')
end

