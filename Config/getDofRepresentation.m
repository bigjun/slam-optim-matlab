function[dof,factorType,obsType,representation]=getDofRepresentation(dataEd,varargin)

% TODO check al the datasets to be sure these are the only DOF possible

%EDGES2- 11
%LANDMARK2 -11
%EDGES3- ?
%LANDMARK3- 30

if dataEd(end)==99999
    %landmark
    factorType='landmark';
    if size(dataEd,2)>11
        dof=3;
    else
        dof=2;
    end
    if nargin >1
        obsType=varargin{1};
    else
        error('Specify the observation type');
    end
else
    factorType='pose';
    if size(dataEd,2)>11
        dof=6;
    else
        dof=3;
    end
    obsType='pose';
end

%Representation
if size(dataEd,2)==30
    representation='quaternion';
else
    representation='Euler';
end