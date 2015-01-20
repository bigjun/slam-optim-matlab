%no. points
n = 200;
% standard deviation
st = .25;

% generate random line parameters
lp = randn(1);
lq = randn(1);

% generate the line points (the graund truth)
x = rand(n,1) * 2 - 1; % random, in range [-1, 1]
y = lp + x * lq;

% add some noise to the line points
y = y + randn(n,1) * st;


%% PLOT
hold off; 
plot([-1, 1], [lp - lq, lp + lq], '-r'); % plot the ground truth line in red
hold on; % on the same plot
plot(x, y, '.b');  % plot noisy points in blue


%% LINE FITTING
syms J e px py p q real

% write squared error in terms of input parameters
e = (py - (p + q * px))^2;

% calculate jacobian of error with respect to parameters
J = jacobian(e, [p q]);

% calculate sum of jacobians for each point
numJ = zeros(size(J));
for i=1:n
    numJ = numJ + subs(J, {px, py}, {x(i), y(i)});
end

% sum of all jacobians must equal zero. the solution is where the second
% derivative cancels
solution = solve(numJ == [0 0]);

est_p = eval(solution.p);
est_q = eval(solution.q);

%% PLOT the solution
plot([-1, 1], [est_p - est_q, est_p + est_q], '-g');


