%% forma√ß√£o xfoil
% Aerodinamica
% Duarte Brito
% Com ajuda de:
% Henrique Figueiredo
% Mariana Toco Dias
% Nuno Matos

% Variaveis iniciais
iname = "input.txt"; 
perfil = "NACA0012.txt";
perfilName = "NACA0012";
saveFlnmAF = 'Save_Airfoil.txt';
pastaFigs = '\figsMatlab\';
NPanels = 90;
firstAoA = -3;
lastAoA = 15;
stepAoA = 0.25;

%% escrever o ficheiro

%apagar ficheiro com dados de iteraÁıes anteriores
if isfile(saveFlnmAF)
     % File exists.
     delete(saveFlnmAF);
end

fid = fopen(iname,'w'); %criar ficheiro de input

% Carregar o Airfoil
fprintf(fid,"PLOP\n"); %abrir op√ß√µes dos gr√°ficos
fprintf(fid,"G\n\n"); %impedir a sua cria√ß√£o

fprintf(fid,"load %s\n",perfil); % carregar o ficheiro de perfil
fprintf(fid,'PPAR\n'); %repaneling
fprintf(fid,"N %i \n", NPanels); %n√∫mero de paineis
fprintf(fid,'\n\n');

% opera√ß√µes
fprintf(fid,'OPER\n'); %iniciar opera√ß√µes
fprintf(fid,'Visc\n'); %mudar para modo viscoso
fprintf(fid,'200000\n'); %impor reinolds
fprintf(fid,'ITER 200\n'); %aumentar itera√ß√µes m√°ximas

fprintf(fid,'PACC\n'); %ativar grava√ß√£o
fprintf(fid,"%s \n\n", saveFlnmAF); %nome do ficheiro de grava√ß√£o

fprintf(fid, 'aseq\n'); %para muitos alfas
fprintf(fid, '%d\n', firstAoA); %Enter first alfa value (deg)
fprintf(fid, '%d\n', lastAoA); %Enter last  alfa value (deg)
fprintf(fid, '%f\n', stepAoA); %Enter alfa increment   (deg)

% fechar ficheiro
fclose(fid);


% correr xfoil a partir do ficheiro
cmd = 'xfoil.exe < input.txt'; %lan√ßar o programa com o comando do windows
[status,result] = system(cmd);

%% PLOT dados
fidAirfoil = fopen(saveFlnmAF); % abrir ficheiro gravado

%selecionar dados
data = textscan(fidAirfoil,'   %f   %f   %f   %f  %f   %f   %f','HeaderLines',12);

fclose(fidAirfoil); %fechar ficheiro gravado

data = cell2mat(data);
alfa = data(:, 1).'; %.' to transpose e termos um vetor e n„o uma coluna
cl = data(:, 2).';
cd = data(:, 3).';
cd0 = data(:, 4).';
cm = data(:, 3).'; %qual o sentido

%Plot cl mem funÁ„o de alfa
img1 = figure;
plot(alfa, cl);
grid on;
xlabel('alfa');
ylabel('C_l');
t = strcat('C_l(alfa)-',perfilName);
title(t);
saveas(img1, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');

%plot cl em funÁ„o de cd
img2 = figure;
plot(cd, cl);
grid on;
xlabel('C_d');
ylabel('C_l');
t = strcat('C_l(C_d) - ',perfilName);
title(t);
saveas(img2, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');

%plot cl/cd em funÁ„o de cl
ClCd = cl./cd;
img3 = figure;
plot(cl, ClCd);
grid on;
xlabel('C_l');
ylabel('C_l/C_d');
t = strcat('C_l-C_d (C_d) - ',perfilName);
title(t);
saveas(img3, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');

%plot cm em funÁ„o de alfa
img4 = figure;
plot(alfa, cm);
grid on;
xlabel('alfa');
ylabel('C_m');
t = strcat('C_m (alfa) - ',perfilName);
title(t);
saveas(img4, fullfile([strcat(pwd, pastaFigs, t)]), 'jpg');



