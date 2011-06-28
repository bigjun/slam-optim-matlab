function rb=AbsolutePoint2RBObs(P1,pt)
% Relative observation of a point from a pose.
%
% Returns the relative range-and-bearing observation (in the frame of P1) 
% from pose P1 to a landmark-point, pt, given in the gobal reference frame.
%
% The range-and-bearing are used to model observations derived from sensor
% readings.
%
 
% vx and vy from the pose to the landmark
  v=pt-P1(1:2);
  
  rb=[norm(v) ; pi2pi(atan2(v(2),v(1))-P1(3))];
 