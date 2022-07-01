function data = gets_rating_design(aircraft)
%% Constants
global constants;
constants.g = 9.81; % m/s^2

%% Add missing vehicle component parameters
aircraft.mission = build_mission(aircraft.mission);
aircraft.vehicle = build_vehicle(aircraft.mission, aircraft.vehicle);

%% Mission analyses
aircraft.vehicle = aero_analysis(aircraft.mission, aircraft.vehicle);
[aircraft.mission, aircraft.vehicle] = mass_analysis(aircraft.mission, aircraft.vehicle, aircraft.energy);
%% Evaluates the design point
data = design_space_analysis_recursive(aircraft.mission, aircraft.vehicle, aircraft.energy);
