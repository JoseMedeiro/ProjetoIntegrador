%% formação xfoil
% Aerodinamica
% Duarte Brito
% Com ajuda de:
% Henrique Figueiredo
% Mariana Toco Dias
% Nuno Matos

% Variaveis iniciais
iname = "input.txt";
perfil = "E66.dat";
NPanels = 101;
AoA1 = 0;


%% escrever o ficheiro
fid = fopen(iname,'w'); %criar ficheiro de input
fprintf(fid,"PLOP\n"); %abrir opções dos gráficos
fprintf(fid,"G\n\n"); %impedir a sua criação

% Carregar o Airfoil
fprintf(fid,"load %s\n",perfil); % carregar o ficheiro de perfil
fprintf(fid,'PPAR\n'); %repaneling
fprintf(fid,"N %i \n", NPanels); %número de paineis
fprintf(fid,'\n\n');

% operações
fprintf(fid,'OPER\n'); %iniciar operações
fprintf(fid,'Visc\n'); %mudar para modo viscoso
fprintf(fid,'400000\n'); %impor reinolds
fprintf(fid,'ITER 200\n'); %aumentar iterações máximas
fprintf(fid,"Alfa %i \n", AoA1); %explicitar angulo de ataque

% fechar ficheiro
fclose(fid);


% Correr o Xfoil com o ficheiro criado
cmd = 'xfoil.exe < input.txt'; %lançar o programa com o comando do windows
[status,result] = system(cmd); 
disp(result) %mostrar resultado



