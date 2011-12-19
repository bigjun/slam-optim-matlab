function[dof,factorType,rotRep]=getDofRepresentation(dataEd)

% TODO check al the datasets to be sure these are the only DOF possible

%EDGES2- 11
%LANDMARK2 -11
%EDGES3- ?
%LANDMARK3- 30

if dataEd(end)==99999
    %landmark
    if size(dataEd,2)>11
        dof=3;
        factorType='landmark3D';
    else
        dof=2;
        factorType='landmark';
    end
else
    if size(dataEd,2)>11
        dof=6;
        factorType='pose3D';

    else
        dof=3;
        factorType='pose';
    end
end

%Rotation representation
sizeEd=size(dataEd,2);
switch sizeEd
    case 11
        rotRep='yaw';
    case 30
        rotRep='quaternion';
    case 29
        rotRep='axis';
end
