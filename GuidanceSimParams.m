%% GUIDANCESIM

% Author: Ameya Marakarkandy
% Email: ameya.marakarkandy@gmail.com
%
% Simulation Models:
% - GuidanceSimV2: Only PN Guidance
% - GuidanceSimV3: Selectable PN, TPN, RTPN, GTPN, IPN Implementation
%
% Assumptions:
% - Constant velocity target
% - Ideal Autopilot

clc; close all; clearvars;

%% INITIAL CONDITIONS

LOS = deg2rad(30);                   % [rad] Initial Line of Sight Angle
R = 20e03;                           % [m] Initial Range

% TARGET
xT = R*cos(LOS);
zT = -R*sin(LOS);
RT = [xT;zT];                        % [m] Target Position (2x1)
gT = deg2rad(120);                   % [rad] Target Flight Path Angle
TS = 400;                            % [m/s] Target Speed
VT = [400*cos(gT),-400*sin(gT)];     % [m/s] Target Velocity (2x1)

% MISSILE
xM = 0;
zM = 0;
RM = [xM;zM];                       % [m] Missile Position (2x1)
gM = deg2rad(70);                   % [rad] Missile Flight Path Angle
%gM = asin(2/3*sin(gT-LOS))+LOS;
MS = 600;                           % [m/s] Missile Speed
VM = [600*cos(gM),-600*sin(gM)];    % [m/s] Missile Velocity (2x1)

Rlethal = 1;                        % [m] Lethal radius

%% GUIDANCE

% Guidance Law type
% 1 = Pure PN (PPN)
% 2 = True PN (TPN)
% 3 = Realistic TPN (RTPN)
% 4 = Generalised TPN (GTPN)
% 5 = Ideal PN (IPN)
type = 1;

Wn_hom = 7; % Seeker Estimator Bandwidth
Vcinit = MS*cos(gM-LOS)-TS*cos(gT-LOS); % Initial Closing Velocity

N = 3; % Navigation Constant
Ndash = N*MS/Vcinit; % Effective Navigation Constant
eta = deg2rad(10);

% Normal acceleration demand limits
a_max = 1;
a_min = -1;

%% AUTOPILOT

% TO BE IMPLEMENTED

% 3-Loop Autopilot Structure
% Inner loops for pitch rate (q) control
% Outer loop for normal acceleration control

%% SIMULATION

% Store results for each guidance type
guidance_names = {'Pure PN (PPN)', 'True PN (TPN)', 'Realistic TPN (RTPN)', ...
                  'Generalised TPN (GTPN)', 'Ideal PN (IPN)'};
num_guidance_types = 5;
simulation_results = cell(num_guidance_types, 1);

for type = 1:num_guidance_types
    % Set the guidance type
    out = sim("GuidanceSimV3", 'SaveOutput', 'on');
    
    % Store simulation results
    simulation_results{type}.Name = guidance_names{type};
    simulation_results{type}.time = out.tout;
    simulation_results{type}.Am_c = getElement(out.yout, 'Am_c').Values.Data;
    simulation_results{type}.RM = getElement(out.logsout, 'missile position').Values.Data;
    simulation_results{type}.VM = getElement(out.logsout, 'missile velocity').Values.Data;
    simulation_results{type}.gM = getElement(out.logsout, 'missileFPA').Values.Data;
end

%% ANALYSIS::GUIDANCE LAWS INDIVIDUALLY

% Plot trajectories and commanded accelerations
for type = 1:num_guidance_types
    data = simulation_results{type};
    
    % Plot trajectory
    figure;
    plot(data.RM(:, 1), -data.RM(:, 2), 'LineWidth', 2);
    axis equal
    xlabel('X Position (m)');
    ylabel('Z Position (m)');
    title(['Missile Trajectory - ', data.Name]);
    grid on;
    
    % Plot commanded acceleration
    figure;
    plot(data.time, data.Am_c, 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Commanded Acceleration (m/s²)');
    title(['Commanded Acceleration - ', data.Name]);
    grid on;
end

%% ANALYSIS::COMPARISON OF GUIDANCE LAWS

figure;
hold on;
legends = cell(num_guidance_types, 1);

for type = 1:num_guidance_types
    data = simulation_results{type};
    plot(data.time, data.Am_c,'LineWidth',2);
    legends{type} = guidance_names{type};
end

legend(legends, 'Location', 'best');
xlabel('Time [s]');
ylabel('Acceleration Command [m/s^2]');
title('Comparison of Guidance Laws (Guidance Commands)');
grid on;
hold off;

% Plot all trajectories
figure;
hold on;
for type = 1:num_guidance_types
    data = simulation_results{type};
    plot(data.RM(:, 1), -data.RM(:, 2),'LineWidth',2);
end
axis equal
legend(legends, 'Location', 'best');
xlabel('X Position (m)');
ylabel('Z Position (m)');
title('Comparison of Guidance Laws (Trajectory)');
grid on;
hold off;

%% SAVING OUTPUT

output_folder = fullfile(pwd, 'Figures'); % Absolute path to 'Figures' folder
if ~exist(output_folder, 'dir')
    mkdir(output_folder); % Create the folder if it doesn't exist
end

% Save acceleration command comparison
figure_name = fullfile(output_folder, 'Guidance_Command_Comparison.png');
saveas(figure(11), figure_name);

% Save trajectory comparison
figure_name = fullfile(output_folder, 'Trajectory_Comparison.png');
saveas(figure(12), figure_name);

% Save individual plots for each guidance law
for type = 1:num_guidance_types
    % Save commanded acceleration
    figure_name = fullfile(output_folder, sprintf('%s_Commanded_Acceleration.png', guidance_names{type}));
    saveas(figure(2*type), figure_name);
    
    % Save trajectory
    figure_name = fullfile(output_folder, sprintf('%s_Trajectory.png', guidance_names{type}));
    saveas(figure(2*type-1), figure_name);
end

disp(['All figures have been saved to the folder: ', output_folder]);

