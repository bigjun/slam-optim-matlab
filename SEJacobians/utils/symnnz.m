function N=symnnz(M)

[m,n]=size(M);
N=ones(m,n);
for i=1:m
    for j=1:n
        if M(i,j)==0
            N(i,j)=0;
        end 
    end
end

