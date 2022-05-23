%% Apresentação de uma das aeronaves

adt('examples/better_mission_final.json')

%% Seletor natural para melhorar uma aeronave + sua apresentações

% Cria uma aeronave nova e melhor
name_start  = 'examples/project_mission1final.json';
name_end    = 'examples/project_better_1.json';
% Cria uma aeronave nova
aircraft = natural_selection_design(name_start);
save_project(aircraft,name_end);
% Apresenta as duas aeronaves
adt(name_end);
adt(name_end);

