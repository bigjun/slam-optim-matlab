function pWorld=RelativePoint2AbsolutePoint(P1,pRel)
% Applies a relative displacement to a pose in world coordinates.
%
% Transforms a point relative to a pose (P1) 
% to world coordinates. 
  
  o=P1(3);
  
  R=[ cos(o) -sin(o);
	 	  sin(o)  cos(o)];
 
  pWorld=P1(1:2)+R*pRel;
end 