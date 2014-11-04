    % test range-only slam

% lienar case         
%clear all
close all
method = 'cv';
% cv - constant velocity
% icv - incremental constant velocity
% ba - bundle adjustment (no motion model)
% ca - constant acceleration
% ica - incremental constant acceleration

[range,vd,buoy,sigInit,sigState,sigObs,dt,nd,A,diver]=generateData;
RState = chol(inv(diag(sigState)));
RObs = chol(inv(diag(sigObs))); %sqrt(1/sigObs);
RInit = chol(inv(diag(sigInit)));

maxIT = 3;
tol = 10e-4;
disp('Optimize...');


switch method
    
    case 'cv'
        % Constant velocity
        dim = 6;
        dimb = 3;
        poses = vd(:,2:end);
        
        plot3(poses(:,1),poses(:,2),poses(:,3), 'g')
        hold on,
        plot3 (buoy(:,1),buoy(:,2),buoy(:,3),'g*')
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
            [J,d] = linearSystemROslam(nd, dim, dimb, A, poses,buoy, range, RInit, RState, RObs);
            dm = J\d;
            dp = reshape(dm(1:end-12),dim,nd)';
            db = reshape(dm((end-11):end),dimb,4)';
            %x=x+dm;
            poses = poses + dp;
            buoy = buoy + db;
            
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
        plot3 (buoy(:,1),buoy(:,2),buoy(:,3),'m*')
        
        figure;
        plot(norm_dm)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'ba'
        dim = 3;
        dimb = 3;
        poses = vd(:,2:4);
        %                 p = reshape(poses,size(poses,1)*size(poses,2),1);
        %         b = reshape(buoy,12 ,1);
        %         x = [p;b];
        %
        % Nonlinear solver
        it = 1;
        done=(it>=maxIT);
        norm_dm=[];
        while ~done
            % solve linear system
            [J,d] = linearSystemROslamBA(nd, dim, dimb, poses,buoy, range, RInit, RObs);
            dm = J\d;
            dp = reshape(dm(1:end-12),dim,nd)';
            db = reshape(dm((end-11):end),dimb,4)';
            %x=x+dm;
            poses = poses + dp;
            buoy = buoy + db;
            
            norm_dm=[norm_dm,norm(dm)];% debug only
            done=((norm_dm(it)<tol)||(it>=maxIT));
            %norm(dm)
            if ~done
                it=it+1
            end
        end
        
        plot3(poses(:,1),poses(:,2),poses(:,3), 'm')
        hold on,
        plot3 (buoy(:,1),buoy(:,2),buoy(:,3),'m*')
        
        difflast = poses(end-3:end)-diver(end,:)'
        
%         figure;
%         plot(norm_dm)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end 
