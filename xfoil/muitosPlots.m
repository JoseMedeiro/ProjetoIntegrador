clear all;
close all;

%% asa 
pastaFigs = '\figsMatlab\todos\';
fidAirfoil1 = fopen('Save_Airfoil-2412.txt'); % abrir ficheiro gravado
data1 = textscan(fidAirfoil1,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12); %selecionar dados
fclose(fidAirfoil1); %fechar ficheiro gravado

fidAirfoil2 = fopen('Save_Airfoil-2414.txt'); % abrir ficheiro gravado
data2 = textscan(fidAirfoil2,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);
fclose(fidAirfoil2); %fechar ficheiro gravado


fidAirfoil3 = fopen('Save_Airfoil-4412.txt'); % abrir ficheiro gravado
data3 = textscan(fidAirfoil3,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);
fclose(fidAirfoil3); %fechar ficheiro gravado

fidAirfoil4 = fopen('Save_Airfoil-23015.txt'); % abrir ficheiro gravado
data4 = textscan(fidAirfoil4,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);
fclose(fidAirfoil4); %fechar ficheiro gravado

data1 = cell2mat(data1);
data2 = cell2mat(data2);
data3 = cell2mat(data3);
data4 = cell2mat(data4);
alfa1 = data1(:, 1).'; %.' em teoria o alfa é igual para todos
alfa2 = data2(:, 1).';
alfa3 = data3(:, 1).';
alfa4 = data4(:, 1).';
cl1 = data1(:, 2).';
cl2 = data2(:, 2).';
cl3 = data3(:, 2).';
cl4 = data4(:, 2).';
cd1 = data1(:, 3).';
cd2 = data2(:, 3).';
cd3 = data3(:, 3).';
cd4 = data4(:, 3).';
cm1 = data1(:, 5).'; %qual o sentido
cm2 = data2(:, 5).';
cm3 = data3(:, 5).';
cm4 = data4(:, 5).';

%Plot cl mem função de alfa
img1 = figure;
plot(alfa1, cl1, 'r');
hold on;
plot(alfa2, cl2, 'b');
hold on;
plot(alfa3, cl3, 'g');
hold on;
plot(alfa4, cl4, 'y');
hold off;
grid on;
xlabel('alfa');
ylabel('C_l');
legend('NACA 2212', 'NACA 2214', 'NACA 4412', 'NACA 23015', 'Location', 'southeast');
t = 'C_l(alfa)';
title(t);
saveas(img1, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img1, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cl em função de cd
img2 = figure;
plot(cd1, cl1, 'r');
hold on;
plot(cd2, cl2, 'b');
hold on;
plot(cd3, cl3, 'g');
hold on;
plot(cd4, cl4, 'y');
hold off;
grid on;
xlabel('C_d');
ylabel('C_l');
legend('NACA 2212', 'NACA 2214', 'NACA 4412', 'NACA 23015', 'Location', 'southeast');
t = 'C_l(C_d)';
title(t);
saveas(img2, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img2, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cl/cd em função de cl
ClCd1 = cl1./cd1;
ClCd2 = cl2./cd2;
ClCd3 = cl3./cd3;
ClCd4 = cl4./cd4;

img3 = figure;
plot(cl1, ClCd1, 'r');
hold on;
plot(cl2, ClCd2, 'b');
hold on;
plot(cl3, ClCd3, 'g');
hold on;
plot(cl4, ClCd4, 'y');
hold off;
grid on;
xlabel('C_l');
ylabel('C_l/C_d');
legend('NACA 2212', 'NACA 2214', 'NACA 4412', 'NACA 23015', 'Location', 'southeast');
t = 'C_l-C_d (C_l)';
title(t);
saveas(img3, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img3, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cm em função de alfa
%VER EM QUE SENTIDO XFOIL DÁ O CM
img4 = figure;
plot(alfa1, cm1, 'r');
hold on;
plot(alfa2, cm2, 'b');
hold on;
plot(alfa3, cm3, 'g');
hold on;
plot(alfa4, cm4, 'y');
hold off;
grid on;
xlabel('alfa');
ylabel('C_m');
t = 'C_m (alfa)';
legend('NACA 2212', 'NACA 2214', 'NACA 4412', 'NACA 23015', 'Location', 'southeast');
title(t);
saveas(img4, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img4, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%% estabilizador 

pastaFigs = '\figsMatlab\todos\estab\';

fidAirfoil1 = fopen('Save_Airfoil-0006-estab.txt'); % abrir ficheiro gravado
data1 = textscan(fidAirfoil1,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12); %selecionar dados
fclose(fidAirfoil1); %fechar ficheiro gravado

fidAirfoil2 = fopen('Save_Airfoil-0010-estab.txt'); % abrir ficheiro gravado
data2 = textscan(fidAirfoil2,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);
fclose(fidAirfoil2); %fechar ficheiro gravado


fidAirfoil3 = fopen('Save_Airfoil-0012-estab.txt'); % abrir ficheiro gravado
data3 = textscan(fidAirfoil3,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);
fclose(fidAirfoil3); %fechar ficheiro gravado

fidAirfoil4 = fopen('Save_Airfoil-0014-estab.txt'); % abrir ficheiro gravado
data4 = textscan(fidAirfoil4,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);
fclose(fidAirfoil4); %fechar ficheiro gravado

data1 = cell2mat(data1);
data2 = cell2mat(data2);
data3 = cell2mat(data3);
data4 = cell2mat(data4);
alfa1 = data1(:, 1).'; %.' em teoria o alfa é igual para todos
alfa2 = data2(:, 1).';
alfa3 = data3(:, 1).';
alfa4 = data4(:, 1).';
cl1 = data1(:, 2).';
cl2 = data2(:, 2).';
cl3 = data3(:, 2).';
cl4 = data4(:, 2).';
cd1 = data1(:, 3).';
cd2 = data2(:, 3).';
cd3 = data3(:, 3).';
cd4 = data4(:, 3).';
cm1 = data1(:, 5).'; %qual o sentido
cm2 = data2(:, 5).';
cm3 = data3(:, 5).';
cm4 = data4(:, 5).';

%Plot cl mem função de alfa
img1 = figure;
plot(alfa1, cl1, 'r');
hold on;
plot(alfa2, cl2, 'b');
hold on;
plot(alfa3, cl3, 'g');
hold on;
plot(alfa4, cl4, 'y');
hold off;
grid on;
xlabel('alfa');
ylabel('C_l');
legend('NACA 0006', 'NACA 0010', 'NACA 0012', 'NACA 0014', 'Location', 'southeast');
t = 'C_l(alfa)';
title(t);
saveas(img1, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img1, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cl em função de cd
img2 = figure;
plot(cd1, cl1, 'r');
hold on;
plot(cd2, cl2, 'b');
hold on;
plot(cd3, cl3, 'g');
hold on;
plot(cd4, cl4, 'y');
hold off;
grid on;
xlabel('C_d');
ylabel('C_l');
legend('NACA 0006', 'NACA 0010', 'NACA 0012', 'NACA 0014', 'Location', 'southeast');
t = 'C_l(C_d)';
title(t);
saveas(img2, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img2, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cl/cd em função de cl
ClCd1 = cl1./cd1;
ClCd2 = cl2./cd2;
ClCd3 = cl3./cd3;
ClCd4 = cl4./cd4;

img3 = figure;
plot(cl1, ClCd1, 'r');
hold on;
plot(cl2, ClCd2, 'b');
hold on;
plot(cl3, ClCd3, 'g');
hold on;
plot(cl4, ClCd4, 'y');
hold off;
grid on;
xlabel('C_l');
ylabel('C_l/C_d');
legend('NACA 0006', 'NACA 0010', 'NACA 0012', 'NACA 0014', 'Location', 'southeast');
t = 'C_l-C_d (C_l)';
title(t);
saveas(img3, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img3, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cm em função de alfa
%VER EM QUE SENTIDO XFOIL DÁ O CM
img4 = figure;
plot(alfa1, cm1, 'r');
hold on;
plot(alfa2, cm2, 'b');
hold on;
plot(alfa3, cm3, 'g');
hold on;
plot(alfa4, cm4, 'y');
hold off;
grid on;
xlabel('alfa');
ylabel('C_m');
t = 'C_m (alfa)';
legend('NACA 0006', 'NACA 0010', 'NACA 0012', 'NACA 0014', 'Location', 'southeast');
title(t);
saveas(img4, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img4, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

