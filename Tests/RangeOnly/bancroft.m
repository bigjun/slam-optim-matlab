function u = bancroft(buoys, range)
%bancroft method
%http://www.asl.ethz.ch/people/slynen/personal/lectures/aircraft/gps.pdf
% buoys and range have the same nr of rows

% Unit test
% buoys = [ -1.3, -1.2, -0.01;
%     1.1, -1.1, 0.02;
%     1.2,  1.2, -0.01;
%     -1.2,  1.2, 0.01];
nb = size(buoys,1);
% %range = [2.9223    2.3558    1.4119    2.0403];
% %pose = [0.4794    0.8776   -1.2750];
% %pose = [0.5012    0.8653   -1.2762];
% %pose = [ 0.5438    0.8392   -1.2787];
% pose =  [0.6816    0.7317   -1.2874];
% bc = .001;
% range = zeros(1,4);
% for i=1:nb
%     range(1,i) = AbsoluteBuoy2PR(pose,buoys(i,:),bc);
% end

tol = 10e-4;
B = zeros(nb,4);
a = zeros(nb,1);
e = ones(nb,1);
for i = 1:nb
    s = [buoys(i,:)';-range(i)];
    a(i,1) = (1/2) * lorentz_product(s,s);
    B(i,:) = s;
end
B_plus = pinv(B);
%B_plus = inv(B'*B)*B';

% solving \alpha* x^2 + \beta * x +\gamma
temp1 = B_plus * e;
alpha = lorentz_product(temp1,temp1);

temp2 = B_plus * a;
beta = lorentz_product(temp2,temp1) -1 ;

gamma = lorentz_product(temp2,temp2);

syms x
x_solution = eval(solve(alpha*x^2 + 2* beta *x == -gamma));

x1 = x_solution(1);
x2 = x_solution(2);

u1 = B_plus * (a + x1*e); % first solution 

u2 = B_plus * (a + x2*e); % second solution 

% residual

rez1 = 0;
for i =1: nb
rez1 = rez1 + (range(i) - norm(buoys(i,:)'-u1(1:3)) + u1(4))^2;
end 

rez2 = 0;
for i =1: nb
rez2 = rez2 + (range(i) - norm(buoys(i,:)'-u2(1:3)) + u2(4))^2;
end 


if (u1(3) < 0) & ((rez1 < rez2) | (~(u2(3) < 0) & (rez1 > rez2)))
    u = u1;
else
    u = u2;
end





% if  (u1(3) < 0) & (u2(3) < 0)
%     if rez1 < rez2
%         u = u1;
%     else
%         u = u2;
%     end
% elseif (u1(3) < 0) & ( rez1 < rez2)
%     u = u1;
% elseif (u2(3) < 0) & ( rez2 < rez1)
%     u = u2;
% elseif (u1(3) < 0)
%     u = u1;
% else 
%     u = u2;
% end










