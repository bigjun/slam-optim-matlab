
function [x,info,res_v,error_v]=SPCG(A1,b1,A2,b2,maxIT,epsilon,startFromTree,plot_residual,mu)
% Subgraph Preconditioned Conjugate Gradient

n= size(A1,2);
if (nargin < 4)
    error('Not enough input arguments.');
end

if (nargin < 5)
    maxIT=n;
end

if (nargin < 6)
    epsilon=0.01;
end

if (nargin < 7)
    startFromTree=0;
end

if (nargin < 8)
    plot_residual=0;
end

if (nargin < 9)
    if plot_residual
        error('Error computation requires the mean');
    else
        mu=0;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve the tree
ck=cputime;
[c1,R1,p] = spqr (A1,b1, struct('ordering','fixed')) ;
xbar= R1\c1; 
R1=R1(1:n,1:n);
timeSolveTree=(cputime-ck);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialization
it=1;
b=[b1;b2];
if startFromTree
    % if we want to start with y0 other than zero
    ck=cputime;
    b2_bar=b2-A2*xbar;
    R1_t=R1';
    y=-R1*xbar;
    %tmp= R1_t\A2'; 
    %g=y+tmp*(tmp'*y-b2_bar);
    
    %memory efficient
    g= y + R1_t\((A2*(R1\y)-b2_bar)'*A2)';
    
    gamma=g'*g;
    d=-g;
    timeInit=(cputime-ck);
    threshold=epsilon^2*gamma *((norm(b)/norm(b2_bar))^2);% set the threshold
else
    ck=cputime;
    b2_bar=b2-A2*xbar;
    R1_t=R1';
    y=zeros(n,1);
    g=-(R1_t\(b2_bar'*A2)');
    gamma=g'*g;
    d=-g;
    timeInit=(cputime-ck);
    threshold=epsilon^2*gamma *((norm(b)/norm(b2_bar))^2);% set the threshold
end

% needed to compute residual and error
nb=norm(b);
A=[A1;A2];
if plot_residual
    res_v=zeros(maxIT,1);
    error_v=zeros(maxIT,1);
    x=(R1\y+xbar);
    res_v(it)=norm(b-A*x)/nb;
    error_v(it)=(x-mu)'*(A'*(A*(x-mu)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iterations
done=false;

timeIterations=0;
while  ~done
    ck=cputime;
    %calculate step size and take optimal step
    Ad=A2*(R1\d);
    %alpha=-(d'*g)/(d'*d + Ad'*Ad); % can be simplified!!! 
    alpha=gamma/(d'*d + Ad'*Ad); 
    y=y+alpha*d;
    
    %update gradient
    g=g+alpha*(d+R1_t\(Ad'*A2)');
    new_gamma=g'*g;
    
    %stop condition
    done=((new_gamma<threshold)||(it >=maxIT));
    
    %calculate new search direction
    beta=new_gamma/gamma;
    d=-g+beta*d;
    
    % prepare for next iteration
    gamma=new_gamma;
    timeIterations=timeIterations+(cputime-ck);
    
    it=it+1;
    
    if plot_residual
        x=(R1\y+xbar);
        res_v(it)=norm(b-A*x)/nb;
        error_v(it)=(x-mu)'*(A'*(A*(x-mu)));
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%info solution + residual + error
%These two are the same x=R1\(y+Q1'* b1) and x=R1\(y+R1*xbar);

if plot_residual
    ck=cputime;
    timeSolution=(cputime-ck);
    res_v=res_v(1:it);
    info.res=res_v(it);
    error_v=error_v(1:it);
    info.error=error_v(it);
else
    ck=cputime;
    x=(R1\y+xbar);
    timeSolution=(cputime-ck);
    info.res=norm(b-A*x)/nb;
    % if not plot_residual
    res_v=[];
    error_v=[];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%info time +it
info.timeSolveTree=timeSolveTree;
info.timeInit=timeInit;
info.timeIterations=timeIterations;
info.timeSolution=timeSolution;
%info.time=timeSolveTree + timeInit + timeIterations + timeSolution;
info.time=timeSolveTree + timeIterations;
info.it=it;

%tree solution
info.treeSolution=xbar; % this is needed when comparing with GC


% res=norm(b-A*x)/nb;
% if plot_residual
%     info.y_v=y_v(:,1:it);
% end
% 
% if plot_residual && it
%     info.x_v=R1\info.y_v+repmat(xbar,1,it);
%     
%     info.res_v=sqrt(sum((repmat(b,1,it)-A*info.x_v).^2))/nb;
% end
