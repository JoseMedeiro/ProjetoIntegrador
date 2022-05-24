%
%
%
%
function data = fill_engines(input_engines)

for c=1:size(input_engines)
    
    for d=1:size(input_engines{c}.engines)
        x(d) = input_engines{c}.engines{d}.mass;
        y(d) = input_engines{c}.engines{d}.max_power;
    end
    
    B = x(1:size(input_engines{c}.engines))\y(1:size(input_engines{c}.engines));
    
    input_engines{c}.engines.b1 = B(1);
    input_engines{c}.engines.b0 = B(2);
    
end

data = input_engines;

end