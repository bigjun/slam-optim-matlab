function [Config,System,Solver]=LevenbergMarquardtOptimization(Config,System,Graph,Solver,Plot)

% [Config,System]=LevenbergMarquardtOptimization(Config,System,Graph,Solver,Plot)
% The script applyes Levenberg-Marquardt nonlinear optimization to a Graph SLAM problem
% Returns a new configuraton: Config and the relinearized system: System
% Author: Viorela Ila

if Plot.Error,Config.dmv=zeros(1,Solver.maxIT); end;
if Plot.DMV,Config.dmv=zeros(1,Solver.maxIT); end;
if Plot.Config, Config.all=zeros(Config.size,Solver.maxIT); end;


disp('Optimize...');

if 0
    % Konolige alg
    % initialization
    current_error=10000000;
    lambda_max=1e7;
    lambda=Solver.lambda;
    factor=10;
    System_new=System;
    
    steps_back=0;
    i=0;
    done=0;
    while ~done
        i=i+1;
        [S,v]=prepareSystem(System_new.A,System_new.b,lambda);
        %dm=spqr_solve(S,v);
        dm=S\v;
        if ((norm(dm)<Solver.tol)||(i>=Solver.maxIT))
            done=1;
        else
            Config_new=newConfig(Config,dm);
            System_new=linearSystem(Config_new,Graph,System_new);
            next_error=norm(System_new.b);  %norm(System_new.A*dm-System_new.b);
            if(next_error<=current_error)&& (lambda <= lambda_max)
                done =((current_error-next_error)<.005); % strange this is here
                fprintf('.');
                if mod(i,50)==0
                    fprintf('\n ');
                end
                Config=Config_new;
                current_error=next_error;
                System=System_new;
                %plots
                if Plot.DMV, Config.dmv(i)=norm(dm); end;
                if Plot.Error, Config.all_error(i)=current_error; end;%/norm(b); end;
                if Plot.Config, Config.all(:,i)=Config.vector(:,1); end;
                lambda=lambda/factor;
            else
                lambda=lambda*factor;
                steps_back=steps_back+1;
                fprintf('\n STEP BACK');
                
            end
        end
        
    end
    
else
    
    %g2o Alg.
    % initialization
    current_error=10000000;
    lambda_max=1e7;
    lambda=Solver.lambda;
    factor=10;
    System_new=System;
    
    steps_back=0;
    i=0;
    done=0;
    while ~done
        i=i+1;
        [S,v]=prepareSystem(System_new.A,System_new.b,lambda);
        %dm=spqr_solve(S,v);
        dm=S\v;
        if ((norm(dm)<Solver.tol)||(i>=Solver.maxIT))
            done=1;
        else
            Config_new=newConfig(Config,dm);
            System_new=linearSystem(Config_new,Graph,System_new);
            next_error=norm(System_new.b);  %norm(System_new.A*dm-System_new.b);
            if(next_error<=current_error)&& (lambda <= lambda_max)
                done =((current_error-next_error)<.005); % strange this is here
                fprintf('.');
                if mod(i,50)==0
                    fprintf('\n ');
                end
                Config=Config_new;
                current_error=next_error;
                System=System_new;
                %plots
                if Plot.DMV, Config.dmv(i)=norm(dm); end;
                if Plot.Error, Config.all_error(i)=current_error; end;%/norm(b); end;
                if Plot.Config, Config.all(:,i)=Config.vector(:,1); end;
                 lambda = lambda * max(1/3, 1.0-pow((2*rho-1), 3));
            else
                lambda=lambda*factor;
                steps_back=steps_back+1;
                fprintf('\n STEP BACK');
                
            end
        end
        
    end

steps_back
if Plot.Error,Config.all_error=Config.all_error(1:i);
else Config.all_error(i)=current_error;%/norm(b);
    
end;
if Plot.DMV,Config.dmv=Config.dmv(1:i);
else Config.dmv(i)=norm(dm);
end;
if Plot.Config, Config.all=Config.all(:,1:i);
else Config.all=Config.vector(:,1);
end;
fprintf('itterations %d\n',i);
end

function [S,v]=prepareSystem(A,b,lambda)
Atr=A';
H = Atr*A;
v = Atr*b;
D = diag(diag(H));
S =(H+lambda*D);
end



    





