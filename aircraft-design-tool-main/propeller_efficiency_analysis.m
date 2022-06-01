%
%
%
%
% Will change MTOW and Prop efficiency
%
%
function result = propeller_efficiency_analysis(aircraft)

global constants;

eff = [0 0];

% Gets J

for abs(eff(1) - eff(2)) > 0.01
    % Gets MTOW
    aircraft = mass_analysis(aircraft.mission, aircraft.vehicle, aircraft.energy);
    % Gets data
    wl = vehicle.mass * constants.g / (c_1.area_ref + c_2.area_ref);
    % Gets P
    P = cruise_speed_constraint_prop(wl, rho, v, cd_0, k, ee)
    % Gets efficiency
    eff(2) = eff(1);
    eff(1) = gets_efficiency(J, P);
end

result = aircraft
