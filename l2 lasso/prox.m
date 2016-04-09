function [ output ] = prox(tau,x)
    output = x;
    for i = 1:length(output)
        if abs(output(i)) <= tau
            output(i) = 0;
        elseif output(i) < 0
            output(i) = output(i)+tau;
        elseif output(i) > 0
            output(i) = output(i)-tau;
        end
    end
end