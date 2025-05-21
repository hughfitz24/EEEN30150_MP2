function num = Numerator 
masses = [1.9984E30;    % Sun
          3.301E23;     % Mercury
          4.8673E24;    % Venus
          5.9722E24;    % Earth
          7.346E22;     % Luna
          6.4169E23;    % Mars
          1.89813E27;   % Jupiter
          1.482E23;     % Ganymede
          5.6832E26;    % Saturn
          1.346E23;     % Titan
          8.6611E25;    % Uranus
          1.02409E26];  % Neptune

G = 6.6743E-11; % m^3 kg^-1 s^-2
AU = 149597870100; % m
day = 86400; % s

G_scaled = G*day^2*AU^-3; % AU^3 kg^-1 day^-2

num = G_scaled.*masses;