%% GUIDANCESIM
% Author: Ameya Marakarkandy
% Email: ameya.marakarkandy@gmail.com

clc; close all; clearvars;

%% INITIAL CONDITIONS
LOS = deg2rad(30);

% TARGET
xT = 20e03*cos(LOS);
zT = -20e03*sin(LOS);
RT = [xT;zT];
gT = deg2rad(120);
TS = 400; % Target Speed
VT = [400*cos(gT),-400*sin(gT)];     %[m/s] Target Velocity

% MISSILE
xM = 0;
zM = 0;
RM = [xM;zM];
%gM = deg2rad(30);
gM = asin(2/3*sin(gT-LOS))+LOS;
MS = 600; % Missile Speed
VM = [600*cos(gM),-600*sin(gM)];

Rlethal = 1; % Lethal radius

%% GUIDANCE
Wn_hom = 7; % Seeker Estimator Bandwidth
Vcinit = MS*cos(gM-LOS)-TS*cos(gT-LOS); % Initial Closing Velocity

N = 3.5; % Navigation Constant
Ndash = N*MS/Vcinit; % Effective Navigation Constant
% Normal acceleration demand limits
a_max = 10;
a_min = -10;

%% AUTOPILOT
% 3-Loop Autopilot Structure
% Inner loops for pitch rate (q) control
% Outer loop for normal acceleration control
