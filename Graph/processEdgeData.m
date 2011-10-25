function factorR=processEdgeData(dataEd,varargin)
%factorR.data=Data.ed(ind,:);
origine=dataEd(2);
final=dataEd(1);
% dof,type,representation
if nargin>1
    [dof,factorType,obsType,representation]=getDofRepresentation(dataEd,varargin{1});
else
    [dof,factorType,obsType,representation]=getDofRepresentation(dataEd);
end
switch factorType
    case 'pose'
        if origine>final
            % in this case we need to invert the edge
            factorR.origine=final;
            factorR.final=origine;
            factorR.measure=InvertEdge(dataEd(3:5)')';
        else
            factorR.origine=origine;
            factorR.final=final;
            factorR.measure=dataEd(3:5);
        end
        factorR.type='pose';
        if nargin>2
            idX=varargin{2};
            if (ismember(origine,idX))
                if(ismember(final,idX))
                    factorR.type='loopClosure';
                end
            else
                error('Disconnected graph!!')
            end
        end
        
    case 'landmark'
        factorR.origine=origine;
        factorR.final=final;
        factorR.measure=dataEd(3:4);
        factorR.type='landmark';
        if nargin>2
            idX=varargin{2};
            if(ismember(final,idX))
                factorR.type='newLandmark';
            end
        end
end
factorR.dof=dof;
factorR.obsType=obsType;
factorR.representation=representation;

switch factorR.dof
    case 2
        factorR.Sz=diag([1/dataEd(6);1/dataEd(8)]); % only diag cov.
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    case 3
        factorR.Sz=diag([1/dataEd(6);1/dataEd(8);1/dataEd(9)]); % only diag cov.
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    case 6
        U = dataEd(10:end);
        factorR.Sz=inv(sym_from_U(U, 6)); %TODO check if this is correct
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    otherwise
        error('Cannot process this data dof')
end
