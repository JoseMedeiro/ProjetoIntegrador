% Aircraft design tool
%
% Mario Bras (mbras@uvic.ca) and Ricardo Marques (ricardoemarques@uvic.ca) 2019
%
% This file is subject to the license terms in the LICENSE file included in this distribution

function test = is_type(data, type)

test = true;
type_tags = split(type, '.');
elem_tags = split(data.type, '.');

if length(type_tags)>length(elem_tags)
   test = false; 
else
for i = 1 : length(type_tags)
    if ~strcmp(elem_tags{i}, type_tags{i})
        test = false;
        return;
    end
end

end
