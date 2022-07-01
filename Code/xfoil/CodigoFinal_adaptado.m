%% formação xfoil
% Aerodinamica
% Duarte Brito
% Com ajuda de:
% Henrique Figueiredo
% Mariana Toco Dias
% Nuno Matos

close all
clear all

%% 


% Variaveis iniciais
iname = "input.txt"; 

%Onde colocar o perfil a ser estudado!!!
perfil = "NACA4412.txt";
perfilName = "NACA 0010";


saveFlnmAF = 'Save_Airfoil-0010-estab.txt';
pastaFigs = '\figsMatlab\';
NPanels = 130;
firstAoA = -3;
lastAoA = 20;
stepAoA = 0.1;

%% Vari�veis do Perfil

%corda asa
%chord = 2;

%corda estabilizador 
chord = 1;
pho = 1.1;
vel = 100;
mu = 17.54e-6;

g = 9.81;                   % m/s^2

mass = 6512.9;                % kg
area1 = 20.0147;               % m^2
area2 = 20.0147;               % m^2

weight = mass*g;            % N

% N�mero de Reynolds
Re = (pho*chord*vel)/mu

% C_L da aeronave
cLGrande = weight/(0.5*pho*(vel^2)*(area1+area2))

clpequeno = 0.9*cLGrande
%% escrever o ficheiro

%apagar ficheiro com dados de itera��es anteriores
if isfile(saveFlnmAF)
     % File exists.
     delete(saveFlnmAF);
end

fid = fopen(iname,'w'); %criar ficheiro de input

% Carregar o Airfoil
fprintf(fid,"PLOP\n"); %abrir opções dos gráficos
fprintf(fid,"G\n\n"); %impedir a sua criação

%fprintf(fid,"load %s\n",perfil); % carregar o ficheiro de perfil

fprintf(fid,"%s\n",perfilName);
fprintf(fid,'PPAR\n'); %repaneling
fprintf(fid,"N %i \n", NPanels); %número de paineis
fprintf(fid,'\n\n');

% operações
fprintf(fid,'OPER\n'); %iniciar operações
fprintf(fid,'Visc\n'); %mudar para modo viscoso

% ALTERAR REYNOLDS PARA ALGO QUE FA�A SENTIDO � NOSSA AERONAVE
fprintf(fid,'%f\n', Re); 

fprintf(fid,'ITER 200\n'); %aumentar iterações máximas

%comando seqp - faz plot do cl em fun��o de mts coisas
%fprintf(fid,'seqp\n');

fprintf(fid,'PACC\n'); %ativar gravação
fprintf(fid,"%s \n\n", saveFlnmAF); %nome do ficheiro de gravação

fprintf(fid, 'aseq\n'); %para muitos alfas
fprintf(fid, '%d\n', firstAoA); %Enter first alfa value (deg)
fprintf(fid, '%d\n', lastAoA); %Enter last  alfa value (deg)
fprintf(fid, '%f\n', stepAoA); %Enter alfa increment   (deg)

% fechar ficheiro
fclose(fid);


% correr xfoil a partir do ficheiro
cmd = 'xfoil.exe < input.txt'; %lançar o programa com o comando do windows
[status,result] = system(cmd);

%% PLOT dados
fidAirfoil = fopen(saveFlnmAF); % abrir ficheiro gravado

%selecionar dados
data = textscan(fidAirfoil,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);

fclose(fidAirfoil); %fechar ficheiro gravado

data = cell2mat(data);
alfa = data(:, 1).'; %.' to transpose e termos um vetor e n�o uma coluna
cl = data(:, 2).';
cd = data(:, 3).';
cd0 = data(:, 4).';
cm = data(:, 5).'; %qual o sentido

%Plot cl mem fun��o de alfa
img1 = figure;
plot(alfa, cl);
grid on;
xlabel('alfa');
ylabel('C_l');
t = strcat(perfilName,' - C_l(alfa) - estab Vertical');
title(t);
saveas(img1, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img1, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cl em fun��o de cd
img2 = figure;
plot(cd, cl);
grid on;
xlabel('C_d');
ylabel('C_l');
t = strcat(perfilName, ' - C_l(C_d) - estab Vertical');
title(t);
saveas(img2, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img2, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cl/cd em fun��o de cl
ClCd = cl./cd;
img3 = figure;
plot(cl, ClCd);
grid on;
xlabel('C_l');
ylabel('C_l/C_d');
t = strcat(perfilName, ' - C_l-C_d (C_l) - estab Vertical');
title(t);
saveas(img3, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img3, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');

%plot cm em fun��o de alfa
%VER EM QUE SENTIDO XFOIL D� O CM
img4 = figure;
plot(alfa, cm);
grid on;
xlabel('alfa');
ylabel('C_m');
t = strcat(perfilName, ' - C_m (alfa) - estab Vertical');
title(t);
saveas(img4, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');
saveas(img4, fullfile([strcat(pwd, pastaFigs, t)]), 'fig');



