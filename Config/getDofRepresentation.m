function[factorR]=getDofRepresentation(factorR,varargin)

% TODO check al the datasets to be sure these are the only DOF possible

%EDGES2- 11
%LANDMARK2 -11
%EDGES3- ?
%LANDMARK3- 30

if factorR.data(end)==99999
    %landmark
    factorR.type='landmark';
    if size(factorR.data,2)>11
        factorR.dof=3;
    else
        factorR.dof=2;
    end
    if nargin >1
        factorR.obsType=varargin{1};
    else
        error('Specify the observation type');
    end
else
    factorR.type='pose';
    if size(factorR.data,2)>11
        factorR.dof=6;
    else
        factorR.dof=3;
    end
    factorR.obsType='pose';
end

%Representation
if size(factorR.data,2)==30
    factorR.representation='quaternion';
else
    factorR.representation='Euler';
end