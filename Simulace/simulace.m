clear all
close all
clc

i = 0;
zaloha = dir('*.mat');

if ~isempty(zaloha)
    konec = false;
    while ~konec
        for soubor=1:length(zaloha)
            disp(['[' num2str(soubor) '] - ' zaloha(soubor).name])
        end
        disp('[0] - None')
        vstup = input('Select file: ');
        if vstup == 0
            konec = true;
            startI = 1;
        elseif (vstup >= 1 && vstup <= length(zaloha))
            konec = true;
            load(zaloha(vstup).name)
            vstup = 1;
            startI = i+1;
        end
    end
else
    vstup = 0;
end
if vstup == 0
    nazev_zalohy = ['temp-' datestr(now,'ddmmyy-HHMMSS') '.mat'];
    if strcmp(getenv('os'),'Windows_NT')
        command = ['python ' pwd '\main.py'];
    else
        command = ['python ' pwd '/main.py'];
    end
    command = [command ' -t "MATLAB Simulation completed" -b "Simulation completed"'];

    pocet_tau = 100;
    pocet_prvku = 100;
    pocet_radku = floor(pocet_prvku/2);
    pocet_opakovani = 2000;
    odchylka = 10^(-6);

    x_orig = full(sprandn(pocet_prvku,1,0.1));

    vysledky = zeros(2, pocet_tau);
    vysledky(1,:) = logspace(-6,2.7,pocet_tau); % 1 - tau, 2 - prumerna chyba
    startI = 1;
end

for i = startI:pocet_opakovani
    A = randn(pocet_radku, pocet_prvku);
    y_orig = A*x_orig;
    for j = 1:pocet_tau 
        x_compute = ForwardBackward(y_orig,A,vysledky(1,j),odchylka,2500);    
        vysledky(2,j) = vysledky(2,j) + norm(x_orig - x_compute, 2)^2;
    end
    save(nazev_zalohy);
end

vysledky(2,:) = vysledky(2,:) / pocet_opakovani;

nazev = ['vysledky-' datestr(now,'ddmmyy-HHMMSS') '-' num2str(pocet_tau)];
nazev = [nazev '-' num2str(pocet_opakovani) '.xlsx'];
xlswrite(nazev, vysledky);

plot(vysledky(1,:), vysledky(2,:))

system(command);

clear odchylka i j A y_orig x_compute ans cas command nazev startI zaloha vstup nazev