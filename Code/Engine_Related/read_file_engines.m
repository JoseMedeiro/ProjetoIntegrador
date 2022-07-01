%% Aircraft build tool - Engine Expansion Pack
% 
% José Medeiro (josemedeiro@tecnico.ulisboa.pt)
%
% This file is subject to the license terms in the LICENSE file included in
% this distribution (I guess)
%
%% Briefing
%
% Reads the .JSON file that holds the engines to be analysed and
% re-transforms some of the fields to cell array (because it is better that 
% way, given that in the array format it is possible to automatically run 
% all elements).
%
% The input is the name of the file.
%
% The output is a structure with a array of cells that contain all types of
% engines enlisted in the input file.
%
%% Function
function data = read_file_engines(input_file)

data = jsondecode(fileread(input_file));

if isfield(data, 'engine_set')
    % re-transforms data.engine_set in a cell array
    if ~iscell(data.engine_set)
        data.engine_set = num2cell(data.engine_set);
    end
    % re-transforms all data.engine_set.engines in cell arrays
    for c = 1:size(data.engine_set,1)
        if isfield(data.engine_set{c}, 'engines')
            if ~iscell(data.engine_set{c}.engines)
                data.engine_set{c}.engines = num2cell(data.engine_set{c}.engines);
            end
        end
    end
end


end