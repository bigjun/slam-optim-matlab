function rp=AbsolutePoint2RelativePoint(P1,pt)
% Relative displacement from a pose to a landmark-point.
%
% Returns the relative displacement (in polar coordinates) expresed in 
% the frame of P1 from the pose P1 to a landmark-point, pt, given in 
% the gobal reference frame.

  % vx and vy for
  v=pt-P1(1:2);
  
  o=-P1(3);
  
  R=[ cos(o) -sin(o);
	 	  sin(o)  cos(o)];
  
  rp=R*v;
  