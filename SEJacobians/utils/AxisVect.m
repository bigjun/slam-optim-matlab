function [ a1, a2, a3, b]= AxisVect(r11, r12, r13, r21, r22, r23, r31, r32, r33)
R = [r11 r12 r13; r21 r22 r23; r31 r32 r33]; 
cd = (trace(R)-1)/2;
sd = sqrt(1 - cd^2);
angle = acos(cd);
b=angle/(2*sd);
%A =[R(3,2) - R(2,3); R(1,3) - R(3,1); R(2,1) - R(1,2)]* ((angle*cd-sd)/(4*sd^3));
if cd==1
    A = [0 0 0]';
else
    A = [R(3,2) - R(2,3); R(1,3) - R(3,1); R(2,1) - R(1,2)]* angle/(2*sqrt(1-cd^2));
end
    
a1=A(1); 
a2=A(2); 
a3=A(3); 
  
  