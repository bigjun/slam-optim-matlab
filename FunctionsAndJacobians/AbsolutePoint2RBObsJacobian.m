function [H1 H2]=AbsolutePoint2RBObsJacobian(P1,pt)
% Jacobian of the relative range-and-bearing from a pose to a point.
%
% Returns the Jacobians of the AbsolutePoint2RBObs function with respect 
% its parameteres evaluated at P1 and pt.
%
% See also AbsolutePoint2RBObs.

  v=pt-P1(1:2);
  
  d=norm(v);
  
  H1=[-v(1)/d     -v(2)/d      0 ;
       v(2)/d^2   -v(1)/d^2   -1 ];
    
  H2=[ v(1)/d    v(2)/d ;
      -v(2)/d^2  v(1)/d^2 ];