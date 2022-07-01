%% Aircraft build tool - Engine Expansion Pack
% 
% José Medeiro (josemedeiro@tecnico.ulisboa.pt)
%
% This file is subject to the license terms in the LICENSE file included in
% this distribution (I guess)
%
%% Preambulo
%
% Serao dados vários motores para serem analisados, a fim de se encontrarem
% razões de potencia/peso para diferentes gamas de potencia disponivel. A
% relevancia desta função prende-se com a necessidade de dimensionalisar
% dinamicamente os motores para iterar no design da aeronave (e
% possibilidade de se conceber um motor com caracteristicas de potência ou
% peso intermédios, mantendo P/W constantes).
%
%% Briefing
%
% Performs and writes the analysis of all sets of types of engines given in
% a series of .JSON files and gives a set of plots showing the results 
% obtained (data point collection and linear regression curves).
%
% Being a main function, it does not have inputs. However, it is necessary
% to hardwire the files, messing in the "text_data_classes" array of
% strings (can be automated, did't bothered doing it for the time being).
%
% The indirect output are a set of files with the analysis of the several
% engine classes (normalized as "types" in the mother program for the most
% part) that are divided in which input file.
%
%% Declaracao inicial dos ficheiros
text_data_folder    = 'text_data/';
image_data_folder   = 'figure_data/';
text_data_classes   = [ "Turboshafts_data_start"       ;...
                         "EletricMotors"                ;...
                         "EletricGenerators_data_start" ];
c_power             = [0;1;0];
for c=1:length(text_data_classes)
    input_file(c,1)         = join([text_data_folder, text_data_classes(c), '.JSON'],"");
    output_text_file(c,1) 	= join([text_data_folder, text_data_classes(c), '_data_end.JSON'],"");
    output_image_file(c,1) 	= join([image_data_folder, text_data_classes(c), '.png'],"");
end
%% Realização da análise de cada um dos ficheiros

for c=1:length(text_data_classes)
    
    Engine_Build(input_file(c),output_text_file(c),output_image_file(c),c_power(c));
    
end


