function [rxyz,varargout]=AbsolutePoint2RB3D(P1,pt)
% Relative observation of a point from a pose.
%
% Returns the relative range-and-bearing observation (in the frame of P1) 
% from pose P1 to a landmark-point, pt, given in the gobal reference frame.
%
% The range-and-bearing are used to model observations derived from sensor
% readings.
%
 
% vx and vy from the pose to the landmark
  %v=pt-P1(1:3);
   v=P1(1:3)-pt(1:3);
  
  rxy = norm (v(1:2));
  
  bxy = pi2pi(atan2(v(2),v(1)));
  
  rxyz = norm(v);
  
  bzx = pi2pi(atan2(v(3),rxy));

  varargout{1}=v';
  varargout{2}=bxy;
  varargout{3}=bzx;