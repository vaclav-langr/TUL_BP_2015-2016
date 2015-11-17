clear all
close all
clc

video = 0;
obrazky = 1;
ulozit_tabulka = 0;

pocet_testu = 1;
pocet_prvku = 100;

if obrazky == 1
    f = figure('units','normalized','outerposition',[0 0 1 1]);
end
if video == 1
    v = VideoWriter('testing.avi');
    open(v)
    f = figure('units','normalized','outerposition',[0 0 1 1], 'Visible', 'off');
end
if ulozit_tabulka == 1
    tabulka = zeros(pocet_testu,pocet_prvku);
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
    kroky = 2500;

    % tau = 0.00021;
    tau = 0.04;
    x_n_1 = ones(pocet_prvku,1);
    for i = 1:kroky
        if (sum(abs(x_n_1-x_n)) < 0.0000000001)
            break
        end
        if (sum(abs(x_n_1-x_n)) < 0.0000005 && tau == 0.0002)
            tau = 0.00001;
        end
        if (sum(abs(x_n_1-x_n)) < 0.0000005 && tau == 0.003)
            tau = 0.0002;
        end
        if (sum(abs(x_n_1-x_n)) < 0.0000005 && tau == 0.04)
            tau = 0.003;
        end
    %     b = sum(abs((-2*A'*(y_orig-A*x_n) + 2*A'*(y_orig-A*y_n))));
    %     if sum(abs(x_n-y_n)) ~= 0
    %         b = b / sum(abs(x_n-y_n));
    %     end
    %     if b == 0
    %         b = 1;
    %     else
    %         b = abs(ceil(b));
    %     end
    %     e = min(1,1/b)/2;
        grad = -2*A'*(y_orig-A*x_n);
    %     l = (e + (2/b - e))/2;
        y_n = x_n - 0.001855*grad;
    %     lambda = (e + l)/2;
        x_n_1 = x_n;
        x_n = x_n + 1*(prox(tau,y_n)-x_n);
        
        if video == 1
            plot(x_orig)
            hold on
            plot(x_n, 'r')
            title({[num2str(round(i/kroky * 100)) ' % - ' num2str(tau)], num2str(sum(abs(x_orig-x_n)))})
            hold off
            drawnow
            writeVideo(v,getframe(f))
        elseif obrazky == 1
            plot(x_orig)
            hold on
            plot(x_n, 'r')
            title({[num2str(round(i/kroky * 100)) ' % - ' num2str(tau)], num2str(sum(abs(x_orig-x_n)))})
            hold off
            drawnow
        end
        
    end
    
    if video == 1 && j == pocet_kroku
        close(v)
    elseif obrazky == 1
        title({['Konec - ' num2str(tau)], num2str(sum(abs(x_orig-x_n)))})
        pause
    end
    if ulozit_tabulka == 1
        tabulka(j*2-1,:) = x_orig';
        tabulka(j*2,:) = x_n';
    end

end
if ulozit_tabulka == 1
    delete('tabulka.xlsx');
    xlswrite('tabulka.xlsx',tabulka);
end
if obrazky == 1
    close all
end
clear f grad i kroky pocet_prvku radku tabulka tau y_n j pocet_testu x_n_1 obrazky video ulozit_tabulka