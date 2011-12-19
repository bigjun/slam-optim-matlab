function factorR=processEdgeData(dataEd,varargin)
%factorR.data=Data.ed(ind,:);

origine=dataEd(2);
final=dataEd(1);

% dof,type,representation
[dof,factorType,rotRep]=getDofRepresentation(dataEd);

switch factorType
    case 'pose'
        if origine>final
            % in this case we need to invert the edge
            factorR.origine=final;
            factorR.final=origine;
            factorR.measure=InvertEdgePose(dataEd(3:5)')';
        else
            factorR.origine=origine;
            factorR.final=final;
            factorR.measure=dataEd(3:5);
        end
        factorR.type='pose';
        if nargin>2
            idX=varargin{2};
            if (ismember(factorR.origine,idX))
                if(ismember(factorR.final,idX))
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
        switch nargin
            case 2
                obsType=varargin{1};
            case 3
                obsType=varargin{1};
                idX=varargin{2};
                if(ismember(final,idX))
                    factorR.type='newLandmark';
                end
        end
    case 'pose3D'      
        if origine>final
            % in this case we need to invert the edge
            factorR.origine=final;
            factorR.final=origine;
            switch rotRep
                case 'quaternion'
                    factorR.measure=[dataEd(3:5),quaternion2Axis(dataEd(6:9))];
                case 'axis'
                    factorR.measure=dataEd(3:8);
                otherwise
                    error('This 3D representation is not implemented');
            end
            factorR.measure=InvertEdgePose3D(factorR.measure')';
            %inverted
        else
            factorR.origine=origine;
            factorR.final=final;
            switch rotRep
                case 'quaternion'
                    factorR.measure=[dataEd(3:5),quaternion2Axis(dataEd(6:9))];
                case 'axis'
                    factorR.measure=dataEd(3:8);
                otherwise
                    error('This 3D representation is not implemented');
            end
        end

        factorR.type='pose3D';
        if nargin>2
            idX=varargin{2};
            if (ismember(factorR.origine,idX))
                if(ismember(factorR.final,idX))
                    factorR.type='loopClosure3D';
                end
            else
                error('Disconnected graph!!')
            end
        end
        
    case 'landmark3D'
        factorR.origine=origine;
        factorR.final=final;
        factorR.measure=dataEd(3:5);
        factorR.type='landmark3D';
        if nargin>2
            idX=varargin{2};
            if(ismember(final,idX))
                factorR.type='newLandmark3D';
            end
        end
end
factorR.dof=dof;
if nargin>1
    factorR.obsType=varargin{1};
else
    factorR.obsType='pose';
end
factorR.representation=rotRep;

switch factorR.dof
    case 2
        factorR.Sz=diag([1/dataEd(6);1/dataEd(8)]); % only diag cov.
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    case 3
        factorR.Sz=diag([1/dataEd(6);1/dataEd(8);1/dataEd(9)]); % only diag cov.
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    case 6
        U = dataEd(end-20:end);
        factorR.Sz=inv(getCovFromData(U, 6)); %TODO check if this is correct
        factorR.R=chol(inv(factorR.Sz)); %S^(-1/2)
    otherwise
        error('Cannot process this data dof')
end
