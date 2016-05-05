clear all
close all
clc

video = 0;
obrazky = 1;

pocet_testu = 1;
pocet_prvku = 100;

if obrazky == 1
    f = figure('units','normalized','outerposition',[0 0 1 1]);
end
if video == 1
    v = VideoWriter('testing.avi');
    open(v)
    f = figure('units','normalized','outerposition',[0 0 1 1], 'Visible', 'off');
% f = figure();
end

for j = 1:pocet_testu
    radku = floor(pocet_prvku/2);

    %Krok 1 - tvorba ridkeho vektoru x
    x_orig = full(sprandn(pocet_prvku,1,0.1));
    
    %Krok 2 - vytvoreni obdelnikove matice A
    A = randn(radku,pocet_prvku);

    %Krok 3 - vypocteni y = A*x
    y_orig = A*x_orig;

    %Krok 4
    x_n = zeros(pocet_prvku,1);
    kroky = 5000;

    tau = 100;
    odchylka = 10^(-6);
    
    alfa = 0.1;
    
    for i = 1:kroky        
        grad = -2*A'*(y_orig-A*x_n);
        y_n = x_n - alfa*grad;
        x_n_1 = x_n;
        x_n = x_n + 1*(prox(tau*alfa,y_n)-x_n);

        if (podminka1(x_n, y_orig, A, tau, odchylka))
            if (podminka2(x_n, y_orig, A, tau, odchylka))
                if (any(isnan(x_n)))
                    x_n = x_n_1;
                end
                break
            end
        end
        
        s = x_n - x_n_1;
%         alfa = 1 / (((sum(abs(A'*A*s)))^2)/((sum(abs(A*s)))^2));
        alfa = 0.9/((norm(A'*A*s)^2)/(norm(A*s)^2));
        
        if video == 1
            plot(x_orig,'LineWidth',3)
            hold on
            plot(x_n, 'r', 'LineWidth',3)
            xlabel('indexes of data [-]')
            ylabel('value of data [-]')
            legend('original data', 'computed data')
            title(num2str(i))
            hold off
            drawnow
            writeVideo(v,getframe(f))
        elseif obrazky == 1
            plot(x_orig)
            hold on
            plot(x_n, 'r')
            title(num2str(i))
            hold off
            drawnow
        end
        
    end
    
    if video == 1 && j == kroky
        close(v)
    elseif obrazky == 1
        xlabel('indexes of data [-]')
        ylabel('value of data [-]')
        legend('original data', 'computed data')
        title(num2str(i))
        pause
    end

end
if obrazky == 1
    close all
end
clear f grad i kroky pocet_prvku radku tau y_n j pocet_testu x_n_1 obrazky video ulozit_tabulka alfa odchylka podminka1 podminka2 s w spol