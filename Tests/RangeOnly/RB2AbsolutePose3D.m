function p = RB2AbsolutePose3D(b,rb) 
%this function works only for more than 4 ranges


sr = size(b,1);
if sr < 4
    error('Not enough ranges!')
else
    % solve for the buoys
    
    %the function is F = -R + P.^2 - 2.*P.*B + B.^2, R- the vector measured
    %distances (rb), B contains the buoys  
    
 A = zeros(3,3);
 d = zeros(3,1);
 for i = 2:sr
     temp1 = 2*b(1,:) - 2*b(i,:);
     temp2 = (b(1,:)*b(1,:)') - (b(i,:)*b(i,:)');
     
     temp3 = rb(1)^2 - rb(i)^2;
     
     A(i-1,:) = temp1;
     d(i-1) = temp2-temp3;  
     
 end
% R = qr(A);
% p = R\(R'\(A'*d));
%   [L,U] = lu(A);
%   p = U\(L\d);
  p=A\d;


end 
end      