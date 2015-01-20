function Cov_ela
%getting the covariance matrix
A=[1 0 0 0 0 ; 1 -1 0 0 0; -1 0 1 0 0 ; 0 1 -1 0 0 ; 0 0 1 -1 0 ; 0 0 0 1 -1 ];
L=A'*A;
R=chol(L);
S=inv(R);
C=S*S';
[n,m]=size(L);
if(0)
    % tests on the decomposition of the covariance matrix
    DS = diag(S) %DS = 1./DR
    DR = diag(R)
    iDS = inv(diag(DS)) % iDS = diag(DR)
    
    iDS * S
    S * iDS
end


if (0)
    % test how 1 rank updates affects the covariance
    A1=[1 0 0 0 0 ; 1 -1 0 0 0; -1 0 1 0 0 ; 0 1 -1 0 0 ; 0 0 1 -1 0 ; 0 0 0 1 -1; 0 -1 0  0 1 ];
    L1=A1'*A1;
    R1=chol(L1);
    S1=inv(R1);
    C1=S1*S1';
    % compare R and R1 and C and C1
    C-C1
    R-R1
end


if (0)
    % Compute S = inv(R)
    
    s=zeros(n,m);
    
    for j = n:-1:1
        s(j,j) = 1/R(j,j);
        for i = j-1:-1:1
            s(i,j) = - sum(R(i,(i+1):j)*s((i+1):j,j)/R(i,i)); % \sum_{i+1}^{j}
        end
    end
    S-s
end

% SPARSE methods
%R=sparse(R);

if (0)
    % try the TRO's solve by column
    i = 4;
    ei = zeros(n,1);
    ei(i)=1;
    y = R'\ ei;
    ci = R\ y;
    ci
    C(:,i)
end


if (1)
    % try the TRO's solve by column
    i = 4;
    ei = zeros(n,1);
    ei(i)=1;
    L=R';   
    y = L(i:end,i:end)\ei(i:end);
    ci = R(i:end,i:end)\ y;
    ci
    C(:,i)
end


if (0)
    %try cs_usolve -DON't work
   
    i = 3;
    ei = zeros(n,1);
    ei(i)=1;
    y = cs_utsolve(R,ei);
    ci = cs_usolve(R,y);
    ci
    C(:,i)
end

% 
if (0)
c = zeros(n,n); 


for i = n:-1:1
    for j = n:-1:i+1
        if (i+1:j)
            sum3 = sum(R(i,i+1:j)*c(i+1:j,j));
        else
            sum3 = 0;
        end
        
        if (i+1:n)
            sum2 = sum(R(i,j+1:n)*c(j,j+1:n)');
        else 
            sum2 = 0;
        end
        
            c(i,j) = -1/R(i,i) * (sum2 + sum3);
            
    end
        sum1 = sum(R(i,i+1:n) * c(i,i+1:n)');
        c(i,i) = 1/R(i,i) * (1/R(i,i) - sum1);

end



% c(n,n) = 1/R(n,n)^2;
% en = zeros(n,1);
% en(n)= 1; 
% irnn = 1/R(n,n); % inverse of the diagonal element
% bn = irnn*en;  % select the last column

% c(:,n) = backsub(R,bn); % solve for the last column
% c(n,n) = 1/R(n,n)^2; % last pose covariance


% % Recompute individual elemets of the diagonal and last column
% i = n-1;
% c(i,i) = 1/R(i,i)*(1/R(i,i) - R(i,i+1) * c(i,i+1) );  % \sum_{i+1}^{n}  from i+1 to n
% 
% 
% 
% 
% i = n-2;
% k = i + 1;
% %c(i,k) = -1/R(i,i) * (R(i,i+1) * c(i+1,k) + R(i,i+1) * c(k,i+1));% \sum_{i+1}^{k} +  \sum_{k+1}^{n}
% c(i,k) = -1/R(i,i) * (R(i,i+1) * c(k,i+1));% \sum_{i+1}^{k} +  \sum_{k+1}^{n}
% 
% c(i,i) = 1/R(i,i) * (1/R(i,i) - R(i,i+1) * c(i,i+1) - R(i,i+2) * c(i,i+2));

end 

% and so on ...


