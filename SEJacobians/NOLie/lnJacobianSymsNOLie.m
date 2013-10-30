function JLn=lnJacobianSymsNOLie(Td)

Rd = Td(1:3,1:3);
td = Td(1:3,4);
LnR=ArotMat(Rd);

Ln = [td LnR];

JLn=jacobian( Ln,reshape(Td,1,12));


 