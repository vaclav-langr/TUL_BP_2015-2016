clear all
close all
clc

soubory = dir('*.xlsx');
for i = 1:length(soubory)
    num = xlsread(soubory(i).name);
    figure
    plot(num(1,:),num(2,:))
    set(gca,'xscale','log')
    set(gca,'yscale','log')
end