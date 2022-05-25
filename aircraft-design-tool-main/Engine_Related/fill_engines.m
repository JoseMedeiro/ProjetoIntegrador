%% Aircraft build tool - Engine Expansion Pack
% 
% José Medeiro (josemedeiro@tecnico.ulisboa.pt)
%
% This file is subject to the license terms in the LICENSE file included in
% this distribution (I guess)
%
%% Briefing
%
% Collects all points in the engine collection, according to types, in 
% order to perform a linear regression so that the data set can be
% interpolated (or extrapolated if we want to be edgy).
%
% The input is the structure that contains all data sets to analyse.
%
% The output is a structure with a array of cells that contain the analysis
% of all types (data sets) of engines enlisted in the input structure.
%
%% Function
function data = fill_engines(input_engines)
    
for c=1:size(input_engines.engine_set,1)
    
    n = size(input_engines.engine_set{c}.engines,1);
    for d=1:n
        x(d) = input_engines.engine_set{c}.engines{d}.mass;
        y(d) = input_engines.engine_set{c}.engines{d}.max_power;
 
    end
    
    X = [ones(n,1),x(1:n).'];
    Y = y(1:n).';
    C = X\Y;
    
    %% Data filling
    data.engine_set{c}.type = input_engines.engine_set{c}.type;
    data.engine_set{c}.b1   = C(2);
    data.engine_set{c}.b0   = C(1);
    data.engine_set{c}.min_weight  = min(x(1:n));
    data.engine_set{c}.max_weight  = max(x(1:n));
    data.engine_set{c}.min_power   = min(y(1:n));
    data.engine_set{c}.max_power   = max(y(1:n));
    
end

end