%overkill solution para calcular o trem de aterragem mas considerando que
% o mtow está sujeito a alterações, esta é uma boa solução

% Main Landing Gear - Rodas Traseiras
Mtow   = 8000;  %Kg
Nrodas = 4;     

MtowLBS  = 8000*2.20462262;
Wwheel   = 0.9*MtowLBS/Nrodas;
DwheelIN = 1.51*Wwheel^0.349;
LwheelIN = 0.715*Wwheel^0.312;
Dwheel = DwheelIN*2.54
Lwheel = LwheelIN*2.54
LwheelTotal = Nrodas*Lwheel % comprimento total que as rodas todas vão ocupar
volume= LwheelTotal*pi*(Dwheel/2)^2/1000000
% Nose Landing Gear

disp("Nose Landing Gear - Rodas da Frente");
DwheelNL = Dwheel*0.4
LwheelNL = Lwheel*0.4
LwheelNLTotal = Nrodas/2*LwheelNL
volume2= LwheelNLTotal*(DwheelNL/2)^2*pi/1000000


%% ponto neutro 

%pelo azores vtol:

%wing
c=2;                % corda   
r= 0.7;             % posição da asa em relação ao inicio da fuselagem
wp = 1.5 + r;       % posição da asa
xw= wp + 0.25*c;   % considerando 0.25 de corda como o ponto aerodinamico
aw=0.106; % [/º]
Sw=30;    % [m^2]
lht=(1 - r) + 3;  % [m]
at=aw;
St=Sw;
e_alfa = 0.4;
%xpn=(xw*aw*Sw + (xw+lht)*at*St)/(at*St+aw*Sw)

%pela aula 11 só dá o centro aerodinamico da asa da frente :
% confirma-se os calculos
%wing
hnw=0.25; % xfoil considera 1/4 de corda como o ponto aerodinamico

hn=(hnw+(lht/c + hnw)*(1-e_alfa))/(1+1)
xpn=wp+hn*2

xcg = 4.37
SM=(xpn - xcg)/c

% cm_alfa
h= (xcg - 1.9)/c;
hnw = 0.25;
ht=hnw;

cm_alfa  = (aw*(xcg - xw) - (lht + xw - xcg)*at)/c*(1-e_alfa);
%confirmação
cl_alfa  = aw+at*(1-e_alfa);
cm_alfa1 = -cl_alfa*SM
