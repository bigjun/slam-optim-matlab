
% Incremental Schur Complement
syms A B C D real
syms a1 a4 b1 b2 b3 b4 c1 c2 c3 c4 d1 d4 da4 db4 dc4 dd4 real
syms dA dB dC dD real %Increments on the Schur Complement
%syms iD UdD CdD iCdD VdD hatD ihatD real  % inverse and inverse increment 
syms iD U real  % inverse and inverse increment 
syms id1 id4 ind4 td4 real

A = [a1 0; 0 a4];
B = [b1 b2; b3 b4];
C = [c1 c2; c3 c4];
D = [d1 0; 0 d4];

iD = [id1 0; 0 id4];  % the inverse of a block-diagonal is block diagonal

dA = [0 0; 0 da4];
dB = [0 0; 0 db4];
dC = [0 0; 0 dc4];
dD = [0 0; 0 dd4];

L = [A, B; C, D];
dL = [dA, dB; dC, dD];

% new system
nA = A + dA;
nB = B + dB;
nC = C + dC;
nD = D + dD;

nL_temp = L + dL;
nL = [nA, nB; nC, nD];

nL - nL_temp

%inD = [id1 0; 0 inv(d4 + dd4)];

inD = [id1 0; 0 ind4];

%ind4 = id4 - id4 * ud4' dd4)


S_Cam = A - B * iD * C';

S_nCam = nA - nB * inD * nC';
S_Cam - S_nCam
ind4 = id4 - td4;
 
dS_Cam = [ - b2*c2*id4,    - b2*c4*id4;  - b4*c2*id4,  - da4 - b4*c4*id4] ...
    + [b2*c2*ind4 ,  b2*ind4*(c4 + dc4); c2*ind4*(b4 + db4), ind4*(b4 + db4)*(c4 + dc4)];



dsl1 = -b2*td4*c2';

dsl2 =  b2*id4*dc4' - (c4 + dc4) * td4 *b2;

dsl3 = db4*id4*c2' - (b4 + db4) * td4 * c2;

dsl4 = - da4 - b4 * id4 *c4 + (b4 + db4) * id4 * (c4 + dc4) - (b4 + db4) * td4 * (c4 + dc4);

dsl = [dsl1 dsl2; dsl3 dsl4];

expand(dS_Cam) - expand(dsl)


dSCam = [0 0 ; 0 -da4] + nB(:,2) * id4 * nC(:,2)' - B(:,2) * id4 * C(:,2)' - nB(:,2) * td4 * nC(:,2)';

expand(dS_Cam) - expand(dSCam)


SCam = [a1 0 ; 0 a4] - B(:,1) * id1 * C(:,1)'- B(:,2) * id4 * C(:,2)';

expand(S_Cam) - expand(SCam)



% by calculating ind4
syms ind4 real

dS_Cam = [ - b2*c2*id4,    - b2*c4*id4;  - b4*c2*id4,  - da4 - b4*c4*id4] ...
    + [b2*c2*ind4 ,  b2*ind4*(c4 + dc4); c2*ind4*(b4 + db4), ind4*(b4 + db4)*(c4 + dc4)]



dsl1 = b2*ind4*c2 - b2*id4*c2;

dsl2 = b2*ind4*(c4 + dc4) - b2*id4*c4;

dsl3 = c2*ind4*(b4 + db4) - b4*id4*c2;

dsl4 = (b4 + db4)*ind4*(c4 + dc4) - da4 - b4*id4*c4;


% marginals (Schur complementing the points D)

syms iA iS_Cam real
syms ia1 ia4 ina4 isc1 isc2 isc3 isc4 real



iA = [ia1 0; 0 ia4];

inA = [ia1 0; 0 ina4];

S_Points = D - C * iA * B';

S_nPoints = nD - nC * inA * nB';

S_nPoints - S_Points

dS_Points = [b2*c2*ia4 - b2*c2*ina4,         b4*c2*ia4 - c2*ina4*(b4 + db4);
    b2*c4*ia4 - b2*ina4*(c4 + dc4), dd4 - ina4*(b4 + db4)*(c4 + dc4) + b4*c4*ia4];



% marginals

iS_Cam = [isc1, isc2; isc3, isc4]

%iS_Cam = inv(A - B * iD * C')

iS_Points = iD + iD * C * iS_Cam * B' * iD ;


inS_Points = inD + inD * nC * iS_Cam * nB' * inD 



inS_Points - iS_Points;

inSP1 = 0; % only the covariances of the updated points change!!! 

inSP2 = ind4*((b4 + db4)*(c1*id1*isc2 + c2*id1*isc4) + b3*(c1*id1*isc1 + c2*id1*isc3)) - id4*(b3*(c1*id1*isc1 + c2*id1*isc3) + b4*(c1*id1*isc2 + c2*id1*isc4))

inSP3 = id1*(b1*(ind4*isc3*(c4 + dc4) + c3*ind4*isc1) + b2*(ind4*isc4*(c4 + dc4) + c3*ind4*isc2)) - id1*(b1*(c3*id4*isc1 + c4*id4*isc3) + b2*(c3*id4*isc2 + c4*id4*isc4))

inSP4 = ind4 - id4 + ind4*(b3*(ind4*isc3*(c4 + dc4) + c3*ind4*isc1) + (b4 + db4)*(ind4*isc4*(c4 + dc4) + c3*ind4*isc2)) - id4*(b3*(c3*id4*isc1 + c4*id4*isc3) + b4*(c3*id4*isc2 + c4*id4*isc4))


temp1 = id4^2 * [b3,b4] * iS_Cam * [c3;c4];


temp2 = ind4^2 * [b3 + 0, b4 + db4] * iS_Cam * [c3 + 0; c4 + dc4];

expand(inSP4)


% inverse of the SCam

S_Cam = A - B * iD * C';

iS_Cam = iA + iA * B * (D - C * iA * B') * C' * iA;


% 
% %%%%%%%%%%% old code
% 
% % calculate ihatD
% hatD = D + dD;
% 
% % dD = UdD * CdD * VdD;
% % ihatD = iD - iD * UdD * inv(iCdD + VdD * iD * UdD) * VdD * iD;
% % temp = iD * UdD * inv(iCdD + VdD * iD * UdD) * VdD * iD;
% 
% dD = U' * U;
% ihatD = iD - iD * U' * inv(1 + U * iD * U') * U * iD;
% 
% delta = iD * U' * inv(1 + U * iD * U') * U * iD;
% 
% syms T iS real
% 
% delta = T * iS * T';
% 
% ihatD = iD - delta;
% 
% %calculate schur icrement
% 
% %syms ihatD real
% 
% S_hatL = (A + dA) - (B + dB) * ihatD * (C' + dC');
% 
% S1_hatL = A + dA - B*ihatD*C' - B*ihatD*dC' - dB*ihatD*C' - dB*ihatD*dC';
% 
% %isequaln(S1_hatL,S_hatL)
% expand(S1_hatL)  - expand(S_hatL)
% 
% 
% S0 = A - B*ihatD*C';
% S0P = (A - B * iD * C') + B * T * iS * T' * C';  
% expand(S0)  - expand(S0P)
% 
% S1 = dA - dB*ihatD*dC';
% S1P = (dA - dB * iD * dC) + dB * T * iS * T' * dC'; 
% expand(S1)  - expand(S1P)
% 
% S2 = - B*ihatD*dC'; 
% S2P = B * T * iS * T' * dC' - B * iD * dC';
% expand(S2)  - expand(S2P)
% 
% S3 = - dB*ihatD*C';
% S3P = dB * T * iS * T' * C' - dB * iD * C';
% expand(S3)  - expand(S3P)
% 
% 
% % test factorization
% 
% 
% 
% SS = S_L + (dA - dB * iD * dC) + B * delta * C'  + dB * delta * dC' +  B * delta * dC' +  dB * delta * C' - ( B * iD * dC' + dB * iD * C');
% 
% SS = S_L + (dA - dB * iD * dC) + (B  + dB) * delta * (C' + dC') - ( B * iD * dC' + dB * iD * C');
% 
% 
% SS = (A + dA) - (B + dB) * iD * (C' + dC') + (B  + dB) * delta * (C' + dC');
% 
% 
% expand(S_hatL) - expand(SS)
% 
% 
% %isequaln(S1_hatL, S1_hatL)
% 
% 
%  
% %S1_hatL = A + dA - B * iD * C' + B * temp * C' - dB * iD * dC' + dB * temp * dC';
% %isequaln(S_hatL, S1_hatL)
% 
% 
%  %S1_hatL = (A - B * iD * C') + (dA - dB * iD * dC')  + B * temp * C'  + dB * temp  * dC'
%  
%  
%  
%  
% 
% 
% 
% 
% 
% %A + dA + dB*dC*(iD - UdD*VdD*iD^3*(iCdD + UdD*VdD*iD)) - B*C*(iD - UdD*VdD*iD^3*(iCdD + UdD*VdD*iD))
% 
% 
% %simple(S_hatL)
% 
% 
% 
% % Woodbury formula
% 
% 
% 
% % (A+VA) - (B+VB)(iD + ViD)(C+VC)
% % (A+VA) - (B+VB)*(iD + ViD)*(C+VC)
% % S = (A+VA) - (B+VB)*(iD + ViD)*(C+VC)
% % simplify(S)
% % doc simplify
% % simplify(S,'basic')
% % expand(S)
% % S = (A+VA) - (B+VB)'*(iD + ViD)*(B+VB)