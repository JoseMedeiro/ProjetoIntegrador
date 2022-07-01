%dados
a_z   = 4;
Mass  = 4.454655390850121e+03;
W     = Mass*9.81;
M     = [0.55 0.6];
a     = 338.37;
P     = [615400 769200];
ro    = 1.21;
CpCt  = [1.2 1.21];

% Calculos
%   radius
r = 1.9;
d = 2*r;
%   rotacional speed
nmax = (M*a)./(pi*d);

%Power obtained
for i=1:1:2
    Cp (i) = P(i)/(ro*nmax(i)^3*d^5);
    T (i)  = P(i)/(nmax(i)*d)*CpCt (i);
end

fprintf('NORMAL | Cp = %f, T = %f N, T = %f per cent\n',Cp(1), T(1), T(1)/W);
fprintf('EXTRA  | Cp = %f, T = %f N, T = %f per cent\n',Cp(2), T(2), T(2)/W);




