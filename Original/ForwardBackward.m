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
    kroky = 5000;

    tau = 0.1;
%     x_n_1 = ones(pocet_prvku,1);
    
%     w = diag(ones(1,pocet_prvku)*tau);
    odchylka = 10^(-6);
%     odchylka = 0.05;
    
    alfa = 0.1;
    
    for i = 1:kroky        
        grad = -2*A'*(y_orig-A*x_n);
        y_n = x_n - alfa*grad;
        x_n_1 = x_n;
        x_n = x_n + 1*(prox(tau*alfa,y_n)-x_n);
        
%         spol = A'*(A*x_n-y_orig);
%         podminka1 = sum(abs(spol + w*sign(x_n)) < odchylka) > 95;
%         podminka2 = sum(abs(spol) - tau < odchylka) == pocet_prvku;
%         if(podminka1(x_n, y_orig, A, tau, odchylka) && podminka2(x_n, y_orig, A, tau, odchylka))
%             break
%         end
        if (podminka1(x_n, y_orig, A, tau, odchylka))
            if (podminka2(x_n, y_orig, A, tau, odchylka))
                if (sum(isnan(x_n)) > 0)
                    x_n = x_n_1;
                end
                break
            end
        end
        
        s = x_n - x_n_1;
        alfa = 1 / (((sum(abs(A'*A*s)))^2)/((sum(abs(A*s)))^2));
        
        if video == 1
            plot(x_orig)
            hold on
            plot(x_n, 'r')
            title({[num2str(round(i/kroky * 100)) ' %'], num2str(sum(abs(x_orig-x_n))), num2str(alfa)})
            hold off
            drawnow
            writeVideo(v,getframe(f))
        elseif obrazky == 1
            plot(x_orig)
            hold on
            plot(x_n, 'r')
            title({num2str(i), num2str(sum(abs(x_orig-x_n))), num2str(alfa)})
            hold off
            drawnow
        end
        
    end
    
    if video == 1 && j == pocet_kroku
        close(v)
    elseif obrazky == 1
        title({['Konec - ' num2str(i)], num2str(sum(abs(x_orig-x_n)))})
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
clear f grad i kroky pocet_prvku radku tabulka tau y_n j pocet_testu x_n_1 obrazky video ulozit_tabulka alfa odchylka podminka1 podminka2 s w spol