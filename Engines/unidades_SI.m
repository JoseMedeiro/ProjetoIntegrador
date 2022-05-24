%leitura dados
ficheiro = fopen ('engines2.txt','r');
dados    = textscan(ficheiro, '%s %s %d; %d; %d; %d', 'Headerlines', 1);

%ficheiro com dados em unidades si
ficheiro = fopen('engines_SI.txt','w');
fprintf('engines_SI.txt', 'NAME; TYPE; POWER; MAX POWER; WEIGHT; WIEGHT2\n');

%passar dados para matriz
for i=1:size(dados,1)
    x(i,1)= dados{1}(i);
    x(i,2)= dados{2}(i);
end 

for i=1:size(dados,1)
    %conversao para unidades si
    dados{3}(i) = dados{3}(i)*745.699872;
    dados{4}(i) = dados{4}(i)*745.699872;
    dados{5}(i) = dados{5}(i)*0.45359237;
    dados{6}(i) = dados{6}(i)*0.45359237;
    
    for n=1:1:4
        y(i,n)= dados{n}(i);
    end    
    
    %escrever dados no ficheiro
    fprintf('engines_SI.txt','%s %s %d; %d; %d; %d\n', x(i,1),x(i,2),y(i,1),y(i,2),y(i,3),y(i,4))   
end    
