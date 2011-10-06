function factorR=processFactor(factorR,idX)
switch factorR.type
    case 'pose'
        if factorR.data(2)>factorR.data(1)
            % in this case we need to invert the edge
            factorR.data(1:2)=factorR.data(2:-1:1);
            factorR.data(3:5)=InvertEdge(factorR.data(3:5)')';
        end
        if (ismember(factorR.data(2),idX))
            if(ismember(factorR.data(1),idX))
                factorR.type='loopClosure';
            end
        else
            error('Disconnected graph!!')
        end
        
    case 'landmark'
        if(ismember(factorR.data(1),idX))
            factorR.type='newLandmark';
        end
end

switch factorR.dof
    case 2
        factorR.Sz=diag([1/factorR.data(6);1/factorR.data(8)]); % only diag cov.
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    case 3
        factorR.Sz=diag([1/factorR.data(6);1/factorR.data(8);1/factorR.data(9)]); % only diag cov.
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    case 6
        U = factorR.data(1,10:end);
        factorR.Sz=inv(sym_from_U(U, 6)); %TODO check if this is correct
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    otherwise
        error('Cannot process this data dof')
end
