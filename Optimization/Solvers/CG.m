
function [x, info,res_v,error_v]=CG(A,b,maxIT,epsilon,initialization,plot_residual,mu)

% Least Squares Conjugate Gradient

n= size(A,2);
if (nargin < 2)
    error('Not enough input arguments.');
end

if (nargin < 3)
    maxIT=n;
end

if (nargin < 4)
    epsilon=0.01;
end

if (nargin < 5)
    initialization=zeros(n,1);
end

if (nargin < 6)
    plot_residual=0;
end

if (nargin < 7)
    if plot_residual
        error('Error computation requires the mean');
    else
        mu=0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialization

if plot_residual
    tic;%ck=cputime;
    x=initialization;
    g=-((b-A*x)'*A)';
    d=-g;
    it=1;
    gamma=g'*g;
    threshold=epsilon^2*gamma ;
    timeInit=toc;%(cputime-ck);
else
    tic;%ck=cputime;
    x=initialization;
    g=-(b'*A)';
    d=-g;
    it=1;
    gamma=g'*g;
    threshold=epsilon^2*gamma ;
    timeInit=toc;%(cputime-ck);
end

% needed to compute residual and error
nb=norm(b);
if plot_residual
    res_v=zeros(maxIT,1);
    error_v=zeros(maxIT,1);
    res_v(it)=norm(b-A*x)/nb;
    error_v(it)=(x-mu)'*(A'*(A*(x-mu)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iterations
done=false;
timeIterations=0;
while  ~done
    tic;%ck=cputime;
    %calculate step size and take optimal step
    Ad=A*d; 
    %alpha=-(d'*g)/(Ad'*Ad);
    alpha=gamma/(Ad'*Ad);
    x=x+alpha*d;
    
    %update gradient
    g=g+alpha*(Ad'*A)';
    new_gamma=g'*g;
    
    %stop condition
    done=((new_gamma<threshold)||(it >=maxIT));
    
    %calculate new search direction
    beta=new_gamma/gamma;
    d=-g+beta*d;
    
    % prepare for next iteration
    gamma=new_gamma;
    timeIter = toc;%(cputime-ck);
    timeIterations=timeIterations+timeIter;
    it=it+1;
    
    if plot_residual
        res_v(it)=norm(b-A*x)/nb;
        error_v(it)=(x-mu)'*(A'*(A*(x-mu)));
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%solution + residual + error
%These two are the same x=R1\(y+Q1'* b1) and x=R1\(y+R1*xbar);

if plot_residual
    res_v=res_v(1:it);
    info.res=res_v(it);
    error_v=error_v(1:it);
    info.error=error_v(it);
else
    info.res=norm(b-A*x)/nb;
    % if not plot_residual
    res_v=[];
    error_v=[];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% info
info.timeInit=timeInit;
info.timeIterations=timeIterations;
info.time=timeInit + timeIterations;
info.it=it;

