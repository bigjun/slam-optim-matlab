function [F W]=Relative2AbsoluteJacobian(P,D)
% Jacobian of the displacement function.
%
% Returns the Jacobian of the Relative2Absolute function
% with respect to its two paramters evaluated at P and D.
%
% See also Relative2Absolute.
  
	dx=D(1);
	dy=D(2);
  
	o=P(3);
	so=sin(o);
	co=cos(o);
  
	F=[[1 0 -so*dx-co*dy];
		 [0 1  co*dx-so*dy];
		 [0 0       1     ]]; % Jacobian of Relative2Absolute w.r.t P
   
  W=[[co -so 0];
     [so  co 0];
     [ 0   0 1]]; % Jacobian of Relative2Absolute w.r.t D
   