%generate data

function [range,vd,buoy,sigInit,sigState,sigObs,dt,nd,A, diver]=generateData
close all

range_type = 1 ; % 0-range; 1-pseudorange

 I6 = eye(6);
 I3 = eye(3);
 O33 = zeros(3,3);
 O3 = zeros(3,1);
 randn('seed', 12345);
% 
buoy = [ -1.3, -1.2, -0.01;
    1.1, -1.1, 0.02;
    1.2,  1.2, -0.01;
    -1.2,  1.2, 0.01];


%      
%        
% buoy = [ -1, -1, 0;
%           1, -1, 0;
%           1,  1, 0;
%          -1,  1, 0];


%test
nb = size(buoy,1); 
timeDive = 5; % diving time in seconds
dt = 1;       % time step 
t = 1:dt:timeDive;
%%%%%

% %Lukas
% nb = size(buoy,1); 
% timeDive = 50; % diving time in seconds
% dt = .1;       % time step 
% t = 1:dt:timeDive;
% %%%%%


%diver=[sin(t * .5); cos(t * .5); (-1 - .5 * (.5 + .5 * sin(t / 10)))]'; % spiral
%Lukas
diver=[sin(t * .5); cos(t * .5) + t * .1; (-1 - .5 * (.5 + .5 * sin(t / 10)))]'; % shiftting spiral 
%%%%%
%diver = [t', 0.5*t', -2*ones(size(t,2),1)];% straight line
nd = size(diver,1);


A = [I3 dt*I3; O33 I3];  % the constant velocity system matrix

figure
plot3 (buoy(:,1),buoy(:,2),buoy(:,3),'r*')
hold on;
plot3(diver(:,1),diver(:,2),diver(:,3),'b')
hold on;
grid on;

% for i = 1: nd
%     line ([diver(i,1)*ones(4,1),buoy(:,1)]',[diver(i,2)*ones(4,1),buoy(:,2)]',[diver(i,3)*ones(4,1),buoy(:,3)]');
% end
% T = get(gca,'tightinset');
% set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);

% hold on

% Covariances

sigInit = [.001^2,.001^2,.001^2,.001^2,.001^2,.001^2]';
sigState = [.002^2,.002^2,.002^2,.03^2,.02^2,.02^2]';%sigState = [.002^2,.002^2,.002^2,.003^2,.5^2,.5^2]';
sigObs = .05^2;
bc = .1; % the clock bias in meters  
sigBC = 0.01^2;

% 
% %Lukas
% sigInit = [.001^2,.001^2,.001^2,.001^2,.001^2,.001^2]';
% sigState = [.01^2,.01^2,.01^2,.03^2,.02^2,.02^2]';%sigState = [.002^2,.002^2,.002^2,.003^2,.5^2,.5^2]';
% sigObs = .01^2;
% %%%%%

% generate edges
j = 1;
temp = 1;
range = zeros(nd,nb);

switch range_type
    case 0
        %range
        while j <= nd
            for i=1:4
                pose = diver(j,:);
                b = buoy(i,:);
                rb = AbsolutePoint2RB3D(pose,b) ; %range
                rb = rb  + sigObs*randn;
                range(j, i) = rb;
                temp = temp+1;
            end
            j=j+1;
        end
    case 1
        %pseudo range
        while j <= nd
            for i=1:4

                pose = diver(j,:);
                b = buoy(i,:);
                pr = AbsoluteBuoy2PR(pose,b,bc); % pseudo range
                pr = pr  + sigObs*randn;
                range(j,i) = pr;
                temp = temp+1;
            end
            j=j+1;
        end
end

%generate vertices

%initial pose is computed using buoys triangulation 
p_init=zeros(nd,3);

switch range_type
    case 0
        for i = 1:nd
            p_init(i,:) = RB2AbsolutePose3D(buoy,range(i,:));
        end
    case 1
        bc_init = zeros (nd,1);
        
        for i = 1:nd
            ban = bancroft(buoy,range(i,:));
            p_init(i,:) = ban(1:3);
            bc_init(i,1) = ban(4);
        end
end
% 
%   plot3(p_init(:,1),p_init(:,2),p_init(:,3), 'r') 

p1 = p_init(1,:);
p2 = p_init(2,:);

%initial velocity
initv = (p2 - p1)/dt; %+  sigState(4:end)*randn;


switch range_type
    case 0
        %vertices diver's pose
        vd = zeros(nd,7);
        vd(1,:) = [1, p1+  (sigInit(1:3)*randn)', initv];
        
        for i=2:nd   
            %   pv = A * vd(i-1,2:end)' +  sigState*randn;  %constant velocity model
            p = p_init(i,:)' +  sigInit(1:3)*randn;
            v = (p_init(i,:)' - p_init(i-1,:)')/dt +  sigInit(4:end)*randn;
            %v = vd(i-1,5:end)' +  sigState(4:end)*randn;
            vd(i,:) = [i, p', v',] ;
        end
    case 1
        
                %vertices diver's pose
        vd = zeros(nd,8);
        vd(1,:) = [1, p1+  (sigInit(1:3)*randn)', initv, bc_init(1) + sigBC*randn];
        
        for i=2:nd   
            %   pv = A * vd(i-1,2:end)' +  sigState*randn;  %constant velocity model
            p = p_init(i,:)' +  sigInit(1:3)*randn;
            v = (p_init(i,:)' - p_init(i-1,:)')/dt +  sigInit(4:end)*randn;
            bc = bc_init(i) + sigBC*randn;
            %v = vd(i-1,5:end)' +  sigState(4:end)*randn;
            vd(i,:) = [i, p', v', bc] ;
        end

end


 hold on ;
% 
  plot3(vd(:,2),vd(:,3),vd(:,4), 'g') 


















