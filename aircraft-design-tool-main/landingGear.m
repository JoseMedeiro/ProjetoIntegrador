%overkill solution para calcular o trem de aterragem mas considerando que
% o mtow est� sujeito a altera��es, esta � uma boa solu��o

% Main Landing Gear - Rodas Traseiras
Mtow   = 8000;  %Kg
Nrodas = 4;     

MtowLBS  = 8000*2.20462262;
Wwheel   = 0.9*MtowLBS/Nrodas;
DwheelIN = 1.51*Wwheel^0.349;
LwheelIN = 0.715*Wwheel^0.312;
Dwheel = DwheelIN*2.54
Lwheel = LwheelIN*2.54
LwheelTotal = Nrodas*Lwheel % comprimento total que as rodas todas v�o ocupar
volume= LwheelTotal*pi*(Dwheel/2)^2/1000000
% Nose Landing Gear

disp("Nose Landing Gear - Rodas da Frente");
DwheelNL = Dwheel*0.4
LwheelNL = Lwheel*0.4
LwheelNLTotal = Nrodas/2*LwheelNL
volume2= LwheelNLTotal*(DwheelNL/2)^2*pi/1000000