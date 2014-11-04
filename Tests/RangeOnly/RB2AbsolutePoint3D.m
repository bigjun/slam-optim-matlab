function pt=RB2AbsolutePoint3D(P1,rb)
% Relative observation of a point from a pose.
%
% Returns the relative range-and-bearing observation (in the frame of P1) 
% from pose P1 to a landmark-point, pt, given in the gobal reference frame.
%
% The range-and-bearing are used to model observations derived from sensor
% readings.
%
 
% vx and vy from the pose to the landmark
  v=pt-P1(1:3);
  
  rxy = norm (v(1:2));
  bxy = pi2pi(atan2(v(2),v(1)));
  s
  rxyz = norm(v);
  
  bzx = pi2pi(atan2(v(3),rxy));
  
  rb=[rxyz ; bxy; bzx];
 
  o = rb(3);
  Ro=[ cos(o) -sin(o);
      sin(o)  cos(o)];
  