function [Config,System,Solver]=GaussNewtonOptimization(Config,System,Graph,Solver,Plot)

% [Config,System]=GaussNewtonOptimization(Config,System,Graph,Solver,Plot)
% The script applyes Gauss-Newton nonlinear optimization to a Graph SLAM problem
% Returns a new configuraton: Config and the relinearized system: System
% Author: Viorela Ila

global Timing
i=1;
if Plot.Error,Config.dmv=zeros(1,Solver.maxIT); end;
if Plot.DMV,Config.dmv=zeros(1,Solver.maxIT); end;
if Plot.Config, Config.all=zeros(Config.size,Solver.maxIT); end;


done=(i>=Solver.maxIT);
disp('Optimize...');

while ~done
    [dm,time_solve]=solveSystem(System); 
    if Timing.flag
        Timing.linearSolver=Timing.linearSolver+time_solve;
        Timing.linearSolverCnt=Timing.linearSolverCnt+1;
    end
    %plots
    if Plot.DMV, Config.dmv(i)=norm(dm); end;
    if Plot.Error, Config.all_error(i)= computeError(System,dm); end;
    if Plot.Config, Config.all(:,i)=Config.vector(:,1); end;
    
    done=((norm(dm)<Solver.tol)||(i>=Solver.maxIT));
    norm(dm)
    if ~done     
        Config=newConfig(Config,dm);
        ck=cputime;
        System=linearSystem(Config,Graph,System);
        if Timing.flag
            Timing.linearization=Timing.linearization+(cputime-ck);
            Timing.linearizationCnt=Timing.linearizationCnt+1;
        end
        i=i+1;     
    end
    fprintf('.');
    %fprintf('%f\n',norm(dm));
    if mod(i,10)==0
        fprintf('itterations %d\n',i);
    end
end


fprintf('itterations %d\n',i);


if Plot.Error,Config.all_error=Config.all_error(1:i);
else Config.all_error(i)=computeError(System,dm);%/norm(b);
end;
if Plot.DMV,Config.dmv=Config.dmv(1:i);
else Config.dmv(i)=norm(dm);
end;
if Plot.Config, Config.all=Config.all(:,1:i);
else Config.all=Config.vector(:,1);
end;
fprintf('\n');





