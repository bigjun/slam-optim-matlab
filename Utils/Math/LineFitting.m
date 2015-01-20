real_p = randn(1);
real_q = randn(1);
% generate random line parameters

x = rand(200,1) * 2 - 1; % random, in range [-1, 1]
y = real_p + x * real_q;
% generate some random samples

y = y + randn(200,1) * .25;
% add some noise to the data

hold off; % we want a new plot
plot([-1, 1], [real_p - real_q, real_p + real_q], '-r');
% plot the original line (in red)

hold on; % we want to plot to the same plot
plot(x, y, '.b');
% plot data with noise (as blue dots)

syms J e px py p q real
e = (py - (p + q * px))^2;
% write squared error in terms of input parameters

J = jacobian(e, [p q]);
% calculate jacobian of error with respect to parameters

numJ = zeros(size(J));
for i=1:size(x)
    xi = x(i);
    yi = y(i);
    numJ = numJ + subs(J, {px, py}, {xi, yi});
end
% calculate sum of jacobians for each point

solution = solve(numJ == [0 0]);
% sum of all jacobians must equal zero

est_p = eval(solution.p);
est_q = eval(solution.q);
plot([-1, 1], [est_p - est_q, est_p + est_q], '-g');

return

constPart = subs(J, {p, q}, {0, 0})
pPart = simple(subs(J, {p, q}, {1, 0}) - constPart)
qPart = simple(subs(J, {p, q}, {0, 1}) - constPart)
% decompose jacobian to three parts, one for constant and one per each param

rhs = [0 0];
pcol = [0 0];
qcol = [0 0];
for i=1:size(x)
    xi = x(i);
    yi = y(i);
    rhs = rhs + subs(constPart, {px, py}, {xi, yi});
    pcol = pcol + subs(pPart, {px, py}, {xi, yi});
    qcol = qcol + subs(qPart, {px, py}, {xi, yi});
end
% substitute and sum up

eval(-[pcol' qcol'] \ rhs')
[real_p real_q]'

