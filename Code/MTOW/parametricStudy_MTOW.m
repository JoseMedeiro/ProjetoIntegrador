clear all;

%sim_model parameters
  % x(1) - lift to drag ratio                   (-)
  % x(2) - disk loading                         (N/m^2) 
  % x(3) - wing's aspect ratio                  (-)
  % x(4) - cruise speed                         (m/s) 	
  % x(5) - 1 trip range                         (km)
  % x(6) - payload                              (kg)
  % x(7) - Mach number at the tip of the blade  (-)
  % x(8) - solidity                             (-)
  % x(9) - maximum thickness to chord ratio     (-)
  % x(10) - hybridization factor in cruise      (-)
x = [15, 1130, 5, 100, 70, 2000, 0.7, 0.08, 0.12, 0];

  
INDEX = 20;


%3D graph: cruise speed vs ld
ld = linspace(4     , 12    , INDEX);
cs = linspace(80    , 140   , INDEX);
[ld_g,cs_g] = meshgrid(ld, cs);
mtow_cs_ld = zeros(length(cs), length(ld));
for c = 1:length(cs)
    for d = 1:length(ld)
        aux = sim_model_MTOW([ld(d), x(2), x(3), cs(c), x(5), x(6), x(7), x(8), x(9), x(10)]);
        mtow_cs_ld(c,d) = aux(2);
    end
end

figure(2)
surf(ld_g,cs_g,mtow_cs_ld)
grid on
ylabel('Cruise Speed (m/s)')
xlabel('L/D');
zlabel('MTOW (kg)')

%3D graph: disc loading vs ld
ld = linspace(4     , 12    , INDEX);
dl = linspace(700   , 1200  , INDEX);
[ld_g,dl_g] = meshgrid(ld, dl);
mtow_dl_ld = zeros(length(dl), length(ld));
for c = 1:length(dl)
    for d = 1:length(ld)
        aux = sim_model_MTOW([ld(d), dl(c), x(3), x(4), x(5), x(6), x(7), x(8), x(9), x(10)]);
        mtow_dl_ld(c,d) = aux(2);
    end
end

figure(3)
surf(ld_g,dl_g,mtow_dl_ld)
grid on
xlabel('L/D')
ylabel('Disc Loading (N/m^2)')
zlabel('MTOW (kg)')

%3D graph: disc loading vs cs
dl = linspace(700   , 1200  , INDEX);
cs = linspace(80    , 140   , INDEX);
[cs_g,dl_g] = meshgrid(cs, dl);
mtow_dl_cs = zeros(length(dl), length(cs));
for c = 1:length(dl)
    for d = 1:length(cs)
        aux = sim_model_MTOW([x(1), dl(c), x(3), cs(d), x(5), x(6), x(7), x(8), x(9), x(10)]);
        mtow_dl_cs(c,d) = aux(2);
    end
end

figure(4)
surf(cs_g,dl_g,mtow_dl_cs)
grid on
xlabel('Cruise Speed (m/s)')
ylabel('Disc Loading (N/m^2)')
zlabel('MTOW (kg)')
