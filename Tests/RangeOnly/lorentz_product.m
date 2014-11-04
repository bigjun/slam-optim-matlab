function l = lorentz_product(u,v)

if (size(u,1)==4) & (size(v,1)==4)
    l = u(1:3)'*v(1:3) - u(4)*v(4);
else
    error('Bad sized vectors, 1x4 is the correct size')
end