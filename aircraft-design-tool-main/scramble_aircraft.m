function data = scramble_aircraft(aircraft)
%% Constants
global constants;
constants.g = 9.81; % m/s^2

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
            {
                "name": "Fuselage",
                "type": "fuselage",
                "interf_factor": 1.0,
                "diameter": 1.75,
                "length": 6,
                "mass": 800
            },
%% Main Wing Front
            {
                "name": "Main Wing Front",
                "type": "wing.main",
                "interf_factor": 1.0,
                "aspect_ratio": 7.0,
                "mean_chord": 3.5,
                "oswald_efficiency": 0.85,
                "airfoil": {
                    "type": "naca0012",
                    "tc_max": 0.15,
                    "xc_max": 0.3,
                    "lift_slope_coefficient": 6.2,
                    "cl_max": 1.6
                },
                "sweep_le": 10.0,
                "sweep_c4": 15.0,
                "sweep_tc_max": 20.0,
                "mass": 200
            },
%% Main Wing Back
            {
                "name": "Horizontal Tail",
                "type": "wing.htail",
                "interf_factor": 1.0,
                "aspect_ratio": 7.0,
                "mean_chord": 3.5,
                "oswald_efficiency": 0.85,
                "airfoil": {
                    "type": "naca0012",
                    "tc_max": 0.15,
                    "xc_max": 0.3,
                    "lift_slope_coefficient": 6.2,
                    "cl_max": 1.6
                },
                "sweep_le": 10.0,
                "sweep_c4": 15.0,
                "sweep_tc_max": 20.0,
                "mass": 200
            },
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
            {
                "name": "Rotor",
                "type": "driver.rotor.main",
                "number": 4,
                "number_blades": 4,
                "radius": 3,
                "rotor_solidity": 0.08,
                "induced_power_factor": 1.15,
                "base_drag_coefficient": 0.02,
                "tip_velocity": 240.1,
                "efficiency": 0.6,
                "mass": 20
            },
%% Gearbox
%
% No changes
%
%% Generator
%
% No changes
%
%% Motor
            {
                "name": "Electric Motor",
                "type": "engine.prop",
                "number": 4,
                "efficiency": 0.97,
                "mass": 50,
                "brake_specific_fuel_consumption": 4.25e-5, 
                "max_power": 550000

            }

data = aircraft;
