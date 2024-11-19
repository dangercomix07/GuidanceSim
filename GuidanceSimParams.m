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
