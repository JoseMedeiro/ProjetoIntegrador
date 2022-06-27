%% Carregar uma aeronave
aircraft    = load_project('examples/project_starting_point_semana_8.json');
mesh        = 20;
%% Variar Velocidade de Cruzeiro        - 1
V_cruise    = linspace(60,140,mesh);
%% Variar AR e Corda ?                  - 2

%% Variar Disc Loading                  - 3
Radius      = linspace(1,2,mesh);

MTOW        = zeros(mesh,mesh);
%% 1 e 2
for c=1:mesh
    aircraft_1 = change_value('speed', V_cruise(c), aircraft);
    for d=1:mesh
        aircraft_1 = change_value('speed', V_cruise(c), aircraft_1);
        MTOW(c,d) = aircraft_1.vehicle.mass;
    end
end
figure();
surf(V_cruise,V_cruise,MTOW);
xlabel('Cruise Velocity [m/s]');
ylabel('Cruise Velocity [m/s]');
zlabel('MTOW [kg]');
%% 2 e 3
for c=1:mesh
    aircraft_1 = change_value('speed', V_cruise(c), aircraft);
    for d=1:mesh
        aircraft_1 = change_value('radius', Radius(c), aircraft_1);
        MTOW(c,d) = aircraft_1.vehicle.mass;
    end
end
figure();
surf(V_cruise,V_cruise,MTOW);
xlabel('Cruise Velocity [m/s]');
xlabel('Radius of propeller [m/s]');
zlabel('MTOW [kg]');
%% 3 e 1
for c=1:mesh
    aircraft_1 = change_value('radius', Radius(c), aircraft);
    for d=1:mesh
        aircraft_1 = change_value('speed', V_cruise(c), aircraft_1);
        MTOW(c,d) = aircraft_1.vehicle.mass;
    end
end
figure();
surf(V_cruise,V_cruise,MTOW);
xlabel('Radius of propeller [m/s]');
ylabel('Cruise Velocity [m/s]');
zlabel('MTOW [kg]');

function aircraft = change_value(name_change, value_change, data)

if(strcmp(name_change,'speed'))
    data.mission.segments{4}.velocity       = value_change;
    data.mission.segments{12}.velocity      = value_change;
end
if(strcmp(name_change,'wing'))
    % Main Wing
    data.vehicle.components{6}.aspect_ratio = value_change(1);
    data.vehicle.components{6}.mean_chord   = value_change(2);
    % Back Wing
    data.vehicle.components{7}.aspect_ratio = value_change(1);
    data.vehicle.components{7}.mean_chord   = value_change(2);
end
if(strcmp(name_change,'radius'))
    data.vehicle.components{12}.radius  = value_change;
end
% Add missing mission segment and vehicle component parameters
data.mission = build_mission(data.mission);
data.vehicle = build_vehicle(data.mission, data.vehicle);

%% Mission analyses
data.vehicle = aero_analysis(data.mission, data.vehicle);
[data.mission, data.vehicle] = mass_analysis(data.mission, data.vehicle, data.energy);
data         = propeller_efficiency_analysis(data);
[data.mission, data.vehicle] = mass_analysis(data.mission, data.vehicle, data.energy);

aircraft = data;

end
