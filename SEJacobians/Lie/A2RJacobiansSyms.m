
function [Td, JTu, JTv]=A2RJacobiansSyms(Ru,tu,Rv,tv)

td = Ru'*(tv - tu); 
Rd= Ru'*Rv; 
%Rd= Ru\Rv; 

Tu=[Ru, tu];
Tv=[Rv, tv];
Td=[Rd, td];

% Jacobian in rotation space
JTu=jacobian(Td,Tu);
JTv=jacobian(Td,Tv);
