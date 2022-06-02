x = linspace(0.2,1.4,13);
y = linspace(0.05,0.3,13);
[xx, yy] = meshgrid(x,y);

eff     = xx;
theta   = xx;

file = fopen('eff_1.txt','w');
for c=1:length(x)
    for d=1:length(y)
        fprintf(file,'%.2f %.3f\n', x(c), y(d));
    end
end