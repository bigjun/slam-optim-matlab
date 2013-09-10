function JLn_JLB=lnJacobianSymsJLB(rd11, rd12, rd13, rd21, rd22, rd23, rd31, rd32, rd33)
[a1, a2, a3, b]= AxisVect(rd11, rd12, rd13, rd21, rd22, rd23, rd31, rd32, rd33);

 JLn_JLB=[a1 0  0, 0 a1 b, 0 -b a1
      a2 0 -b, 0 a2 0, b  0 a2
      a3 b  0,-b a2 0, 0  0 a3]