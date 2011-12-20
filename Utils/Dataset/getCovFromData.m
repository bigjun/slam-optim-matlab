function Cov = getCovFromData(U, m)
    Cov = tril(ones(m));
    Cov(Cov==1) = U;
    Cov = Cov';
    Cov = Cov + tril(Cov.',-1);
end