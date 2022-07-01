function data = natural_selection_design(filename)
%% Constants
global constants;
constants.g = 9.81; % m/s^2
MAX_GEN                     = 50;
MAX_GEN_WITHOUT_IMPROVEMENT = 10;
SIZE_POP                    = 100;
BEST_BOYS                   = 10;
SONS                        = (SIZE_POP-BEST_BOYS)/BEST_BOYS;
conter_MGWI = 0;
%% Load project file (will be first pick)
data = load_project(filename);
population(1) = data;
%% Add missing mission segment common throughout all of the species
data.mission = build_mission(data.mission);
%% First creation

for c=2:SIZE_POP
    population(c) = scramble_aircraft(data);
    fprintf("%d planes made.\n",c);
end

for c=0:MAX_GEN
    %% Scrambles the items
    if(c~=0)
        for d=1:BEST_BOYS
            for e=BEST_BOYS+SONS*(d-1)+1:BEST_BOYS+SONS*d
                population(e) = scramble_aircraft(population(d));
            end
        end
    end
    %% Rates them
    for d=1:size(population,2)
        results(d) = gets_rating_design(population(d));
        fprintf("%d planes rated - %f.\n",d,results(d));
    end
    %% Sorts
    [~,I] = sort(results, 'descend');
    population = population(I);    
    %% Verifies Conditions
    if I(1) == 1
        conter_MGWI = conter_MGWI +1;
    else
        conter_MGWI = 0;
    end
    if conter_MGWI >= MAX_GEN_WITHOUT_IMPROVEMENT
       break; 
    end
    fprintf("%d gen.\n",c);
end

data = population(1);
