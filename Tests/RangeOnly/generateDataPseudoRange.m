%generate data

function [range,vertices,buoy,sigInit,sigState,sigBias,sigObs,dt,A]=generateDataPseudoRange
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
timeDive = 15; % diving time in seconds
dt = .1;       % time step 
t = 1:dt:timeDive;

diver=[sin(t * .5); cos(t * .5); (-1 - .5 * (.5 + .5 * sin(t / 10)))]'; % spiral
nd = size(diver,1);


A = [I3 dt*I3; O33 I3];  % the constant velocity system matrix

figure
plot3 (buoy(:,1),buoy(:,2),buoy(:,3),'r*')
hold on;
plot3(diver(:,1),diver(:,2),diver(:,3),'b')
hold on;
grid on;

% the clock bias in meters  
bc = .7; 
sigBias = 0.0001^2;

% Covariances

sigInit = [.001^2,.001^2,.001^2,.001^2,.001^2,.001^2]';
sigState = [.002^2,.002^2,.002^2,.03^2,.02^2,.02^2]';%sigState = [.002^2,.002^2,.002^2,.003^2,.5^2,.5^2]';
sigObs = .05^2;


% generate edges
j = 1;
temp = 1;
range = zeros(nd,nb);

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


%generate vertices

%initial pose is computed using buoys triangulation with bancroft method
p_init=zeros(nd,3);
bc_init = zeros (nd,1);
vertices = zeros(nd,8);

ban1 = bancroft(buoy,range(1,:));
ban2 = bancroft(buoy,range(2,:));
p1 = ban1(1:3)';
p2 = ban2(1:3)';

%initial velocity
v1 = (p2 - p1)/dt;
vertices(1,:) = [1,p1,v1,ban1(4)];

p_old = p1;
for i = 2:nd
    ban = bancroft(buoy,range(i,:));
    p_new = ban(1:3)';
    bc = ban(4);
    v = (p_old - p_new)/dt;
    vertices(i,:) = [i,p_new,v,bc];
    p_old = p_new;
end

% poses = vertices(:,2:end);
% 
% plot3(poses(:,1),poses(:,2),poses(:,3), 'g')


















