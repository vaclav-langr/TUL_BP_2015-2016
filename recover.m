clear all
close all
clc

num = xlsread('tabulka.xlsx');
for i = 1:size(num,1)/2
    chyba = (num(2*i-1,:) - num(i*2,:))';
    figure('units','normalized','outerposition',[0 0 1 1])
    plot(num(2*i-1,:),'b')
    hold on
    plot(num(i*2,:),'r')
    title({num2str(i),num2str(sum(chyba))})
    legend('Originalni signal','Vypocteny signal')
    hold off
    pause
    close all 
end