function data = scramble_aircraft(aircraft)
%% Constants
global constants;
constants.g = 9.81; % m/s^2
REL_ADVANCEMENT = 0.05;
frame = aircraft.vehicle.components;
for i = 1 : length(frame)
    %% Crew
    %
    % No changes
    %
    %% Passengers
    %
    % No changes
    %
    %% Avionics
    %
    % No changes
    %
    %% Payload Bay
    %
    % No changes
    %
    %% Fuselage
    % Data Structure
    % {
    %     "name": "Fuselage",
    %     "type": "fuselage",
    %     "interf_factor": 1.0,
    %     "diameter": 1.75,
    %     "length": 6,
    %     "mass": 800
    % },
    if(is_type(frame{i},'fuselage'))
        % Diameter of the fuselage
        lim = [1.75, 2.5];
        while 1
            a = frame{i}.diameter*surprise((lim(1)-lim(2))/frame{i}.diameter, REL_ADVANCEMENT);
            if is_in_limit(lim(1), a,lim(2))
                frame{i}.diameter = a;
                break;
            end
        end
        % Length of the fuselage
        lim = [9, 12];
        while 1
            a = frame{i}.length*surprise((lim(1)-lim(2))/frame{i}.length, REL_ADVANCEMENT);
            if is_in_limit(lim(1), a,lim(2))
                frame{i}.length = a;
                break;
            end
        end
    %% Main Wing Front
    % Data Structure
    % {
    %     "name": "Main Wing Front",
    %     "type": "wing.main",
    %     "interf_factor": 1.0,
    %     "aspect_ratio": 7.0,
    %     "mean_chord": 3.5,
    %     "oswald_efficiency": 0.85,
    %     "airfoil": {
    %         "type": "naca0012",
    %         "tc_max": 0.15,
    %         "xc_max": 0.3,
    %         "lift_slope_coefficient": 6.2,
    %         "cl_max": 1.6
    %     },
    %     "sweep_le": 10.0,
    %     "sweep_c4": 15.0,
    %     "sweep_tc_max": 20.0,
    %     "mass": 200
    % },
    elseif(is_type(frame{i},'wing.main'))
        % Aspect ratio & chord
        lim_1 = [5  , 8 ];
        lim_2 = [2  , 3 ];
        lim_3 = [10 , 16];
        while 1
            % Aspect ratio
            while 1
                a = frame{i}.aspect_ratio*surprise((lim_1(1)-lim_1(2))/frame{i}.aspect_ratio, REL_ADVANCEMENT);
                if is_in_limit(lim_1(1), a, lim_1(2))
                    frame{i}.aspect_ratio = a;
                    break;
                end
            end
            % mean chord
            while 1
                a = frame{i}.mean_chord*surprise((lim_2(1)-lim_2(2))/frame{i}.mean_chord, REL_ADVANCEMENT);
                if is_in_limit(lim_2(1), a, lim_2(2))
                    frame{i}.mean_chord = a;
                    break;
                end
            end
            % span (inferred)
            if is_in_limit(lim_3(1), frame{i}.aspect_ratio*frame{i}.mean_chord, lim_3(2))
                break;
            end
        end
    %% Main Wing Back
    % Data Structure
    % {
    %     "name": "Main Wing Front",
    %     "type": "wing.htail",
    %     "interf_factor": 1.0,
    %     "aspect_ratio": 7.0,
    %     "mean_chord": 3.5,
    %     "oswald_efficiency": 0.85,
    %     "airfoil": {
    %         "type": "naca0012",
    %         "tc_max": 0.15,
    %         "xc_max": 0.3,
    %         "lift_slope_coefficient": 6.2,
    %         "cl_max": 1.6
    %     },
    %     "sweep_le": 10.0,
    %     "sweep_c4": 15.0,
    %     "sweep_tc_max": 20.0,
    %     "mass": 200
    % },
    elseif(is_type(frame{i},'wing.htail'))
        % Aspect ratio & chord
        lim_1 = [5  , 8 ];
        lim_2 = [2  , 3 ];
        lim_3 = [10 , 16];
        while 1
            % Aspect ratio
            while 1
                a = frame{i}.aspect_ratio*surprise((lim_1(1)-lim_1(2))/frame{i}.aspect_ratio, REL_ADVANCEMENT);
                if is_in_limit(lim_1(1), a, lim_1(2))
                    frame{i}.aspect_ratio = a;
                    break;
                end
            end
            % mean chord
            while 1
                a = frame{i}.mean_chord*surprise(lim_2(1)-lim_2(2)/frame{i}.mean_chord, REL_ADVANCEMENT);
                if is_in_limit(lim_2(1), a, lim_2(2))
                    frame{i}.mean_chord = a;
                    break;
                end
            end
            % span (inferred)
            if is_in_limit(lim_3(1), frame{i}.aspect_ratio*frame{i}.mean_chord, lim_3(2))
                break;
            end
        end
    %% Vertical Tail
    %
    % No changes
    %
    %% Turboshaft
    %
    % No changes
    %
    %% Battery
    %
    % No changes
    %
    %% Fuel Tank
    %
    % No changes
    %
    %% Rotor
    % {
    %     "name": "Rotor",
    %     "type": "driver.rotor.main",
    %     "number": 4,
    %     "number_blades": 4,
    %     "radius": 3,
    %     "rotor_solidity": 0.08,
    %     "induced_power_factor": 1.15,
    %     "base_drag_coefficient": 0.02,
    %     "tip_velocity": 240.1,
    %     "efficiency": 0.6,
    %     "mass": 20
    % },
    elseif(is_type(frame{i},'driver.rotor.main'))
        % Radius of the rotor
        lim_1 = [2, 4];
        while 1
            a = frame{i}.radius*surprise((lim_1(1)-lim_1(2))/frame{i}.radius, REL_ADVANCEMENT);
            if is_in_limit(lim_1(1), a,lim_1(2))
                frame{i}.radius = a;
                break;
            end
        end
    %% Gearbox
    %
    % No changes
    %
    %% Generator
    %
    % No changes
    %
    %% Eletric Motor
    % {
    %     "name": "Electric Motor",
    %     "type": "engine.prop.eletric",
    %     "number": 4,
    %     "efficiency": 0.97,
    %     "mass": 50,
    %     "brake_specific_fuel_consumption": 4.25e-5, 
    %     "max_power": 550000
    % 
    % }
    elseif(is_type(frame{i},'engine.prop.eletric'))        
            % Maximum Power
            lim = [400000, 550000];
            b1  = 2261;
            b0  = 179666;
            while 1
                a = frame{i}.max_power*surprise((lim(1)-lim(2))/frame{i}.max_power, REL_ADVANCEMENT*2);
                if is_in_limit(lim(1), a,lim(2))
                    frame{i}.max_power  = a;
                    % Mass calculated based on power density analysis
                    frame{i}.mass       = (a - b0)/b1;
                    break;
                end
            end
    %% Turboshaft
    % {
    %     "name":"Turboshaft", 
    %     "type":"engine.prop.turboshaft", 
    %     "efficiency":0.8, 
    %     "mass":100,
    %     "brake_specific_fuel_consumption":4.25E-5, 
    %     "max_power":534063.28675790748
    % }, 
    %
    elseif(is_type(frame{i},'engine.prop.turboshaft'))        
            % Maximum Power
            lim = [1.6*10^(6), 3*10^(6)];
            b1  = 8279;
            b0  = -214882;
            while 1
                a = frame{i}.max_power*surprise((lim(1)-lim(2))/frame{i}.max_power, REL_ADVANCEMENT*2);
                if is_in_limit(lim(1), a,lim(2))
                    frame{i}.max_power  = a;
                    % Mass calculated based on power density analysis
                    frame{i}.mass       = (a - b0)/b1;
                    break;
                end
            end
    end
end
aircraft.vehicle.components = frame;

data = aircraft;


function c = is_in_limit(x, y, z)

if(x < y && y < z)
    c = 1;
else
    c = 0;
end

function c = surprise(delta, range)

c = 1 + delta*2*range*(rand - 0.5);

