%generate data

function [doubleDiff,vd,buoys,sigInit,sigState,sigObs,dt,A]=generateDataDoubleDifference 
close all

 I3 = eye(3);
 O33 = zeros(3,3);
 randn('seed', 12345);
% 
buoys = [ -1.3, -1.2, -0.01;
    1.1, -1.1, 0.02;
    1.2,  1.2, -0.01;
    -1.2,  1.2, 0.01];


%test
nb = size(buoys,1); 
timeDive = 15; % diving time in seconds
dt = .1;       % time step 
t = 1:dt:timeDive;

diver=[sin(t * .5); cos(t * .5); (-1 - .5 * (.5 + .5 * sin(t / 10)))]'; % spiral
nd = size(diver,1);


A = [I3 dt*I3; O33 I3];  % the constant velocity system matrix

figure
plot3 (buoys(:,1),buoys(:,2),buoys(:,3),'r*')
hold on;
plot3(diver(:,1),diver(:,2),diver(:,3),'b')
hold on;
grid on;


% Covariances

sigInit = [.001^2,.001^2,.001^2,.001^2,.001^2,.001^2]';
sigState = [.002^2,.002^2,.002^2,.03^2,.02^2,.02^2]';%sigState = [.002^2,.002^2,.002^2,.003^2,.5^2,.5^2]';
sigObs = .09^2;
sigRange = .05^2;


% generate edges

doubleDiff = zeros(nd, nb-1);
range = zeros(nd,nb);

for j=1:nd
    pose = diver(j,:);
    [dd, r,v] = AbsoluteBuoy2DD(pose, buoys);
    doubleDiff(j,:)  = [dd  + ones((nb-1),1)*sigObs*randn]';  % TODO we need see what is this 
    range (j,:) = [r + ones(nb, 1)*sigRange*randn]';
end


%generate vertices

%initial pose is computed using buoys triangulation with bancroft method
p_init=zeros(nd,3);

for i = 1:nd
    p_init(i,:) = RB2AbsolutePose3D(buoys,range(i,:));
end


p1 = p_init(1,:);
p2 = p_init(2,:);

%initial velocity
initv = (p2 - p1)/dt; %+  sigState(4:end)*randn;


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


 hold on ;
% 
  plot3(vd(:,2),vd(:,3),vd(:,4), 'g') 




