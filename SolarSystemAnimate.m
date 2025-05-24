function SolarSystemAnimate(data, View)
%
% This function generates a 3D animation for a 12-body problem which
% includes the Sun, Mercury, Venus, Earth, Luna (the Moon), Mars, Jupiter,
% Ganymede (Jupiter's Moon), Saturn, Titan (Saturn's Moon), Uranus, and
% Neptune
%
% All bodies are scaled so that they are appropriately visible for whichever View chosen 
% Inputs: 
%  - data = 72xN Matrix that describes position and velocity vectors of each
%    body. 
%  - View = Sets Different scaling, axis sizes, and orbital speeds depending on 
%    whether user wishes to see full-view or zoomed-in view of system.
% 
% Version 1: Created by Liam Whelan - 11/05/2025. 

data = load('finaldata.mat').Y;

% Default View if not inputted by User
    if nargin < 2
        View = 1;
    end

% Error Checking User Input
    if ~ismember(View, [1, 2])
        error('Invalid input: View must be either 1 (full view) or 2 (zoomed-in view).');
    end

% Body properties
masses = [1998.4e24, 0.3301e24, 4.8673e24, 5.9722e24, 0.07346e24, 0.64169e24, ...
           1898.13e24, 0.1482e24, 568.32e24, 0.1346e24, 86.611e24, 102.409e24];
radii_km = [695700, 2439.7, 6051.8, 6371, 1737.4, 3389.5, 66854, 2631, 58232, 2575, 25362, 24622];
AU = 149597870.7; % Astronomical Unit conversion in km 
radii_AU = radii_km ./ AU;
neptuneOrbitDays = 164.8 * 365; % Days for 1 Neptune orbit

% Constant scaling factors         
Mercury_scaling = 2500;  
Venus_scaling = 2000;    
Earth_scaling = 2000;    
Luna_scaling = 3250;     
Mars_scaling = 3000; 

% Set scaling and view options based on View
if View == 1  % Full view (exaggerated large outer planets)
    Sun_scaling = 100;
    Jupiter_scaling = 700;
    Ganymede_scaling = 5000;
    Saturn_scaling = 800;
    Titan_scaling = 5000;
    Uranus_scaling = 2000;
    Neptune_scaling = 1800;
    axisLimits = [-35 35 -35 35 -2 2];
    frameDividor = (neptuneOrbitDays / 5); % Changes Speed in Full View
elseif View == 2  % Zoomed-in view
    Sun_scaling = 50;
    Jupiter_scaling = 350;
    Ganymede_scaling = 2500;
    Saturn_scaling = 400;
    Titan_scaling = 2500;
    Uranus_scaling = 1000;
    Neptune_scaling = 900;
    axisLimits = [-8 8 -8 8 -2 2];
    frameDividor = (neptuneOrbitDays * 5); % Changes Speed of Zoomed in View
else
    error('Invalid viewMode. Use 1 (full view) or 2 (zoomed-in view).');
end

% Scaling Radii for Each Body 
scaledSun = Sun_scaling * radii_AU(1); 
scaledMercury = Mercury_scaling * radii_AU(2);
scaledVenus = Venus_scaling * radii_AU(3);
scaledEarth = Earth_scaling * radii_AU(4);
scaledLuna = Luna_scaling * radii_AU(5);
scaledMars = Mars_scaling * radii_AU(6);
scaledJupiter = Jupiter_scaling * radii_AU(7); 
scaledGanymede = Ganymede_scaling * radii_AU(8); 
scaledSaturn = Saturn_scaling * radii_AU(9); 
scaledTitan = Titan_scaling * radii_AU(10); 
scaledUranus = Uranus_scaling * radii_AU(11); 
scaledNeptune = Neptune_scaling * radii_AU(12); 

% Load textures for each body 
textures = struct();
textures.Stars = imread('Planet Images/Stars.jpg');
textures.Sun = imread('Planet Images/Sun.jpg');
textures.Mercury = imread('Planet Images/Mercury.jpg');
textures.Venus = imread('Planet Images/Venus.jpg');
textures.Earth = imread('Planet Images/Earth.jpg');
textures.Luna = imread('Planet Images/moon.jpg');
textures.Mars = imread('Planet Images/Mars.jpg');
textures.Jupiter = imread('Planet Images/Jupiter.jpg');
textures.Ganymede = imread('Planet Images/ganyede.jpg');
textures.Saturn = imread('Planet Images/Saturn.jpg');
textures.Titan = imread('Planet Images/titan.jpg');
textures.Uranus = imread('Planet Images/Uranus.jpg');
textures.Neptune = imread('Planet Images/Neptune.jpg');

% Create sphere mesh 
[x, y, z] = sphere(50);

%% Initialize Figure
figure('Renderer', 'opengl', 'Color', 'k', 'Position', [100 100 1200 800]);

% Setup video writer
v = VideoWriter('View2_Final_Video.mp4', 'MPEG-4'); % Create a video file
v.FrameRate = 50; % set frame rate to 50 fps to create smooth video 
open(v); % open file to write 

% Adding Stars to Background 
bg = axes('Position', [0 0 1 1]);
imagesc(textures.Stars);
set(bg, 'HandleVisibility', 'off', 'Visible', 'off');

% Main axes for planets
ax = axes('Position', [0 0 1 1], 'Projection','perspective','Color', 'none');
hold(ax, 'on');
axis(ax,'equal', 'vis3d');
grid(ax, 'on');
set(ax, 'GridColor', [1 1 1 0.3], 'Color', 'none');
xlabel(ax,'X (AU)', 'Color','w');
ylabel(ax, 'Y (AU)','Color', 'w');
zlabel(ax, 'Z (AU)', 'Color', 'w');
view(ax, 45,30);
rotate3d(ax, 'on');

% Set axis limits 
axis(ax, axisLimits);

%% Initialize Planets - Creating Spherical Shapes
% Sun
posSun = (data(1:3, 1));
Sun = surf(ax, x*scaledSun + posSun(1), y*scaledSun + posSun(2), z*scaledSun + posSun(3));
set(Sun, 'FaceColor', 'texture', 'CData', textures.Sun, 'EdgeColor', 'none');

% Inner planets (Mercury, Venus, Earth, Moon, Mars)
posMercury = (data(4:6, 1));
Mercury = surf(ax, x*scaledMercury + posMercury(1), y*scaledMercury + posMercury(2), z*scaledMercury + posMercury(3));
set(Mercury, 'FaceColor', 'texture', 'CData', textures.Mercury, 'EdgeColor', 'none');

posVenus = (data(7:9, 1));
Venus = surf(ax, x*scaledVenus + posVenus(1), y*scaledVenus + posVenus(2), z*scaledVenus + posVenus(3));
set(Venus, 'FaceColor', 'texture', 'CData', textures.Venus, 'EdgeColor', 'none');

posEarth = (data(10:12, 1));
Earth = surf(ax, x*scaledEarth + posEarth(1), y*scaledEarth + posEarth(2), z*scaledEarth + posEarth(3));
set(Earth, 'FaceColor', 'texture', 'CData', textures.Earth, 'EdgeColor', 'none');

lunaVec = data(13:15, 1) - data(10:12, 1);
lunaPos = posEarth + (lunaVec/norm(lunaVec)) * (scaledEarth + scaledLuna) * 1.1;
Luna = surf(ax, x*scaledLuna + lunaPos(1), y*scaledLuna + lunaPos(2), z*scaledLuna + lunaPos(3));
set(Luna, 'FaceColor', 'texture', 'CData', textures.Luna, 'EdgeColor', 'none');

posMars = (data(16:18, 1));
Mars = surf(ax, x*scaledMars + posMars(1), y*scaledMars + posMars(2), z*scaledMars + posMars(3));
set(Mars, 'FaceColor', 'texture', 'CData', textures.Mars, 'EdgeColor', 'none');

posJupiter = (data(19:21, 1));
Jupiter = surf(ax, x*scaledJupiter + posJupiter(1), y*scaledJupiter + posJupiter(2), z*scaledJupiter + posJupiter(3));
set(Jupiter, 'FaceColor', 'texture', 'CData', textures.Jupiter, 'EdgeColor', 'none');

ganyVec = data(22:24, 1) - data(19:21, 1);
ganyPos = posJupiter + (ganyVec/norm(ganyVec)) * (scaledJupiter + scaledGanymede) * 1.1;
Ganymede = surf(ax, x*scaledGanymede + ganyPos(1), y*scaledGanymede + ganyPos(2), z*scaledGanymede + ganyPos(3));
set(Ganymede, 'FaceColor', 'texture', 'CData', textures.Ganymede, 'EdgeColor', 'none');

posSaturn = (data(25:27, 1));
Saturn = surf(ax, x*scaledSaturn + posSaturn(1), y*scaledSaturn + posSaturn(2), z*scaledSaturn + posSaturn(3));
set(Saturn, 'FaceColor', 'texture', 'CData', textures.Saturn, 'EdgeColor', 'none');

titanVec = data(28:30, 1) - data(25:27, 1);
titanPos = posSaturn + (titanVec/norm(titanVec)) * (scaledSaturn + scaledTitan) * 1.1;
Titan = surf(ax, x*scaledTitan + titanPos(1), y*scaledTitan + titanPos(2), z*scaledTitan + titanPos(3));
set(Titan, 'FaceColor', 'texture', 'CData', textures.Titan, 'EdgeColor', 'none');

posUranus = (data(31:33, 1));
Uranus = surf(ax, x*scaledUranus + posUranus(1), y*scaledUranus + posUranus(2), z*scaledUranus + posUranus(3));
set(Uranus, 'FaceColor', 'texture', 'CData', textures.Uranus, 'EdgeColor', 'none');

posNeptune = (data(34:36, 1));
Neptune = surf(ax, x*scaledNeptune + posNeptune(1), y*scaledNeptune + posNeptune(2), z*scaledNeptune + posNeptune(3));
set(Neptune, 'FaceColor', 'texture', 'CData', textures.Neptune, 'EdgeColor', 'none');

%% Creating White Trails to Track Body Motion 
trailLength = 10000; % Shows the past positions of each planet 
trailData = struct(); % holds trail position arrays and plots handles

% Indices for each body's position in the data matrix
bodyNames = {'Sun', 'Mercury', 'Venus', 'Earth', 'Luna', 'Mars', 'Jupiter', 'Ganymede', 'Saturn',...
    'Titan', 'Uranus', 'Neptune'};
bodyIndices = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34];

for i = 1:length(bodyNames)
    trailData.(bodyNames{i}).X = nan(1, trailLength); % initialises x,y,z arrays
    trailData.(bodyNames{i}).Y = nan(1, trailLength); % NaN ensures trails dont render until real data is available 
    trailData.(bodyNames{i}).Z = nan(1, trailLength);
    trailData.(bodyNames{i}).Plot = plot3(ax, nan, nan, nan, 'w', 'LineWidth', 0.75);
end

% Creating a Figure that Counts Years and Days - from ChatGPT
dayCounter = annotation('textbox', [0.25, 0.92, 0.5, 0.05], 'String', '', ...
    'Color', 'white', 'EdgeColor', 'none', 'FontSize', 11, ...
    'FontWeight', 'bold', 'FontName', 'Helvetica', 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', 'Interpreter', 'none', 'BackgroundColor', 'none');
startDate = datetime(2025, 5, 5);

%% Animation Loop
totalFrames = size(data, 2);
skipFrames = max(1, floor(totalFrames / (frameDividor))); % Speed of Planet Orbits 

for t = 1:skipFrames:totalFrames
% Updating positions for Each Body
% Sun
posSun = (data(1:3, t));
set(Sun, 'XData', x*scaledSun + posSun(1), 'YData', y*scaledSun + posSun(2), 'ZData', z*scaledSun + posSun(3));

% Mercury
posMercury = (data(4:6, t));
set(Mercury, 'XData', x*scaledMercury + posMercury(1), 'YData', y*scaledMercury + posMercury(2), 'ZData', z*scaledMercury + posMercury(3));

% Venus
posVenus = (data(7:9, t));
set(Venus, 'XData', x*scaledVenus + posVenus(1), 'YData', y*scaledVenus + posVenus(2), 'ZData', z*scaledVenus + posVenus(3));

% Earth
posEarth = (data(10:12, t));
set(Earth, 'XData', x*scaledEarth + posEarth(1), 'YData', y*scaledEarth + posEarth(2), 'ZData', z*scaledEarth + posEarth(3));

% Mars
posMars = (data(16:18, t));
set(Mars, 'XData', x*scaledMars + posMars(1), 'YData', y*scaledMars + posMars(2), 'ZData', z*scaledMars + posMars(3));

% Jupiter
posJupiter = (data(19:21, t));
set(Jupiter, 'XData', x*scaledJupiter + posJupiter(1), 'YData', y*scaledJupiter + posJupiter(2), 'ZData', z*scaledJupiter + posJupiter(3));

% Saturn
posSaturn = (data(25:27, t));
set(Saturn, 'XData', x*scaledSaturn + posSaturn(1), 'YData', y*scaledSaturn + posSaturn(2), 'ZData', z*scaledSaturn + posSaturn(3));

% Adding Ring to Saturn 
ring_inner_radius = 1.5 * scaledSaturn;
ring_outer_radius = 2.0 * scaledSaturn;
num_points = 100;

% Create polar ring coordinates
theta = linspace(0, 2*pi, num_points);
r = linspace(ring_inner_radius, ring_outer_radius, 2);
[Theta, R] = meshgrid(theta, r);

% Polar to Cartesian in Saturn’s local frame (XY plane)
X_ring = R .* cos(Theta);
Y_ring = R .* sin(Theta);
Z_ring = zeros(size(X_ring));  % flat ring in Saturn's XY plane

% Tilting Ring
tilt_deg = 27;  % Saturn's axial tilt - from space.com 
tilt_rad = (tilt_deg) * (2*pi()/60);%deg2rad(tilt_deg);
Ry = [cos(tilt_rad), 0, sin(tilt_rad); 0, 1, 0; -sin(tilt_rad), 0, cos(tilt_rad)];

% Flatten matrices and apply rotation
ring_coords = [X_ring(:)'; Y_ring(:)'; Z_ring(:)'];
rotated_coords = Ry * ring_coords;

% Reshape back to meshgrid shape
X_ring_rot = reshape(rotated_coords(1, :), size(X_ring)) + posSaturn(1);
Y_ring_rot = reshape(rotated_coords(2, :), size(Y_ring)) + posSaturn(2);
Z_ring_rot = reshape(rotated_coords(3, :), size(Z_ring)) + posSaturn(3);

% Updating Ring
if exist('saturn_ring_surf', 'var') && isvalid(saturn_ring_surf)
    set(saturn_ring_surf, 'XData', X_ring_rot, 'YData', Y_ring_rot, 'ZData', Z_ring_rot);
else
    saturn_ring_surf = surf(X_ring_rot, Y_ring_rot, Z_ring_rot, 'FaceColor', [0.8 0.8 0.6], ...
        'EdgeColor', 'none', 'FaceAlpha', 0.5);
end

% Uranus
posUranus = (data(31:33, t));
set(Uranus, 'XData', x*scaledUranus + posUranus(1), 'YData', y*scaledUranus + posUranus(2), 'ZData', z*scaledUranus + posUranus(3));

% Neptune
posNeptune = (data(34:36, t));
set(Neptune, 'XData', x*scaledNeptune + posNeptune(1), 'YData', y*scaledNeptune + posNeptune(2), 'ZData', z*scaledNeptune + posNeptune(3));

% Luna (Earth's moon)
lunaVec = data(13:15, t) - data(10:12, t);
lunaPos = posEarth + (lunaVec/norm(lunaVec)) * (scaledEarth + scaledLuna) * 1.1;
set(Luna, 'XData', x*scaledLuna + lunaPos(1), 'YData', y*scaledLuna + lunaPos(2), 'ZData', z*scaledLuna + lunaPos(3));

% Ganymede (Jupiter's moon)
ganyVec = data(22:24, t) - data(19:21, t);
ganyPos = posJupiter + (ganyVec/norm(ganyVec)) * (scaledJupiter + scaledGanymede) * 1.1;
set(Ganymede, 'XData', x*scaledGanymede + ganyPos(1), 'YData', y*scaledGanymede + ganyPos(2), 'ZData', z*scaledGanymede + ganyPos(3));

% Titan (Saturn's moon)
titanVec = data(28:30, t) - data(25:27, t);
titanPos = posSaturn + (titanVec/norm(titanVec)) * (scaledSaturn + scaledTitan) * 1.1;
set(Titan, 'XData', x*scaledTitan + titanPos(1), 'YData', y*scaledTitan + titanPos(2), 'ZData', z*scaledTitan + titanPos(3));

%% Updating Body Trails as they Move
for i = 1:length(bodyNames)
    idx = bodyIndices(i);
    pos = (data(idx:idx+2, t)); % Get XYZ for body i
    
    % Shift and update trail buffers
    trailData.(bodyNames{i}).X = [trailData.(bodyNames{i}).X(2:end), pos(1)];
    trailData.(bodyNames{i}).Y = [trailData.(bodyNames{i}).Y(2:end), pos(2)];
    trailData.(bodyNames{i}).Z = [trailData.(bodyNames{i}).Z(2:end), pos(3)];
    
    % Update the plot
    set(trailData.(bodyNames{i}).Plot, 'XData', trailData.(bodyNames{i}).X, 'YData', trailData.(bodyNames{i}).Y, ...
        'ZData', trailData.(bodyNames{i}).Z);
end

% Keep Updating and Counting Earth Days on Figure generated from ChatGPT
stepSizeDays = 0.448;  % Corrected step size
earthDays = (t - 1) * stepSizeDays;
year = floor(earthDays / 365);
day = mod(earthDays, 365);
currentDate = startDate + days(earthDays);
timeString = sprintf('Date: %s   |   Year %3d   |   Day %6.1f   |   %7.0f Earth Days', ...
    datestr(currentDate, 'dd-mmm-yyyy'), year, day, earthDays);
set(dayCounter, 'String', timeString);

    
%% Zooming in on Planets with Moons (Earth, Jupiter, and Saturn)
% Create Different Zooms depending on user input (1 or 2)
if View == 1
    fullViewFrames = 7000; % Hold full view for a few seconds
    zoomInFrames = 5000; % slowly zoom in on Saturn
    saturnOrbitFrames = 4*10767.5; %107675; % duration of 4 orbits of saturn 
    jupiterOrbitFrames = 5* 4332.6; % Duration of 5 orbits of Jupiter
    zoomOutFrames = 4000; % Frames to zoom back out

    % Total timeline checkpoints - set when camera pans, or zooms in or out
    saturnStart = fullViewFrames + 1;
    saturnEnd = saturnStart + zoomInFrames + saturnOrbitFrames;
    jupiterEnd = saturnEnd + jupiterOrbitFrames;
    zoomOutEnd = jupiterEnd + zoomOutFrames;

    if t <= fullViewFrames % Hold full view before zoom begins
        focus = [0; 0; 0];
        margin = 35;

    elseif t <= fullViewFrames + zoomInFrames % Smooth zoom from global to Saturn
        frac = (t - fullViewFrames) / zoomInFrames;
        focus = (1 - frac) * [0; 0; 0] + frac * posSaturn;
        margin = (1 - frac) * 35 + frac * 3;

    elseif t <= saturnEnd % Focused on Saturn
        focus = posSaturn;
        margin = 3;

    elseif t <= jupiterEnd % Pan to Jupiter
        frac = (t - saturnEnd) / jupiterOrbitFrames;
        focus = (1 - frac) * posSaturn + frac * posJupiter;
        margin = 8;

    elseif t <= zoomOutEnd % Smooth zoom out to full view
        frac = (t - jupiterEnd) / zoomOutFrames;
        focus = (1 - frac) * posJupiter + frac * [0; 0; 0];
        margin = (1 - frac) * 8 + frac * 35;

    else % Stay in full view
        focus = [0; 0; 0];
        margin = 35;
    end

    % Set axis limits
    axis(ax, [focus(1) - margin, focus(1) + margin, focus(2) - margin, focus(2) + margin, ...
              focus(3) - 1.5, focus(3) + 1.5]);
    axis off
end

if View == 2
    earthOrbitFrames = 3650; % 365 days x 10
    zoomInFrames = 2500; % slow zoom in and zoom out of Earth

    if t <= zoomInFrames % Smooth zoom in to Earth
        frac = t / zoomInFrames;
        focus = (1 - frac) * [0; 0; 0] + frac * posEarth;
        margin = (1 - frac) * 5 + frac * 0.3;

    elseif t <= zoomInFrames + earthOrbitFrames % Stay focused on Earth
        focus = posEarth;
        margin = 0.3;

    elseif t <= zoomInFrames + earthOrbitFrames + zoomInFrames % Smooth zoom back out to default zoomed-in view
        frac = (t - (zoomInFrames + earthOrbitFrames)) / zoomInFrames;
        focus = (1 - frac) * posEarth + frac * [0; 0; 0];
        margin = (1 - frac) * 0.3 + frac * 5;

    else % Default zoomed-in view
        focus = [0;0; 0];
        margin = 6;
    end

    % Apply the axis limits
    axis(ax, [focus(1) - margin, focus(1) + margin, focus(2)- margin, focus(2) + margin, ...
              focus(3) -1.5, focus(3) + 1.5]);
    axis off
end
   
% Capture and write frame to video
frame = getframe(gcf); % capture current figure as a frame 
writeVideo(v, frame); % turn frame into video 

% Force draw and pace animation
drawnow limitrate;
end
close(v); % finalise, close and save video file