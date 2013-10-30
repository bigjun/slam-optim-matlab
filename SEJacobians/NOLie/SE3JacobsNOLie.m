
clear
%
I3 = eye(3);
O33 = zeros(3,3);
O93 = zeros(9,3);
O39 = zeros(3,9);
O13 = zeros(1,3);
O31 = zeros(3,1);

%All in rotation Space

syms ru11 ru12 ru13 ru21 ru22 ru23 ru31 ru32 ru33 real
syms rv11 rv12 rv13 rv21 rv22 rv23 rv31 rv32 rv33 real
syms tux tuy tuz real
syms tvx tvy tvz real

Ru=[ ru11 ru12 ru13; ru21 ru22 ru23; ru31 ru32 ru33];
tu=[tux tuy tuz]';

Rv=[ rv11 rv12 rv13; rv21 rv22 rv23; rv31 rv32 rv33];
tv=[tvx tvy tvz]';


%Log map Jacobian
syms rd11 rd12 rd13 rd21 rd22 rd23 rd31 rd32 rd33 real
syms tdx tdy tdz real
Td = [rd11 rd12 rd13 tdx ; rd21 rd22 rd23 tdy; rd31 rd32 rd33 tdz];
JLn=simplify(lnJacobianSymsNOLie(Td));

% A2R Jacobian
[Td, JTu, JTv]=A2RJacobiansSyms(Ru,tu,Rv,tv);

% Substitute  Td
JLn = subs(JLn, {rd11 rd12 rd13 rd21 rd22 rd23 rd31 rd32 rd33 tdx tdy tdz} , {Td(1,1) Td(1,2) Td(1,3) Td(2,1) Td(2,2) Td(2,3) Td(3,1) Td(3,2) Td(3,3) Td(1,4) Td(2,4) Td(3,4)});

% Exp Jacobian
JExp_v=simplify(SumExpJacobiansSyms(tvx, tvy, tvz, rv11, rv12, rv13, rv21, rv22, rv23, rv31, rv32, rv33));
JExp_u=simplify(SumExpJacobiansSyms(tux, tuy, tuz, ru11, ru12, ru13, ru21, ru22, ru23, ru31, ru32, ru33));

%JExp_u = subs(JExp_u, {a1 a2 a3} , { a1u a2u a3u});

%Final JAcobians

Jv = simplify(JLn * JTv * JExp_v);
Ju = simplify(JLn * JTu * JExp_u);



% Test
uR = [ 0.341895;  -0.041700;  0.033039;  -0.003792;  0.007925;  0.180211];
vR = [ 0.541643;  0.135006;  -0.067787;  -0.007457;  0.024664;  0.291557];
d_gt = [ 0.229005;  0.138346;  -0.098524;  -0.002594;  0.016774;  0.111368]; % difference between u and v
H1_gt = [ -1.000000 -0.000000 0.000000 0.000000 0.098524 0.138346;  0.000000 -1.000000 0.000000 -0.098524 0.000000 -0.229005;  0.000000 0.000000 -1.000000 -0.138346 0.229005 0.000000;  0.000000 0.000000 0.000000 -0.998943 -0.055681 0.008411;  -0.000000 -0.000000 -0.000000 0.055688 -0.998966 0.001141;  -0.000000 -0.000000 -0.000000 -0.008363 -0.001453 -0.999976]; % the first jacobian
H2_gt = [ 0.993665 -0.111155 0.016594 0.000000 0.000000 0.000000;  0.111111 0.993802 0.003521 0.000000 0.000000 0.000000;  -0.016883 -0.001655 0.999856 0.000000 0.000000 0.000000;  0.000000 0.000000 0.000000 0.998943 -0.055688 0.008363;  -0.000000 -0.000000 -0.000000 0.055681 0.998966 0.001453;  0.000000 0.000000 0.000000 -0.008411 -0.001141 0.999976]; % the second jacobian

Ru=rot(uR(4:6));
Rv=rot(vR(4:6));
tu = uR(1:3);
tv = vR(1:3);

JvR= eval(subs(Jv,{ru11 ru12 ru13 ru21 ru22 ru23 ru31 ru32 ru33 tux tuy tuz rv11 rv12 rv13 rv21 rv22 rv23 rv31 rv32 rv33 tvx tvy tvz}, {Ru(1,1) Ru(1,2) Ru(1,3) Ru(2,1) Ru(2,2) Ru(2,3) Ru(3,1) Ru(3,2) Ru(3,3) tu(1) tu(2) tu(3) Rv(1,1) Rv(1,2) Rv(1,3) Rv(2,1) Rv(2,2) Rv(2,3) Rv(3,1) Rv(3,2) Rv(3,3) tv(1) tv(2) tv(3)}));
JuR= eval(subs(Ju,{ru11 ru12 ru13 ru21 ru22 ru23 ru31 ru32 ru33 tux tuy tuz rv11 rv12 rv13 rv21 rv22 rv23 rv31 rv32 rv33 tvx tvy tvz}, {Ru(1,1) Ru(1,2) Ru(1,3) Ru(2,1) Ru(2,2) Ru(2,3) Ru(3,1) Ru(3,2) Ru(3,3) tu(1) tu(2) tu(3) Rv(1,1) Rv(1,2) Rv(1,3) Rv(2,1) Rv(2,2) Rv(2,3) Rv(3,1) Rv(3,2) Rv(3,3) tv(1) tv(2) tv(3)}));

Diff=JvR-H2_gt
Diff=JuR-H1_gt


%Write to a file
ccu = ccode(Ju);
ccv = ccode(Jv);

ccu = strrep(strrep(ccu, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
ccu = strrep(ccu, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
%ccu = strrep(ccu, 'conjugate', '');
ccv = strrep(strrep(ccv, '~', sprintf('\n')), ';', sprintf(';\n')); % make newlines
ccv = strrep(ccv, '`codegen/C/expression:`, `Unknown function:`, conj, `will be left as is.`', '');
%ccv = strrep(ccv, 'conjugate', '');

fid = fopen('MyJacobsU_minus2.h','w')
fwrite(fid, ccu, 'uchar');
fclose(fid)
fid = fopen('MyJacobsV_minus2.h','w')
fwrite(fid, ccv, 'uchar');
fclose(fid)




% %Relative2Absolute
% 
% 
% syms rd11 rd12 rd13 rd21 rd22 rd23 rd31 rd32 rd32 real
% syms tdx tdy tdz real
% 
% Rd=[rd11 rd12 rd13; rd21 rd22 rd23; rd31 rd32 rd32];
% td=[tdx tdy tdz]';
% 
% tv = simplify(tu + Ru* td);  %overwrites tv
% Rv= simplify(Ru*Rd); 
% 
% 
% Tu=[Ru, tu];
% Tv=[Rv, tv];
% Td=[Rd, td];
% 
% Ju_R2A=jacobian(Tv,Tu)
% Jd_R2A=jacobian(Tv,Td)







