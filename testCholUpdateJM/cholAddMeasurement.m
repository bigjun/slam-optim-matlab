function [ L_up, d_up, eta_up ] = cholAddMeasurement( L, d, w, e, eta )

eta_up = eta+w'*e;

sizeL = size(L) ;
latestColumn = zeros(sizeL(1),1) ;
p = 20 ;
Ld_full = [ L  , latestColumn  ; ...
            d' , p             ] ;
we=[w,e] ;
Ld=sparse(Ld_full) ;
Ld_up=chol_update(Ld,we') ; % the result is an L
L_up = Ld_up(1:end-1,1:end-1) ;
d_up=Ld_up(end,1:end-1)' ;


end

% R=L' ;
% [nbL, nbC] = size(R) ;
% latestLine = zeros(1,nbC) ;
% p = 20 ;
% Rd_full = [ R         , d  ; ...
%             latestLine, p] ;
% we=[w,e] ;
% Rd=sparse(Rd_full) ;
% Ld=Rd' ;
% Ld_up=chol_update(Ld,we') ; % the result is an L
% Rd_up=Ld_up' ;
% R_up=Rd_up(1:end-1,1:end-1) ;
% L_up = R_up' ;
% d_up=Rd_up(1:end-1,end) ;

