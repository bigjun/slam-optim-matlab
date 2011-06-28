function error=computeError(System,dm)

if strcmp(System.type,'Hessian')
    error=norm(System.Lambda*dm-System.eta); %/norm(b); end;
elseif strcmp(System.type,'CholFactor');
    error=norm(System.L'*dm-System.d);
else
    error=norm(System.A*dm-System.b); %/norm(b); end;
end


