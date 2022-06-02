%
%
% Needs aero_analysis first
%
% Will change MTOW and Prop efficiency
%
%
function result = propeller_efficiency_analysis(aircraft)

global constants;

eff = [0 0];

%% Important data from aircraft 
rotor           = find_by_type(aircraft.vehicles.components,'driver.rotor.main');
cruise_mission  = find_by_type(aircraft.mission.segments,'cruise');
vehicle_mission = find_by_name(aircraft.vehicles.segments,cruise_mission.name);
rho             = cruise_mission.density;
d               = rotor.radius*2;
v               = cruise_mission.velocity;
k               = k_parameter(aircraft.vehicle);
cd_0            = vehicle_mission.base_drag_coefficient;
c_1             = find_by_type(aircraft.vehicles.components,'wing.main');
c_2             = find_by_type(aircraft.vehicles.components,'wing.htail');

eff(1)          = rotor.efficiency;
% Gets J
J = v/sqrt(rotor.tip_velocity^2 - v^2);

while abs(eff(1) - eff(2)) > 0.01
    % Gets MTOW
    aircraft = mass_analysis(aircraft.mission, aircraft.vehicle, aircraft.energy);
    % Gets data
    wl = aircraft.vehicle.mass * constants.g / (c_1.area_ref + c_2.area_ref);
    % Gets P
    P = cruise_speed_constraint_prop(wl, rho, v, cd_0, k, eff(1));
    Cp = P/(rho*(rotor.tip_velocity^2 - v^2)^(3/2))*pi^3/d^2;
    % Gets efficiency
    eff(2) = eff(1);
    eff(1) = gets_efficiency(J, Cp);
end

rotor.efficiency    = eff(1);

result = aircraft;

end

function n = gets_efficiency(J, P)

n = 