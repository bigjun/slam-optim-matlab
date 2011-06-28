function [Config,System]=GaussNewtonOptimizationCHOL(Config,System,Graph,Solver,Plot)

% [Config,System]=GaussNewtonOptimization(Config,System,Graph,Solver,Plot)
% The script applyes Gauss-Newton nonlinear optimization to a Graph SLAM problem
% Returns a new configuraton: Config and the relinearized system: System
% Author: Viorela Ila

i=1;
if Plot.Error,Config.dmv=zeros(1,Solver.maxIT); end;
if Plot.DMV,Config.dmv=zeros(1,Solver.maxIT); end;
if Plot.Config, Config.all=zeros(Config.size,Solver.maxIT); end;


done=(i>=Solver.maxIT);
disp('Optimize...');

while ~done
    %dm=spqr_solve(System.A,System.b,struct('ordering','colamd'));
    [S,v]=prepareSystem(System.A,System.b,Solver.lambda); 
    dm=S\v;

    %plots
    if Plot.DMV, Config.dmv(i)=norm(dm); end;
    if Plot.Error, Config.all_error(i)=norm(System.A*dm-System.b); end;%/norm(b); end;
    if Plot.Config, Config.all(:,i)=Config.vector(:,1); end;
    
    done=((norm(dm)<Solver.tol)||(i>=Solver.maxIT));
    if ~done     
        Config=newConfig2D(Config,dm);
        System=linearSystem(Config,Graph,System);
        i=i+1;     
    end
    fprintf('.');
    %fprintf('%f\n',norm(dm));
    if mod(i,10)==0
        fprintf('itterations %d\n',i);
    end
end
fprintf('itterations %d\n',i);
norm(dm)

if Plot.Error,Config.all_error=Config.all_error(1:i);
else Config.all_error(i)=norm(System.A*dm-System.b);%/norm(b);
end;
if Plot.DMV,Config.dmv=Config.dmv(1:i);
else Config.dmv(i)=norm(dm);
end;
if Plot.Config, Config.all=Config.all(:,1:i);
else Config.all=Config.vector(:,1);
end;
fprintf('\n');
end

function [S,v]=prepareSystem(A,b,lambda)
Atr=A';
H = Atr*A;
v = Atr*b;
D = diag(diag(H));
S =(H+lambda*D);
end





