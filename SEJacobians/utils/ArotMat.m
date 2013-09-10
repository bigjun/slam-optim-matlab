
function Ln=ArotMat(rd11, rd12, rd13, rd21, rd22, rd23, rd31, rd32, rd33)
tr = rd11 + rd22 + rd33;
cd = (tr-1)/2;
th = acos(cd);
sd = sqrt(1 - cd^2);
b=th/(2*sd);
r=[rd32 - rd23;
   rd13 - rd31;
   rd21 - rd12];

Ln=b*r;