function data = load_eff_funciton(file_name)


file = fopen(file_name,'r');

first_data = fscanf(file,'%f %f %f',[3 Inf]);
first_data = first_data.';

x = 0.2:0.001:2.8;
y = 0.05:0.005:0.50;
[X,Y] = meshgrid(x,y);
data.X = X;
data.Y = Y;
data.Z = griddata(first_data(:,1), first_data(:,2), first_data(:,3), X, Y,'cubic');

end