%% Briefing
%
% Serao dados vários motores para serem analisados, a fim de se encontrarem
% razões de potencia/peso para diferentes gamas de potencia disponivel. A
% relevancia desta função prende-se com a necessidade de dimensionalisar
% dinamicamente os motores para iterar no design da aeronave (e
% possibilidade de se conceber um motor com caracteristicas de potência ou
% peso intermédios, mantendo P/W constantes).
%
% É necessário dar ao programa os motores, num ficheiro .JSON, e o output é
% um gráfico da potência em função do peso com os motores representados e 
% um conjunto de retas aproximadas para o P/W, assim como numericamente os 
% limites superiores e inferiores de potencia validos, o declive e o valor
% inicial (numa matriz? Numa estrutura? não sei ainda)
%
%% Declaracao inicial dos ficheiros
text_data_file  = 'text_data/';
input_string    = [text_data_file 'engine_data_start.JSON'];
output_string   = [text_data_file 'engine_data_end.JSON'];

%% Leitura dos motores disponíveis e criação de estimativas W/P

real_engines    = read_file_engines(input_string);
complex_engines = fill_engines(real_engines);

%% Plot do gráfico com os motores e curvas aproximadas

figure();
hold on;

for c=1:size(complex_engines)
    
    x = complex_engines{c}.min_weigh:100:complex_engines{c}.max_weigh;
    f = x.*complex_engines{c}.slope + complex_engines{c}.p_0;
    
    plot(x, f);
    plot(real_engines{c}.weight,real_engines{c}.power,'x');
    
end

%% Escrita do ficheiro com os resultados

real_engines    = write_file_engines(complex_engines);

