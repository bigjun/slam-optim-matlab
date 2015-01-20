
function Ln = LogSE3(T)

% %debug only
% syms r11 r12 r13 t1 r21 r22 r23 t2 r31 r32 r33 t3 real
% T = [ r11 r12 r13 t1; r21 r22 r23 t2; r31 r32 r33 t3; 0 0 0 1];

R = T(1:3,1:3);
t = T(1:3,4);

%tr = rd11 + rd22 + rd33;
tr = trace(R);
cd = (tr-1)/2;
th = acos(cd);
sd = sqrt(1 - cd^2);

%% Rotation
b = th/(2*sd);
r=[R(3,2) - R(2,3);
   R(1,3) - R(3,1);
   R(2,1) - R(1,2)];
% o = simplify(b*r);
w = b*r;
%wn = w/th;

%% Translation
wx = skew_symmetric(w);

%% http://www.kramirez.net/Robotica/Material/Libros/A%20mathematical%20Introduction%20to%20Robotic%20manipulation.pdf
% wn = norm(w); %the same as above
% sw = sin(wn);
% cw = cos(wn);
%tang = sw/(1 + cw);
%A = (2 * sw - wn * (1 + cw))/ (2 * wn^2 * sw);

%% http://en.wikipedia.org/wiki/User:BenFrantzDale/SE%283%29
%A = (2 * sd - th * (1 + cd))/ (2 * th^2 * sd); 
% A =(1/wn) * ( 1 - wn/(2 * tang));
% A = simplify((2 * sd - th * (1 + cd))/ (2 * th^2 * sd));

%% JLB 

V = (eye(3) - ((1 - cd)/(th^2)) * wx +  ((th - sd) / (th^3) )  * wx^2);
v= inv(V)*t; 

Ln = [v;w];



