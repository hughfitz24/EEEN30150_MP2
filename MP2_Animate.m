%% MP2 Animation 
% Recieves data from a 72 x 120831 matrix - XYZ position and velocity
% vectors for 12 planets for 2 Neptune Orbits 

% Masses in kg
masses = [1998.4e24, 0.3301e24, 4.8673e24, 5.9722e24, 0.07346e24, 0.64169e24, 1898.13e24, 0.1482e24,...
          568.32e24, 0.1346e24, 86.611e24, 102.409e24];

% Radii in km 
radii_km = [695700, 2439.7, 6051.8, 6371, 1737.4, 3389.5, 66854, 2631, 58232, 2575, 25362, 24622];
AU = 149597870.7; % in km

data = load('solar_system_animation_test_data.mat').test_stub_state_vectors;
data = data./(AU*1000);
%disp(size(data))

% Converting Radii to AU
radii_AU = radii_km./AU;
%disp(radii_AU(2))

%% Scaling Bodies --> **CHECK VALUES
% Sun Scalinv
Sun_scaling = 100; 
scaledSun = Sun_scaling*radii_AU(1);

% Mercury Scaling 
Mercury_scaling = 6000;
scaledMercury = Mercury_scaling*radii_AU(2);

% Venus Scaling 
Venus_scaling = 4000;
scaledVenus = Venus_scaling*radii_AU(3);

% Earth Scaling
Earth_scaling = 4000;
scaledEarth = Earth_scaling *radii_AU(4);

% Moon Scaling
Moon_scaling = 7000;
scaledMoon = Moon_scaling *radii_AU(5);

% Mars Scaling 
Mars_scaling = 6500; 
scaledMars = Mars_scaling*radii_AU(6);

% Jupiter Scaling
Jupiter_scaling = 800; 
scaledJupiter = Jupiter_scaling*radii_AU(7);

% Ganyede Scaling 
Ganymede_scaling = 6000;
scaledGanyede = Ganymede_scaling*radii_AU(8);

% Saturn Scaling 
Saturn_scaling = 1000; 
scaledSaturn = Saturn_scaling*radii_AU(9);

% Titan Scaling 
Titan_scaling = 6000; 
scaledTitan = Titan_scaling*radii_AU(10);

% Uranus Scaling 
Uranus_scaling = 3000;
scaledUranus = Uranus_scaling*radii_AU(11);

% Neptune Scaling 
Neptune_scaling = 3000;
scaledNeptune = Neptune_scaling*radii_AU(12);

% Adding Body Textures
Stars_image    = imread('Planet Images/Stars.jpg');
Sun_image      = imread('Planet Images/Sun.jpg');
Mercury_image  = imread('Planet Images/Mercury.jpg');
Venus_image    = imread('Planet Images/Venus.jpg');
Earth_image    = imread('Planet Images/Earth.jpg');
Moon_image     = imread('Planet Images/moon.jpg');
Mars_image     = imread('Planet Images/Mars.jpg');
Jupiter_image  = imread('Planet Images/Jupiter.jpg');
Ganymede_image = imread('Planet Images/ganyede.jpg');
Saturn_image   = imread('Planet Images/Saturn.jpg');
Titan_image    = imread('Planet Images/titan.jpg');
Uranus_image   = imread('Planet Images/Uranus.jpg');
Neptune_image  = imread('Planet Images/Neptune.jpg');

% Generating a sphere in the x,y,z with 50 points 
[x,y,z] = sphere(50);

% ADD an adjustment of the radii of the moons? For no collision???

%% Creating Plot
% Create Figure and 3D Axes with Transparent Background
figure('Renderer', 'opengl', 'Color', 'k');  % Black figure background

% Create background axes for the starfield
background = axes('Units','normalized','Position',[0 0 1 1]);
imagesc(Stars_image);
set(background, 'HandleVisibility','off','Visible','off', ...
                'XColor','none', 'YColor','none', 'Color', 'none');
axis(background, 'off');

% Create foreground axes for the solar system with **no background fill**
hAx = axes('Units','normalized','Position',[0 0 1 1], ...
           'Projection','perspective', 'Color', 'none');
hold(hAx, 'on');
axis(hAx, 'equal');
axis(hAx, 'vis3d');
xlabel(hAx, 'X (AU)', 'FontSize',12, 'Color','w');
ylabel(hAx, 'Y (AU)', 'FontSize',12, 'Color','w');
zlabel(hAx, 'Z (AU)', 'FontSize',12, 'Color','w');
view(hAx, 45, 30);
rotate3d(hAx, 'on');  % Enable interactive rotation

% Push background stars underneath planets
uistack(background, 'bottom');  % Keeps starfield as lowest layer
uistack(hAx, 'top');  % Ensures planets stay visible

%% Creating Spherical Planets 
% Create Sun 
Sun = surf((x*scaledSun) + data(1,1), (y*scaledSun) + data(2,1), (z*scaledSun) + data(3,1));
set(Sun, 'facecolor','texturemap','cdata',Sun_image,'edgecolor','none');

% Create Mercury 
Mercury = surf((x*scaledMercury) + data(7,1), (y*scaledMercury) + data(8,1), (z*scaledMercury) + data(9,1));
set(Mercury, 'facecolor','texturemap','cdata',Mercury_image,'edgecolor','none');

% Create Venus 
Venus = surf((x*scaledVenus) + data(13,1), (y*scaledVenus) + data(14,1), (z*scaledVenus) + data(15,1));
set(Venus, 'facecolor','texturemap','cdata', Venus_image,'edgecolor','none');

% Create Earth 
Earth = surf((x*scaledEarth) + data(19,1), (y*scaledEarth) + data(20,1), (z*scaledEarth) + data(21,1));
set(Earth, 'facecolor','texturemap','cdata',Earth_image,'edgecolor','none');

% Create Moon 
Moon = surf((x*scaledMoon) + data(25,1), (y*scaledMoon) + data(26,1), (z*scaledMoon) + data(27,1));
set(Moon, 'facecolor','texturemap','cdata',Moon_image,'edgecolor','none');

% Create Mars
Mars = surf((x*scaledMars) + data(31,1), (y*scaledMars) + data(32,1), (z*scaledMars) + data(33,1));
set(Mars, 'facecolor','texturemap','cdata',Mars_image,'edgecolor','none');

% Jupiter 
Jupiter = surf((x*scaledJupiter) + data(37,1), (y*scaledJupiter) + data(38,1), (z*scaledJupiter) + data(39,1));
set(Jupiter, 'facecolor','texturemap','cdata',Jupiter_image,'edgecolor','none');

% Create Ganymede
Ganyede = surf((x*scaledGanyede) + data(43,1), (y*scaledGanyede) + data(44,1), (z*scaledGanyede) + data(45,1));
set(Ganyede, 'facecolor','texturemap','cdata',Ganyede_image,'edgecolor','none');

% Create Saturn
Saturn = surf((x*scaledSaturn) + data(49,1), (y*scaledSaturn) + data(50,1), (z*scaledSaturn) + data(51,1));
set(Saturn, 'facecolor','texturemap','cdata',Saturn_image,'edgecolor','none');

% Create Titan
Titan = surf((x*scaledTitan) + data(55,1), (y*scaledTitan) + data(56,1), (z*scaledTitan) + data(57,1));
set(Titan, 'facecolor','texturemap','cdata',Titan_image,'edgecolor','none');

% Create Uranus
Uranus = surf((x*scaledUranus) + data(61,1), (y*scaledUranus) + data(62,1), (z*scaledUranus) + data(63,1));
set(Uranus, 'facecolor','texturemap','cdata',Uranus_image,'edgecolor','none');

% Create Neptune
Neptune = surf((x*scaledNeptune) + data(67,1), (y*scaledNeptune) + data(68,1), (z*scaledNeptune) + data(69,1));
set(Neptune, 'facecolor','texturemap','cdata',Neptune_image,'edgecolor','none');

%% Creating Trails for Each Planets Orbit  
k = 1:120381; % Number of positions of each body (2 orbits of Neptune)

% Sun Trail
plot3(data(1,k), data(2,k), data(3,k));

% Mercury Trail 
plot3(data(7,k), data(8,k), data(9,k));

% Venus Trail 
plot3(data(13,k), data(14,k), data(15,k));

% Earth Trail 
plot3(data(19,k), data(20,k), data(21,k));

% Moon Trail 
plot3(data(25,k), data(26,k), data(27,k));

% Mars Trail 
plot3(data(31,k), data(32,k), data(33,k));

% Jupiter Trail 
plot3(data(37,k), data(38,k), data(39,k));

% Ganymede Trail 
plot3(data(43,k), data(44,k), data(45,k));

% Saturn Trail 
plot3(data(49,k), data(50,k), data(51,k));

% Titan Trail 
plot3(data(55,k), data(56,k), data(57,k));

% Uranus Trail 
plot3(data(61,k), data(62,k), data(63,k));

% Neptune Trail 
plot3(data(67,k), data(68,k), data(69,k));