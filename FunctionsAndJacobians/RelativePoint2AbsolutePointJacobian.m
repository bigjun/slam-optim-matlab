function [F W]=RelativePoint2AbsolutePointJacobian(P1,pRel)
% Jacobian of the RelativePoint2Absolute function
%
% Returns the Jacobian of the RelativePoint2Absolute function
% with respect to its two paramters evaluated at P1 and pRel.

	dx=pRel(1);
	dy=pRel(2);
  
	o=P1(3);
	so=sin(o);
	co=cos(o);
  
	F=[[1 0 -so*dx-co*dy];
		 [0 1  co*dx-so*dy]]; 
   
  W=[[co -so];
     [so  co]]; 