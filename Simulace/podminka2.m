function [ vystup ] = podminka2( x, y, A, tau, odchylka )
    indexy = find(abs(x) <= odchylka);
    
    L_term = abs((A(:,indexy))' * (A * x - y));
    
    vystup = (sum(L_term < tau) == length(indexy));
end