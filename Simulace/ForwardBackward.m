function [ x_n ] = ForwardBackward( y, A, tau, odchylka, kroky )
    x_n = zeros(size(A, 2), 1);
    
    alfa = 0.1;
    
    for i = 1:kroky        
        grad = -2*A'*(y-A*x_n);
        
        y_n = x_n - alfa * grad;
        
        x_n_1 = x_n;
        x_n = x_n + 1 * (prox(tau * alfa, y_n) - x_n);
        
        if podminka1(x_n, y, A, tau, odchylka)
            if podminka2(x_n, y, A, tau, odchylka)
                if (sum(isnan(x_n)) > 0)
                    x_n = x_n_1;
                end
                break
            end
        end
        
        s = x_n - x_n_1;
        
        alfa = 1 / (norm(A'*A*s,1)^2/norm(A*s,1)^2);
    end
end