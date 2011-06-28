function [Config, System, Solver]=nonlinearOptimization(Config,System,Graph,Solver,Plot)   

% [Config,System]=nonlinearOptimization(Config,System,Graph,Solver,Plot)
% The script selects the nonlinear optimization method 
% Returns a new configuraton: Config and the relinearized system: System
% Author: Viorela Ila

switch Solver.nonlinearSolver
    case 'GaussNewton'
        [Config, System, Solver]=GaussNewtonOptimization(Config,System,Graph,Solver,Plot);
    case 'LevenbergMarquardt'
        [Config, System, Solver]=LevenbergMarquardtOptimization(Config,System,Graph,Solver,Plot);
    otherwise
        error('This method is not implemented');
end