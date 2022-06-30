%% Apresentação de uma das aeronaves

aircraft = adt('examples/FINAISSSSSSS/project_FINALISSIMO.json');
save_project(aircraft,'examples/FINAISSSSSSS/project_FINALISSIMO.json');
%% Seletor natural para melhorar uma aeronave + sua apresentações

% Cria uma aeronave nova e melhor
name_start  = 'examples/project_starting_point_semana_8.json';
name_end    = 'examples/project_better_semana_8.json';
% Cria uma aeronave nova
aircraft = natural_selection_design(name_start);
save_project(aircraft,name_end);
% Apresenta as duas aeronaves
adt(name_start);
adt(name_end);
