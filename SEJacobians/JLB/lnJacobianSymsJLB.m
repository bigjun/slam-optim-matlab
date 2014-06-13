function JLn_JLB=lnJacobianSymsJLB(Td)


%rr = reshape(Td(1:3,1:3)',1,9);
%rt = reshape(Td(1:3,4),1,3);
% [a1, a2, a3, b]= AxisVect(Td(1:3,1:3));

R=Td(1:3,1:3);
tr = trace(R);
cd = (tr-1)/2;
th = acos(cd);
sd = sqrt(1 - cd^2);
% Rotation
b = th/(2*sd);
r=[R(3,2) - R(2,3);
   R(1,3) - R(3,1);
   R(2,1) - R(1,2)];

a = r* (th * cd - sd)/(4*sd^3);

% the Jacobian dLn(R)/dR 

JLn21=[ a(1) 0  0, 0 a(1) b, 0 -b a(1)
        a(2) 0 -b, 0 a(2) 0, b  0 a(2)
        a(3) b  0,-b a(3) 0, 0  0 a(3)]; % gives the same value as the computed Jacobians
    
JLn22=zeros(3,3);

    
    
    % The problem is derivating the Jacobian dLn(T)/dR 
    
JLn11=jacobian(Lnt,rr);
JLn12=jacobian(Lnt,rt);
JLn21=jacobian(Lnr,rr); 3x9
JLn22=jacobian(Lnr,rt); 3x3
  

Ln = [v;w];


Ln = LogSE3(Td);
Lnt = Ln(1:3);
Lnr = Ln(4:6);    

