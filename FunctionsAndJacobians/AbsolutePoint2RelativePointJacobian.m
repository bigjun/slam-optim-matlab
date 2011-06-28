function [H1 H2]=AbsolutePoint2RelativePointJacobian(P1,pt)
% Jacobian of the relative displacement between a pose and a point.
%
% Returns the Jacobians of the AbsolutePoint2Relative function with respect its
% parameteres evaluated at P1 and pt.
%
% See also AbsolutePoint2Relative.

  x1=P1(1);  y1=P1(2);  o1=P1(3);
	x2=pt(1);       y2=pt(2);

	dx=(x2-x1);
	dy=(y2-y1);
  
	c1=cos(o1);
	s1=sin(o1);
  
	H1=[[-c1 -s1 -s1*dx+c1*dy ];
	  	[ s1 -c1 -c1*dx-s1*dy ]];
		
	H2=[[ c1  s1];
		  [-s1  c1]];