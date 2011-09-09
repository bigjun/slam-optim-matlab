function[factorR,isPose]=getDofRepresentation(factorR)

% TODO check al the datasets to be sure these are the only DOF possible
if factorR.data(end)==99999
    %landmark
    isPose=0;
    factorR.dof=2;
else
    %pose
    isPose=1;
    if size(factorR.data,2)>11
        factorR.dof=6;
    else
        factorR.dof=3;
    end
end
if size(factorR.data,2)==30
    factorR.representation='quaternion';
else 
    factorR.representation='Euler';
end