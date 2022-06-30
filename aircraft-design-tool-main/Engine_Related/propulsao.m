%dados
a_z   = 4;
Mass  = 4566.207990022439;
W     = Mass*9.81;
NR    = 4;
WA    = W/45 ;
M     = 0.55;
a     = 338.37;
P     = [500000 600000];
ro    = 1.21;
CpCt  = [1.46 1.27];


%calculos
%thrust requerida
Tmin = (W+a_z)/NR

%radius
r = 1.9;
d = 2*r;

%rotacional speed
nmax = (M*a)/(pi*d);

%Power needed
for i=1:1:2
    Cp (i) = P(i)/(ro*nmax^3*d^5);
    T (i)  = P(i)/(nmax*d)*CpCt (i);
end

Tmin = (W)*0.57/2

C_p = P(2)/(ro*nmax^3*d^5)
T   = P(2)/(nmax*d)*CpCt(2)




