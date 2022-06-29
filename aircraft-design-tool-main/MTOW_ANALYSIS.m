%% Carregar uma aeronave
aircraft    = load_project('examples/FINAISSSSSSS/project_starting_point_semana_8.json');
mesh        = 20;
%% Variar Velocidade de Cruzeiro            - 1
V_cruise    = linspace(100,150,mesh);
%% Variar AR e Corda Span maximo = 14 m   	- 2
S_0             = 45;
AR_0            = 5;
c_0             = 2;
% Para superficie constante (corda cte.)                        - 2.1
escala          = linspace(0.75,1.25,mesh);
AR_scale(1,:)   = AR_0*escala;
AR_scale(2,:)  	= c_0*(1./sqrt(escala));
% Para superficie a dimnuir (varia linearmente tudo o resto)    - 2.2
S_scale(1,:)   	= S_0*escala;
S_scale(2,:)    = AR_0*(escala.^0);
S_scale(3,:)    = c_0*(sqrt(escala));
%% Variar Disc Loading                      - 3
Radius      = linspace(1.1,2.1,mesh);

MTOW        = zeros(mesh,mesh);
%% 1 e 2.2
for c=1:mesh
    aircraft_1 = change_value('speed', V_cruise(c), aircraft);
    MTOW(c,1) = aircraft_1.vehicle.mass;
    fprintf('Done %d \n',c);
%     for d=1:mesh
%         aircraft_1 = change_value('wing', S_scale(2:3,d), aircraft_1);
%         MTOW(c,d) = aircraft_1.vehicle.mass;
%     end
end
figure();
plot(V_cruise,MTOW(:,1))
% surf(V_cruise,S_scale(1,:),MTOW);
% xlabel('Cruise Velocity [m/s]');
% ylabel('Surface Area [m^2]');
% zlabel('MTOW [kg]');
%% 2.1 e 2.2
for c=1:mesh
    aircraft_1 = change_value('wing', AR_scale(:,c), aircraft_1);
    fprintf('Done %d \n',c);
    for d=1:mesh
        aircraft_1 = change_value('wing', S_scale(2:3,d), aircraft_1);
        MTOW(c,d) = aircraft_1.vehicle.mass;
    end
end
figure();
surf(AR_scale(1,:),S_scale(1,:),MTOW);
xlabel('Aspect Ratio');
ylabel('Surface Area [m^2]');
zlabel('MTOW [kg]');
%% 3 e 1
for c=1:mesh
    aircraft_1 = change_value('radius', Radius(c), aircraft);
    fprintf('Done %d \n',c);
    for d=1:mesh
        aircraft_1 = change_value('speed', V_cruise(d), aircraft_1);
        MTOW(c,d) = aircraft_1.vehicle.mass;
    end
end
figure();
surf(Radius,V_cruise,MTOW);
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
data.vehicle.components{12}.efficieny = 0.7;
%% Mission analysis
data.vehicle = aero_analysis(data.mission, data.vehicle);
[data.mission, data.vehicle] = mass_analysis(data.mission, data.vehicle, data.energy);

aircraft = data;

end
