%leitura dados
ficheiro = fopen ('engines2.txt','r');
dados    = textscan(ficheiro, '%s %s %d; %d; %d; %d', 'Headerlines', 1);
fclose (ficheiro);
%ficheiro com dados em unidades si
ficheiro = fopen('engines_SI_1.txt','w');
fprintf(ficheiro, 'NAME; TYPE; POWER; MAX POWER; WEIGHT; WIEGHT2\n');

% Passagem de células a vetores de strings
dados{1} = string(dados{1});
dados{2} = string(dados{2});

for i=1:size(dados{1},1)
    %conversao para unidades si
    dados{3}(i) = dados{3}(i)*745.699872;
    dados{4}(i) = dados{4}(i)*745.699872;
    dados{5}(i) = dados{5}(i)*0.45359237;
    dados{6}(i) = dados{6}(i)*0.45359237;
        
    %escrever dados no ficheiro
    fprintf(ficheiro,'%s ; %s ; %d ; %d ; %d ; %d\n', dados{1}(i),dados{2}(i),dados{3}(i),dados{4}(i),dados{5}(i),dados{6}(i));
end

fclose (ficheiro);