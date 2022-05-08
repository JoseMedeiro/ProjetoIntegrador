%% Aircraft design tool
%
% Mario Bras (mbras@uvic.ca) and Ricardo Marques (ricardoemarques@uvic.ca) 2019
%
% This file is subject to the license terms in the LICENSE file included in this distribution
%% Notes:
% Heavily edited, intended for natural selection process!
% Edited by José Medeiro during May 2022:
% * Patch 1.1 (05/05/2022):
% - Comments & Constraints update
%
%% Main function
function results = design_space_analysis_recursive(mission, vehicle, energy)
global constants;

%% Checkers
inside_constrains   = [1    , 1     ];
maximum_values      = [0.5  , 0.5   ];
%% Starting space
wl = 0:5:2000;
dl = 0:5:10000;
pl = 0:0.0005:0.5;
[plf_grid, wl_grid] = meshgrid(pl, wl);
[plv_grid, dl_grid] = meshgrid(pl, dl);
cf = ones(length(wl), length(pl));
cv = ones(length(dl), length(pl));

%% Configure plot
%colors = {'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30','#4DBEEE','#A2142F'};
co =    [0      0.4470 0.7410;
         0.85   0.3250 0.098;
         0.9290 0.6940 0.1250;
         0.4940 0.1840 0.5560;
         0.4660 0.6740 0.1880;
         0.6350 0.0780 0.1840;
         0.3010 0.7450 0.9330];
figure();
yyaxis right;
legend;
hold on;
a = gca;
a.Title.String = 'Design Point';
a.XLim = [0 pl(end)];
a.XLabel.String = 'W/P';
a.YLim = [0 dl(end)];
a.YLabel.String = 'W/A';
a.LineStyleOrder = '-';
%function 'colororder' só para matlab 2019b para cima
%colororder(colors)
set(a, 'ColorOrder',co)
yyaxis left;
a.YLim = [0 wl(end)];
a.YLabel.String = 'W/S';
a.LineStyleOrder = '-';
%colororder(colors)
set(a, 'ColorOrder',co)

k = k_parameter(vehicle);

%% Get design wing loading, disk loading and power loading   <- DESIGN POINT
c = find_by_type(vehicle.components, 'wing.main');
wl_design   = vehicle.mass * constants.g / c.area_ref;
wl_position = find(abs(wl - wl_design) < 2.5);

c = find_by_type(vehicle.components, 'driver.rotor.main');
dl_design = vehicle.mass * constants.g / rotor_area(c);
dl_position = find(abs(dl - dl_design) < 2.5);

fpl_design = 0;
vpl_design = 0;

%% Iterate over horizontal flight mission segments           <- CONSTRAINS
yyaxis left;
forward_region = cf;
vertical_region = cv;
for i = 1 : length(mission.segments)
    % Climb segment
    if strcmp(mission.segments{i}.type, 'climb')
        [constraint, forward_region, power] = climb(plf_grid, wl_grid, wl, k, mission.segments{i}, vehicle, energy);

        % Updates FW/P
        fpl = vehicle.mass * constants.g / power;
        if fpl > fpl_design
            fpl_design = fpl;
        end
        % Updates maximum W/P
        max_wp  = constraint(wl_position);
        if maximum_values(1) > max_wp
            maximum_values(1) = max_wp;
        end
    % Cruise segment
    elseif strcmp(mission.segments{i}.type, 'cruise')
        [range_constraint, cruise_speed_constraint, forward_region, power] = cruise(plf_grid, wl_grid, wl, k, mission.segments{i}, vehicle, energy);
        
        % Updates FW/P
        fpl = vehicle.mass * constants.g / power;
        if fpl > fpl_design
            fpl_design = fpl;
        end
        % Updates maximum W/P
        max_wp  = constraint(wl_position);
        if maximum_values(1) > max_wp
            maximum_values(1) = max_wp;
        end
    % Hold segment
    elseif strcmp(mission.segments{i}.type, 'hold')
        [constraint, forward_region, power] = loiter(wl_grid, k, mission.segments{i}, vehicle, energy);

        % Updates FW/P
        fpl = vehicle.mass * constants.g / power;
        if fpl > fpl_design
            fpl_design = fpl;
        end

    elseif strcmp(mission.segments{i}.type, 'descent') % Descent segment
        network = find_network_components(vehicle, find_by_name(energy.networks, mission.segments{i}.energy_network));

        % TODO
        
        fpl = vehicle.mass * constants.g / network_max_power(network);
        if fpl > fpl_design
            fpl_design = fpl;
        end
    elseif strcmp(mission.segments{i}.type, 'hover') % Hover segment
        [constraint, vertical_region, power] = hover(plv_grid, dl_grid, dl, mission.segments{i}, vehicle, energy);
        
        % Updates VW/P
        vpl = vehicle.mass * constants.g / power;
        if vpl > vpl_design
            vpl_design = vpl;
        end
        % Updates maximum D/P
        max_dp  = constraint(dl_position);
        if maximum_values(2) > max_dp
            maximum_values(2) = max_dp;
        end
    elseif strcmp(mission.segments{i}.type, 'transition') % Transition segment
        [constraint, vertical_region, power] = transition(plv_grid, dl_grid, wl_design, dl, k, mission.segments{i}, mission.segments{i+1}, vehicle, energy);

        % Updates VW/P
        vpl = vehicle.mass * constants.g / power;
        if vpl > vpl_design
            vpl_design = vpl;
        end
        % Updates maximum D/P
        max_dp  = constraint(dl_position);
        if maximum_values(2) > max_dp
            maximum_values(2) = max_dp;
        end
    elseif strcmp(mission.segments{i}.type, 'vertical_climb') % Vertical climb segment
        [constraint, vertical_region, power] = vertical_climb(plv_grid, dl_grid, dl, mission.segments{i}, vehicle, energy);

        % Updates VW/P
        vpl = vehicle.mass * constants.g / power;
        if vpl > vpl_design
            vpl_design = vpl;
        end
        % Updates maximum D/P
        max_dp  = constraint(dl_position);
        if maximum_values(2) > max_dp
            maximum_values(2) = max_dp;
        end
    elseif strcmp(mission.segments{i}.type, 'vertical_descent') % Vertical descent segment
        network = find_network_components(vehicle, find_by_name(energy.networks, mission.segments{i}.energy_network));

        % TODO
        % Updates VW/P
        vpl = vehicle.mass * constants.g / network_max_power(network);
        if vpl > vpl_design
            vpl_design = vpl;
        end
    end

    cf = cf .* forward_region;
    cv = cv .* vertical_region;
    
    if(maximum_values(1) < fpl_design)
        inside_constraints(1) = 0;
    end
    if(maximum_values(2) < fpl_design)
        inside_constraints(2) = 0;
    end
end

%% Results
if (inside_constraints(1)*inside_constraints(2) == 0)
    results = [-1, -1];
else
    results = fpl_design + [wl_design, dl_design];
end
%% Helper functions
function [constraint, region, power] = hover(plv_grid, dl_grid, dl, segment, vehicle, energy)
network = find_network_components(vehicle, find_by_name(energy.networks, segment.energy_network));
engine = find_by_type(network, 'engine');

constraint = hover_constraint(dl, segment.density, engine.efficiency);
region = hover_region(plv_grid, dl_grid, segment.density, engine.efficiency);

power = network_max_power(network);

function [constraint, region, power] = transition(plv_grid, dl_grid, wl, dl, k, segment, next_segment, vehicle, energy)
network = find_network_components(vehicle, find_by_name(energy.networks, segment.energy_network));
[segment_props, ~] = find_by_name(vehicle.segments, segment.name);
rotor = find_by_type(network, 'driver.rotor');

constraint = transition_constraint(wl, dl, segment.density, k, segment_props.base_drag_coefficient, rotor.tip_velocity, rotor.rotor_solidity, rotor.base_drag_coefficient, rotor.induced_power_factor, next_segment.velocity, segment.transition_angle);
region = transition_region(plv_grid, wl, dl_grid, segment.density, k, segment_props.base_drag_coefficient, rotor.tip_velocity, rotor.rotor_solidity, rotor.base_drag_coefficient, rotor.induced_power_factor, next_segment.velocity, segment.transition_angle);

power = network_max_power(network);

function [constraint, region, power] = vertical_climb(plv_grid, dl_grid, dl, segment, vehicle, energy)
network = find_network_components(vehicle, find_by_name(energy.networks, segment.energy_network));
rotor = find_by_type(network, 'driver.rotor');

constraint = vertical_climb_constraint(dl, segment.density(1), rotor.tip_velocity, rotor.rotor_solidity, rotor.base_drag_coefficient, rotor.induced_power_factor, segment.velocity);
region = vertical_climb_region(plv_grid, dl_grid, segment.density(1), rotor.tip_velocity, rotor.rotor_solidity, rotor.base_drag_coefficient, rotor.induced_power_factor, segment.velocity);

power = network_max_power(network);

function [constraint, region, power] = climb(plf_grid, wl_grid, wl, k, segment, vehicle, energy)
network = find_network_components(vehicle, find_by_name(energy.networks, segment.energy_network));
engine = find_by_type(network, 'engine');
[segment_props, ~] = find_by_name(vehicle.segments, segment.name);

if is_type(engine, 'engine.jet')
    constraint = climb_constraint_jet(wl, segment.density(1), segment.velocity, segment_props.base_drag_coefficient, k, segment.angle);
    region = climb_region_jet(plf_grid, wl_grid, segment.density(1), segment.velocity, segment_props.base_drag_coefficient, k, segment.angle);
elseif is_type(engine, 'engine.prop')
    prop = find_by_type(network, 'driver.rotor');
    constraint = climb_constraint_prop(wl, segment.density(1), segment.velocity, segment_props.base_drag_coefficient, k, segment.angle, prop.efficiency);
    region = climb_region_prop(plf_grid, wl_grid, segment.density(1), segment.velocity, segment_props.base_drag_coefficient, k, segment.angle, prop.efficiency);
end

power = network_max_power(network);

function [range_constraint, cruise_speed_constraint, region, power] = cruise(plf_grid, wl_grid, wl, k, segment, vehicle, energy)
network = find_network_components(vehicle, find_by_name(energy.networks, segment.energy_network));
engine = find_by_type(network, 'engine');
[segment_props, ~] = find_by_name(vehicle.segments, segment.name);

if is_type(engine, 'engine.jet')
    range_constraint = range_constraint_jet(segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
    range_region = range_region_jet(wl_grid, segment.density, segment.velocity, segment_props.base_drag_coefficient, k);

    cruise_speed_constraint = cruise_speed_constraint_jet(wl, segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
    cruise_speed_region = cruise_speed_region_jet(plf_grid, wl_grid, segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
elseif is_type(engine, 'engine.prop')
    range_constraint = range_constraint_prop(segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
    range_region = range_region_prop(wl_grid, segment.density, segment.velocity, segment_props.base_drag_coefficient, k);

    prop = find_by_type(network, 'driver.rotor');
    cruise_speed_constraint = cruise_speed_constraint_prop(wl, segment.density, segment.velocity, segment_props.base_drag_coefficient, k, prop.efficiency);
    cruise_speed_region = cruise_speed_region_prop(plf_grid, wl_grid, segment.density, segment.velocity, segment_props.base_drag_coefficient, k, prop.efficiency);
end

region = range_region .* cruise_speed_region;

power = network_max_power(network);

function [constraint, region, power] = loiter(wl_grid, k, segment, vehicle, energy)
network = find_network_components(vehicle, find_by_name(energy.networks, segment.energy_network));
engine = find_by_type(network, 'engine');
[segment_props, ~] = find_by_name(vehicle.segments, segment.name);

if is_type(engine, 'engine.jet')
    constraint = endurance_constraint_jet(segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
    region = endurance_region_jet(wl_grid, segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
elseif is_type(engine, 'engine.prop')
    constraint = endurance_constraint_prop(segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
    region = endurance_region_prop(wl_grid, segment.density, segment.velocity, segment_props.base_drag_coefficient, k);
end

power = network_max_power(network);

function k = k_parameter(vehicle)
c = find_by_type(vehicle.components, 'wing.main');
k = 1 / pi / c.aspect_ratio / c.oswald_efficiency;

%% Performance functions
function v = v_min_thrust(wl, rho, k, cd_0)
v = sqrt(2 * wl / rho * sqrt(k / cd_0));

function v = v_min_power(wl, rho, k, cd_0)
v = sqrt(2 * wl / rho * sqrt(k / 3 / cd_0));

function v = v_best_climb_rate_jet(tl, wl, rho, k, cd_0)
v = sqrt(wl / 3 / rho / cd_0 * (1 / tl + sqrt(1 / tl^2 + 12 * cd_0 * k)));

function v = v_best_climb_rate_prop(wl, rho, k, cd_0)
v = v_min_power(wl, rho, k, cd_0);

function v = v_best_climb_angle_jet(wl, rho, k, cd_0)
v = v_min_thrust(wl, rho, k, cd_0);

function v = v_best_climb_angle_prop(wl, rho, k, cd_0)
v = 0.875 * v_best_climb_rate_prop(wl, rho, k, cd_0); % Raymer pp. 466

function c_l = cl_min_thrust(k, cd_0)
c_l = sqrt(cd_0 / k);

function c_l = cl_min_power(k, cd_0)
c_l = sqrt(3 * cd_0 / k);

function cd = cd_min_thrust(cd_0)
cd = 2 * cd_0;

function cd = cd_min_power(cd_0)
cd = 4 * cd_0;

%% Vertical flight constraint functions
function pl = hover_constraint(dl, rho, fm)
pl = fm .* sqrt(2 .* rho ./ dl);

function pl = vertical_climb_constraint(dl, rho, v_tip, ss, cd, k_i, v_y)
pl = 1 ./ (v_y - k_i .* v_y ./ 2 + k_i .* sqrt(v_y.^2 + 2 .* dl ./ rho) ./ 2 + rho .* v_tip.^3 .* ss .* cd ./ dl ./ 8);

function pl = vertical_descent_constraint(dl, rho, v_tip, ss, cd, k_i, v_y, v_i)
if v_y / v_i <= -2 % If this condition is met, the vertical climb equation is used for descent, else, an empirical equation is employed
    pl = 1 ./ (v_y - k_i ./ 2 * (v_y + sqrt(v_y.^2 - 2 .* dl ./ rho)) + rho .* v_tip.^3 .* ss .* cd ./ dl ./ 8);
else
    v_d = v_i * (k_i - 1.125 * v_y / v_i - 1.372 * (v_y / v_i)^2 - 1.718 * (v_y / v_i)^3 - 0.655 * (v_y / v_i)^4); % Induced velocity in descent according to an empirical relation (see lecture slides)
    pl = 1 ./ (v_y + k_i .* v_d + rho .* v_tip.^3 ./ dl .* ss .* cd ./ 8);
end

function pl = transition_constraint(wl, dl, rho, k, cd_0, v_tip, ss, cd, k_i, v, tt_tilt)
aa = 0; % Assuming zero angle of attack of the blades
mm = v * cosd(aa) / v_tip;
pl = 1 ./ (k_i ./ sind(tt_tilt) .* sqrt(-v.^2 ./ 2 + sqrt((v.^2 ./ 2).^2 + (dl ./ 2 ./ rho ./ sind(tt_tilt)).^2)) + rho .* v_tip.^3 ./ dl .* (ss .* cd ./ 8 .* (1 + 4.6 .* mm.^2)) + 0.5 .* rho .* v^3 .* cd_0 ./ wl + 2 .* wl .* k ./ rho ./ v);

%% Vertical flight constraint regions
function c = hover_region(pl, dl, rho, ee)
c = pl < ee .* sqrt(2 .* rho ./ dl);

function c = vertical_climb_region(pl, dl, rho, v_tip, ss, cd, k_i, v_y)
c = pl < 1 ./ (v_y - k_i .* v_y ./ 2 + k_i .* sqrt(v_y.^2 + 2 .* dl ./ rho) ./ 2 + rho .* v_tip.^3 .* ss .* cd ./ dl ./ 8);

function c = vertical_descent_region(pl, dl, rho, v_tip, ss, cd, k_i, v_y, v_i)
if v_y / v_i <= -2 % If this condition is met, the vertical climb equation is used for descent, else, an empirical equation is employed
    c = pl < 1 ./ (v_y - k_i ./ 2 * (v_y + sqrt(v_y.^2 - 2 .* dl ./ rho)) + rho .* v_tip.^3 .* ss .* cd ./ dl ./ 8);
else
    v_d = v_i * (k_i - 1.125 * v_y / v_i - 1.372 * (v_y / v_i)^2 - 1.718 * (v_y / v_i)^3 - 0.655 * (v_y / v_i)^4); % Induced velocity in descent according to an empirical relation (see lecture slides)
    c = pl < 1 ./ (v_y + k_i .* v_d + rho .* v_tip.^3 ./ dl .* ss .* cd ./ 8);
end

function c = transition_region(pl, wl, dl, rho, k, cd_0, v_tip, ss, cd, k_i, v, tt_tilt)
aa = 0; % Assuming zero angle of attack of the blades
mm = v * cosd(aa) / v_tip;
c = pl < 1 ./ (k_i ./ sind(tt_tilt) .* sqrt(-v.^2 ./ 2 + sqrt((v.^2 ./ 2).^2 + (dl ./ 2 ./ rho ./ sind(tt_tilt)).^2)) + rho .* v_tip.^3 ./ dl .* (ss .* cd ./ 8 .* (1 + 4.6 .* mm.^2)) + 0.5 .* rho .* v^3 .* cd_0 ./ wl + 2 .* wl .* k ./ rho ./ v);

% Forward flight constraint functions
function wl = range_constraint_jet(rho, v, cd_0, k)
wl = 0.5 * rho * v^2 * sqrt(cd_0 / 3 / k);

function wl = range_constraint_prop(rho, v, cd_0, k)
wl = 0.5 * rho * v^2 * sqrt(cd_0 / k);

function wl = endurance_constraint_jet(rho, v, cd_0, k)
wl = 0.5 * rho * v^2 * sqrt(cd_0 / k);

function wl = endurance_constraint_prop(rho, v, cd_0, k)
wl = 0.5 * rho * v^2 * sqrt(3 * cd_0 / k);

function wl = stall_speed_constraint(rho, v_s, c_lmax)
wl = 0.5 * rho * v_s^2 * c_lmax;

function ptl = cruise_speed_constraint_jet(wl, rho, v, cd_0, k)
ptl = 1 ./ (rho .* v.^2 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v.^2);

function ptl = cruise_speed_constraint_prop(wl, rho, v, cd_0, k, ee)
ptl = ee ./ (rho .* v.^3 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v);

function pl = climb_constraint_jet(wl, rho, v, cd_0, k, gg)
pl = 1 ./ (sind(gg) + rho .* v.^2 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v.^2);

function pl = climb_constraint_prop(wl, rho, v, cd_0, k, gg, ee)
pl = ee ./ (v .* sind(gg) + rho .* v.^3 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v);

function pl = climb_angle_constraint_jet(wl, rho, cd_0, k, gg)
pl = climb_constraint_jet(wl, rho, v_best_climb_angle_jet(wl, rho, k, cd_0), cd_0, k, gg); % TODO: Replace with segment speed

function pl = climb_angle_constraint_prop(wl, rho, cd_0, k, gg, ee)
pl = climb_constraint_prop(wl, rho, v_best_climb_angle_prop(wl, rho, k, cd_0), cd_0, k, gg, ee); % TODO: Replace with segment speed

% function pl = climb_rate(wl, rho, cd_0, k, gg, propulsion)
% if is_jet(propulsion)
%     % pl = fsolve(@(x)climb_rate_jet_error(x, wl, rho, cd_0, k, gg, propulsion), 0.01, optimoptions('fsolve', 'Display','iter'));
% elseif is_prop(propulsion)
%     pl = climb(wl, rho, v_best_climb_rate_prop(wl, rho, k, cd_0), cd_0, k, gg, propulsion);
% end

% function err = climb_rate_jet_error(tl, wl, rho, cd_0, k, gg, propulsion)
% err = climb(wl, rho, v_best_climb_rate_jet(tl, wl, rho, k, cd_0), cd_0, k, gg, propulsion) - tl;

% Forward flight constraint regions
function c = range_region_jet(wl, rho, v, cd_0, k)
c = wl < 0.5 * rho * v^2 * sqrt(cd_0 / 3 / k);

function c = range_region_prop(wl, rho, v, cd_0, k)
c = wl < 0.5 * rho * v^2 * sqrt(cd_0 / k);

function c = endurance_region_jet(wl, rho, v, cd_0, k)
c = wl < 0.5 * rho * v^2 * sqrt(cd_0 / k);

function c = endurance_region_prop(wl, rho, v, cd_0, k)
c = wl < 0.5 * rho * v^2 * sqrt(3 * cd_0 / k);

function c = stall_speed_region(rho, v_s, c_lmax)
c = wl < 0.5 * rho * v_s^2 * c_lmax;

function c = cruise_speed_region_jet(pl, wl, rho, v, cd_0, k)
c = pl < 1 ./ (rho .* v.^2 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v.^2);

function c = cruise_speed_region_prop(pl, wl, rho, v, cd_0, k, ee)
c = pl < ee ./ (rho .* v.^3 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v);

function c = climb_region_jet(pl, wl, rho, v, cd_0, k, gg)
c = pl < 1 ./ (sind(gg) + rho .* v.^2 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v.^2);

function c = climb_region_prop(pl, wl, rho, v, cd_0, k, gg, ee)
c = pl < ee ./ (v .* sind(gg) + rho .* v.^3 .* cd_0 ./ 2 ./ wl + 2 .* k .* wl ./ rho ./ v);

function c = climb_angle_region_jet(pl, wl, rho, cd_0, k, gg)
c = climb_region_jet(pl, wl, rho, v_best_climb_angle_jet(wl, rho, k, cd_0), cd_0, k, gg);

function c = climb_angle_region_prop(pl, wl, rho, cd_0, k, gg, ee)
c = climb_region_prop(pl, wl, rho, v_best_climb_angle_prop(wl, rho, k, cd_0), cd_0, k, gg, ee);
