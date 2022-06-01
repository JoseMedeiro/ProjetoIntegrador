MTOW=8000;
l1=6;
d=2.25;
l2=1.5;
l=l1+2*l2;
S=d*l2*+d*l1;
Swet=1.7*2*S;
Sasas=45;
pho = 1.1;
vel = 100;
q=0.5*pho*vel^2;
mu = 17.54e-6;
a=336.052;
M=vel/a;
Q=1.5;
Re = (pho*chord*vel)/mu;
%Verificação de turbulencia (>1000)
sqrt(Re);
%Calculo de CD0
Cf=0.455/((log10(Re)^2.58)*(1+0.144*M^2)^0.65);
F=1+60/(l/d)^3+(l/d)/400;
Ff=q*Cf*F*Q;
Cd0=Ff/(q*Sasas)
racio=d/l

