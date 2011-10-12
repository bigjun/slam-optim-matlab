
function [x,info,res_v,error_v]=SPCG(A1,b1,A2,b2,maxIT,epsilon,subgraphSolver,startFromTree,plot_residual,mu)
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
    subgraphSolver='spcg';
end

if (nargin < 8)
    startFromTree=0;
end

if (nargin < 9)
    plot_residual=0;
end

if (nargin < 10)
    if plot_residual
        error('Error computation requires the mean');
    else
        mu=0;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve the tree

switch subgraphSolver
    case 'chol'
        ck=cputime;
        %ck=tic;
        R1 = chol2(A1'*A1);
        R1T=R1;
        xbar = R1\((R1T)\(A1'*b1));       
%         [R1, g, PT] = chol (A1'*A1, 'lower') ;
%         P=PT';
%         R1T=R1;
%         xbar= PT * (R1T \ (R1 \ (P * A1'*b1))) ;
         timeSolveTree=(cputime-ck);
        %timeSolveTree=toc(ck);%(cputime-ck);
    case 'spqr'
        %ck=cputime;
        ck=tic;
        [c1,R1,p] = spqr (A1,b1, struct('ordering','fixed')) ;
        xbar= R1\c1;
        R1=R1(1:n,1:n);
        R1T=R1';
        timeSolveTree=(cputime-ck);
        %timeSolveTree=toc(ck);%(cputime-ck);
    otherwise
        error('Direct Solver not implemented');
end

%%% spqr
[c1,R1,p] = spqr (A1,b1, struct('ordering','fixed')) ;
xbar= R1\c1; 
R1=R1(1:n,1:n);

%%%chol2, should switch to cholmod2 eventually..
% R1 = chol2(A1'*A1);
% xbar = R1\((R1')\(A1'*b1));




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialization
it=1;
b=[b1;b2];

if startFromTree
    % if we want to start with y0 other than zero
    tic;%ck=cputime;
    b2_bar=b2-A2*xbar;
    R1_t=R1';
		y = -R1*xbar;
		r1 = -y;
		r2 = b2_bar - A2*(R1\y);
		s = r1 + R1_t \ (r2'*A2)'; 
		p = s ;
		gamma = s' * s; 
		
		timeInit=toc;%(cputime-ck);
    threshold=epsilon^2*gamma *((norm(b)/norm(b2_bar))^2);% set the threshold
else
    ck=tic;%cputime;
    b2_bar=b2-A2*xbar;
    R1_t=R1';
    y=zeros(n,1);
		r1 = zeros(n,1);
		r2 = b2_bar ;
		s = R1_t \ (r2'*A2)'; 
		p = s ;
		gamma = s' * s; 
		
    timeInit=toc(ck);
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
    tStartIteration = tic;
    q = A2*(R1\p);
		alpha = gamma / (p'*p + q'*q);
		y = y + alpha * p;
		r1 = r1 - alpha * p;
		r2 = r2 - alpha * q;
		s = r1 + R1_t \ (r2'*A2)'; 
		new_gamma = s'*s; 
		beta = new_gamma / gamma;
		p = s + beta*p ;
    
    %stop condition
    done=((new_gamma<threshold)||(it >=maxIT));

		% prepare for next iteration
    gamma=new_gamma;
    timeIter = toc(tStartIteration);%(cputime-ck);
    timeIterations=timeIterations+timeIter;
    
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
    tic;%ck=cputime;
    timeSolution=toc;%(cputime-ck);
    res_v=res_v(1:it);
    info.res=res_v(it);
    error_v=error_v(1:it);
    info.error=error_v(it);
else
    tic;%ck=cputime;
    x=(R1\y+xbar);
    timeSolution=toc;%(cputime-ck);
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
