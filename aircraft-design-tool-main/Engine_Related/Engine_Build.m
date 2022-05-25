%% Aircraft build tool - Engine Expansion Pack
% 
% José Medeiro (josemedeiro@tecnico.ulisboa.pt)
%
% This file is subject to the license terms in the LICENSE file included in
% this distribution (I guess)
%
%% Briefing
%
% Performs and writes the analysis of a set of types of engines given in a
% .JSON file and gives a plot showing the results obtained (data point
% collection and linear regression curves).
%
% The inputs are the input and output file names.
%
% The output is the structure with the analysis;
% The indirect output is a .JSON file containing the output information.
%
%% Function
function complex_engines = Engine_Build(input_file,output_text_file,output_image_file)
%% Leitura dos motores disponíveis e criação de estimativas W/P

real_engines    = read_file_engines(input_file);
complex_engines = fill_engines(real_engines);

%% Plot do gráfico com os motores e curvas aproximadas

image = figure('WindowState', 'maximized');
hold on;
n = 0;

for c=1:length(complex_engines.engine_set)
    
    x_aproximado = linspace(complex_engines.engine_set{c}.min_weight,complex_engines.engine_set{c}.max_weight,100);
    y_aproximado = x_aproximado.*complex_engines.engine_set{c}.b1 + complex_engines.engine_set{c}.b0;
    
    for d=1:size(real_engines.engine_set{c}.engines,1)
        plot(real_engines.engine_set{c}.engines{d}.mass,...
            real_engines.engine_set{c}.engines{d}.max_power,...
            'x');
        legend_cell{n+d} =  real_engines.engine_set{c}.engines{d}.name;
        %x_real(d) = real_engines.engine_set{c}.engines{d}.mass;
        %y_real(d) = real_engines.engine_set{c}.engines{d}.max_power;
    end
    %plot(x_real,y_real,'x');
    %legend_cell{2*c -1} = real_engines.engine_set{c}.name;
    
    n = n+d +1;
    plot(x_aproximado, y_aproximado);
    legend_cell{n} = ['RL de ' real_engines.engine_set{c}.name];
    %legend_cell{2*c} = real_engines.engine_set{c}.name;
end

legend(legend_cell,'Location','eastoutside','NumColumns', 2);
hold off;

saveas(image,output_image_file);
image.WindowState = 'normal';
%% Escrita do ficheiro com os resultados

fid=fopen(output_text_file,'w');

encodedJSON = jsonencode(complex_engines);
encodedJSON = strrep(encodedJSON, ',', sprintf(',\r'));
encodedJSON = strrep(encodedJSON, '},', sprintf('\r},'));
encodedJSON = strrep(encodedJSON, ']', sprintf(']\r'));
encodedJSON = strrep(encodedJSON, '[{', sprintf('[\r{'));
encodedJSON = strrep(encodedJSON, '}]', sprintf('\r}\r]'));

fprintf(fid, encodedJSON); 
fclose('all');

end
