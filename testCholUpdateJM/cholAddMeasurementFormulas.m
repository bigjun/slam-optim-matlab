function [ L_up, d_up, eta_up ] = cholAddMeasurementFormulas( L, d, w, e, eta, newStateSize )

if (nargin<6 || newStateSize==0), % no new state
    sizeL = size(L)  ; % size of L
    sizeX = sizeL(2) ; % size of state vector
    sizeW = size(w) ;
    sizew     = sizeW(2);
    nbnewMeas = sizeW(1);

    if (sizew==sizeX), % update of all L, because of a full loop closure
        eta_up = eta+w'*e          ;
        omega  = w'*w              ;
        R_up   = chol(L*L'+ omega) ; % here L11 and L21 are  []
        L_up   = R_up'             ;
        d_up   = L_up \eta_up      ;
        return ;
    end

    if (sizew<sizeL(1)), % update of L22 only, because of only local update
        sizeL11         = sizeX-sizew    ;
        w_full          = zeros(nbnewMeas,sizeX) ; % [ 0 ... 0 w ]
        w_full(:,sizeX-sizew+1:end) = w                 ;

        eta_up = eta + w_full'*e                ; % A_up'.b_up
        L11    = L(1:sizeL11,1:sizeL11)         ; % L = [ L11 0   ]
        L21    = L(sizeL11+1:end,1:sizeL11)     ; %     [ L21 L22 ]
        L22    = L(sizeL11+1:end,sizeL11+1:end) ;

        d1    = d(1:sizeL11)          ; % d   = [d1; d2], where d1 do not change
        eta2  = eta_up(sizeL11+1:end) ; % eta = [eta1;eta2]

        omega   = w'*w     ;
        I22     = L21*L21' + L22*L22' ;
        L22_new = (chol(I22+omega-L21*L21'))'  ;
        L_up    = [ L11, zeros(sizeL11,sizew)  ; ...
                    L21,  L22_new             ];
        d2_new  = L22_new\(eta2-L21*d1) ;
        d_up    = [d1;d2_new];
        return ;
    end
    return ;
else % we have new state variables
    sizeL = size(L)  ; % size of L
    sizeX = sizeL(2) ; % size of state vector (including new state)

    if (length(w)==sizeX), % update of all L, because of a full loop closure
        eta_up = eta+w'*e          ;
        omega  = w'*w              ;
        R_up   = chol(L*L'+ omega) ; % here L11 and L21 are  []
        L_up   = R_up'             ;
        d_up   = L_up \eta_up      ;
        return ;
    end

    if (length(w)<sizeL(1)), % update of L22 only, because of a local update
        sizew           = length(w)      ;
        sizeL11         = sizeX-sizew    ;
        w_full          = zeros(1,sizeX) ; % [ 0 ... 0 w ]
        w_full(sizeX-sizew+1:end) = w                 ;

        eta_tmp = zeros(sizeX,1) ; % don't know if Ok ??
        eta_tmp(1:length(eta)) = eta ;
        
        we = w'*e ; % instead
        we_full = zeros(length(w_full),1) ;
        we_full(length(we_full)-length(we)+1:length(we_full)) = we ;
        eta_up = eta_tmp + we_full                ; % A_up'.b_up
        %eta_up = eta_tmp + w_full'*e                ; % A_up'.b_up
        L11    = L(1:sizeL11,1:sizeL11)         ; % L = [ L11 0   ]
        L21    = L(sizeL11+1:end,1:sizeL11)     ; %     [ L21 L22 ]
        L22    = L(sizeL11+1:end,sizeL11+1:end) ;

        d1    = d(1:sizeL11)          ; % d   = [d1; d2], where d1 do not change
        eta2  = eta_up(sizeL11+1:end) ; % eta = [eta1;eta2]

        omega   = w'*w     ;
%        I22     = L21*L21' + L22*L22' ;
        I22_tmp = L22*L22' ;
        L22_new = (chol(I22_tmp+omega))'  ;
        L_up    = [ L11, zeros(sizeL11,sizew)  ; ...
                    L21,  L22_new             ];
        d2_new  = L22_new\(eta2-L21*d1) ;
        d_up    = [d1;d2_new];
        return ;
    end
    return ;
end

end
