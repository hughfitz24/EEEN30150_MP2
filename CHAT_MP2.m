%% Load and Setup
AU = 149597870.7;  % km per AU

% Load 72×120381 matrix (6 rows per body: x y z vx vy vz)
data = load('solar_system_animation_test_data.mat').test_stub_state_vectors;
data = data ./ (AU * 1000);  % Convert from meters to AU

numSteps = size(data, 2);
numBodies = 12;

% Masses (kg) and scaled radii
masses = [1998.4e24, 0.3301e24, 4.8673e24, 5.9722e24, 0.07346e24, ...
          0.64169e24, 1898.13e24, 0.1482e24, 568.32e24, 0.1346e24, ...
          86.611e24, 102.409e24];
radii_km = [695700, 2439.7, 6051.8, 6371, 1737.4, 3389.5, ...
            66854, 2631, 58232, 2575, 25362, 24622];
radii_AU = radii_km / AU;

% Planet scaling for visibility
scalings = [100, 6000, 4000, 4000, 7000, 6500, ...
            800, 6000, 1000, 6000, 3000, 3000];
scaledRadii = scalings .* radii_AU;

% Load textures
textures = {
    imread('Planet Images/Sun.jpg');
    imread('Planet Images/Mercury.jpg');
    imread('Planet Images/Venus.jpg');
    imread('Planet Images/Earth.jpg');
    imread('Planet Images/moon.jpg');
    imread('Planet Images/Mars.jpg');
    imread('Planet Images/Jupiter.jpg');
    imread('Planet Images/ganyede.jpg');
    imread('Planet Images/Saturn.jpg');
    imread('Planet Images/titan.jpg');
    imread('Planet Images/Uranus.jpg');
    imread('Planet Images/Neptune.jpg')
};

% Planet names for legend/debugging
bodyNames = {'Sun','Mercury','Venus','Earth','Moon','Mars','Jupiter','Ganymede','Saturn','Titan','Uranus','Neptune'};

%% Create Figure
figure('Color', 'k', 'Renderer','opengl');

% Background starfield
background = axes('Units','normalized','Position',[0 0 1 1]);
imagesc(imread('Planet Images/Stars.jpg'));
set(background, 'HandleVisibility','off','Visible','off', 'Color','none');
axis(background, 'off');

% Foreground 3D axis
hAx = axes('Units','normalized','Position',[0 0 1 1], ...
           'Projection','perspective', 'Color','none');
hold(hAx, 'on');
axis(hAx, 'equal');
axis(hAx, 'vis3d');
view(hAx, 45, 30);
xlabel('X (AU)','Color','w');
ylabel('Y (AU)','Color','w');
zlabel('Z (AU)','Color','w');
xlim([-35 35]); ylim([-35 35]); zlim([-5 5]);
rotate3d(hAx, 'on');
uistack(hAx, 'top');
uistack(background, 'bottom');

% Sphere base
[xs, ys, zs] = sphere(50);

%% Create Planet Handles
planetSurfs = gobjects(numBodies, 1);
for b = 1:numBodies
    row = (b-1)*6 + 1;
    pos = data(row:row+2, 1);  % x,y,z at t=1
    R = scaledRadii(b);
    planetSurfs(b) = surf(hAx, R*xs + pos(1), R*ys + pos(2), R*zs + pos(3));
    set(planetSurfs(b), 'FaceColor','texturemap', 'EdgeColor','none', ...
        'CData', imresize(textures{b}, [size(xs,1), size(xs,2)]));
end

%% === Animation Loop ===
for t = 1:10:numSteps  % Adjust step size for speed (e.g., every 300 days)
    % Get all body positions at time t
    positions = zeros(numBodies, 3);
    for b = 1:numBodies
        row = (b-1)*6 + 1;
        positions(b,:) = data(row:row+2, t);
    end

    % Compute barycentre
    barycentre = sum(positions .* masses', 1) / sum(masses);

    for b = 1:numBodies
    R = scaledRadii(b);
    row = (b-1)*6 + 1;
    
    % Sun is already at the barycentre (0,0,0), so no need to subtract it
    if b == 1
    pos = data(row:row+2, t);  
    else
    pos = data(row:row+2, t);
    end
    set(planetSurfs(b), ...
        'XData', R*xs + pos(1), ...
        'YData', R*ys + pos(2), ...
        'ZData', R*zs + pos(3));
    
end

    title(hAx, sprintf('Day %d (%.1f years)', t, t/365.25), 'Color','w');
    drawnow;
end
