% test range-only slam

% lienar case
%clear all
close all

[range,vertices,buoy,sigInit,sigState,sigBias,sigObs,dt,A]=generateDataPseudoRange;
RState = chol(inv(diag(sigState)));
RObs = chol(inv(diag(sigObs))); %sqrt(1/sigObs);
RInit = chol(inv(diag(sigInit)));
RBias = chol(inv(diag(sigBias)));

maxIT = 10;
tol = 10e-4;
disp('Optimize...');

m = size(range,1);
nd = size(vertices,1);
nb = size(buoys,1);

% Constant velocity
dim = 7; % 3DOF pose + 3DOF velocity + 1DOF clock bias
dimb = 3;
poses = vertices(:,2:end); % clock bias included as last element 


plot3(poses(:,1),poses(:,2),poses(:,3), 'g')
hold on,
plot3 (buoys(:,1),buoys(:,2),buoys(:,3),'g*')
grid on
T = get(gca,'tightinset');
set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);

%p = reshape(poses',size(poses,1)*size(poses,2),1);
%b = reshape(buoy',12 ,1);
%x = [p;b];

% Nonlinear solver
it = 1;
done=(it>=maxIT);
norm_dm=[];
while ~done
    % solve linear system
    [J,d] = linearSystemPseudoRange(range,poses,buoy,RInit,RState,RBias,RObs,dim,dimb,A,nd,nb);
    rcond(J'*J) % test the condition 
    dm = J\d;
    
    dp = reshape(dm(1:end-nb*dimb),dim,nd)';
    db = reshape(dm((end-nb*dimb+1):end),dimb,nb)';
    %x=x+dm;
    poses = poses + dp;
    buoys = buoys + db;
    
    norm_dm=[norm_dm,norm(dm)];% debug only
    done=((norm_dm(it)<tol)||(it>=maxIT));
    %norm(dm)
    if ~done
        it=it+1
    end
end
%pOpt = reshape(x(1:end-12),dim,nd)';
%bOpt = reshape(x((end-11):end),dimb,4)';

plot3(poses(:,1),poses(:,2),poses(:,3), 'm')
hold on,
plot3 (buoys(:,1),buoys(:,2),buoys(:,3),'m*')

figure;
plot(norm_dm)

