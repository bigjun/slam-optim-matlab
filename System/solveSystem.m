function [dm,time_solve]=solveSystem(System)
if strcmp(System.type,'Hessian')
    ck=cputime;
    dm=cs_cholsol(System.Lambda,System.eta,3);
    time_solve=(cputime-ck);
elseif strcmp(System.type,'CholFactor');
    ck=cputime;
    dm=System.L'\System.d;
    time_solve=(cputime-ck);
else
    ck=cputime;
    dm=spqr_solve(System.A,System.b,struct('ordering','colamd'));
    time_solve=(cputime-ck);
end



