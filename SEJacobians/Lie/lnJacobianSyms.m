function JLn=lnJacobianSyms(Td)

%syms rd11  rd12  rd13  rd21  rd22  rd23  rd31  rd32 rd33 real
% only rotation
%Rd=[rd11 rd12 rd13; rd21 rd22 rd23; rd31 rd32 rd33];
% Rd = Td(1:3,1:3);
% td = Td(4,1:3);
% Ln=ArotMat(Rd);
Ln = LogSE3(Td);
Lnt = Ln(1:3);
Lnr = Ln(4:6);

rr = reshape(Td(1:3,1:3),1,9); % this gives [rd11 rd21  rd31   rd12 rd22  rd32    rd13 rd23 rd33] !!!
rt = reshape(Td(1:3,4),1,3);

%JLnGT=jacobian(Ln,r);
JLn11=jacobian(Lnt,rr);
JLn12=jacobian(Lnt,rt);
JLn21=jacobian(Lnr,rr);
JLn22=jacobian(Lnr,rt);
JLn = [JLn11,JLn12;JLn21,JLn22];
%JLn =JLn21  

% JLn-JLnGT

% syms theta costh real
% 
% JLn= subs (JLn, acos(rd11/2 + rd22/2 + rd33/2 - 1/2), theta);
% 
% JLn= simple(subs (JLn, (rd11/2 + rd22/2 + rd33/2 - 1/2), costh))


% % another way to compute the same
% 
% jLn1=jacobian(b, [rd11 rd12 rd13 rd21 rd22 rd23 rd31 rd32 rd33]).*r(1) ;
% jLn2=jacobian(b, [rd11 rd12 rd13 rd21 rd22 rd23 rd31 rd32 rd33]).*r(2) ;
% jLn3=jacobian(b, [rd11 rd12 rd13 rd21 rd22 rd23 rd31 rd32 rd33]).*r(3) ;
% 
% jLnb=[jLn1;jLn2;jLn3];
% 
% jLnr=b.*jacobian(r, [rd11 rd12 rd13 rd21 rd22 rd23 rd31 rd32 rd33]);
% 
% jLn = jLnb + jLnr;

% jLn= subs (jLn, acos(rd11/2 + rd22/2 + rd33/2 - 1/2), theta);
% jLn= subs (jLn, (rd11/2 + rd22/2 + rd33/2 - 1/2), costh)
%  %isequaln(jLn(1,1),JLn(1,1)) %too complex expresion to be handdle 

 