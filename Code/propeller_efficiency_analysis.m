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

eff_function = load_eff_funciton('eff_lines.txt');

%% Important data from aircraft 
[rotor rotor_id]= find_by_type(aircraft.vehicle.components,'driver.rotor.main');
cruise_mission  = find_by_type(aircraft.mission.segments,'cruise');
vehicle_mission = find_by_name(aircraft.vehicle.segments,cruise_mission.name);
rho             = cruise_mission.density;
d               = rotor.radius*2;
v               = cruise_mission.velocity;
k               = k_parameter(aircraft.vehicle);
cd_0            = vehicle_mission.base_drag_coefficient;
c_1             = find_by_type(aircraft.vehicle.components,'wing.main');
c_2             = find_by_type(aircraft.vehicle.components,'wing.htail');

eff(1)          = rotor.efficiency;
% Gets J
J = v/sqrt((rotor.tip_velocity)^2 - v^2)*pi;

while abs(eff(1) - eff(2)) > 0.01
    % Gets MTOW
    [aircraft.mission, aircraft.vehicle] = mass_analysis(aircraft.mission, aircraft.vehicle, aircraft.energy);
    % Gets data
    wl = aircraft.vehicle.mass * constants.g / (c_1.area_ref + c_2.area_ref);
    % Gets P
    P = aircraft.vehicle.mass * constants.g /cruise_speed_constraint_prop(wl, rho, v, cd_0, k, eff(1));
    Cp = P/4/(rho*(rotor.tip_velocity^2 - v^2)^(3/2))*pi^3/d^2;
    % Gets efficiency
    eff(2) = eff(1);
    eff(1) = interp2(eff_function.X, eff_function.Y, eff_function.Z, J, Cp);
    aircraft.vehicle.components{rotor_id}.efficiency = eff(1);
end

fprintf('J = %f \nCp = %f\nP = %f\n',J,Cp,P/4);


result = aircraft;

end

function k = k_parameter(vehicle)
c = find_by_type(vehicle.components, 'wing.main');
k = 1 / pi / c.aspect_ratio / c.oswald_efficiency;
end

function ptl = cruise_speed_constraint_prop(wl, rho, v, cd_0, k, ee)
ptl = ee ./ (rho .* v.^3 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v);
end