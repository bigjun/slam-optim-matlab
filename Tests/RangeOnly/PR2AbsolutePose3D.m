function [p,bc] = PR2AbsolutePose3D(buoys) 
%pseudo range to 3D poses and bias
%http://en.wikipedia.org/wiki/Global_Positioning_System#Navigation_equations

sr = size(b,1);
if sr < 4
    error('Not enough ranges!')
else
    % least squares
    
    
    p=[0 0 0];
    bc = 0;  % clock bias in m
    row = 1;
    col = 1:3;
    J = zeros(4,4);
    it = 1;
    done=(it>=maxIT);
    norm_dm=[];
    while ~done
        for i=1:4
            [pr,v] = AbsolutePoint2PR(p,buoys(i,:)) ;
            J1 = [v/pr]';
            J2 = -1;
            J(row,col) = J1;
            J(row, col(end)+1) = J2;
            d =
            row = row + 1;
        end
        
        norm_dm=[norm_dm,norm(dm)];% debug only
        done=((norm_dm(it)<tol)||(it>=maxIT));
        %norm(dm)
        if ~done
            it=it+1
        end
    end
    
    
%  A = zeros(3,3);
%  d = zeros(3,1);
%  for i = 2:sr
%      temp1 = 2*b(1,:) - 2*b(i,:);
%      temp2 = (b(1,:)*b(1,:)') - (b(i,:)*b(i,:)');
%      
%      temp3 = rb(1)^2 - rb(i)^2;
%      
%      A(i-1,:) = temp1;
%      d(i-1) = temp2-temp3;  
%      
%  end
% % R = qr(A);
% % p = R\(R'\(A'*d));
% %   [L,U] = lu(A);
% %   p = U\(L\d);
%   p=A\d;
% 
% 
% end 
end      