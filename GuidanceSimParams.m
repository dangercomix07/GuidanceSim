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
VT = [400*cos(gT),-400*sin(gT)];     %[m/s] Target Velocity

% MISSILE
xM = 0;
zM = 0;
RM = [xM;zM];
gM = deg2rad(30);
VM = [600*cos(gM),-600*sin(gM)];
Rlethal = 1;

%% GUIDANCE
N = 2;

%% AUTOPILOT
% 3-Loop Autopilot Structure
% Inner loops for pitch rate (q) control
% Outer loop for normal acceleration control
