function drawMissile(uu)
    % process inputs to function
    pn       = uu(1);       % inertial North position     
    pe       = uu(2);       % inertial East position
    pd       = uu(3);       % inertial Down position                
    phi      = uu(4);       % roll angle         
    theta    = uu(5);       % pitch angle     
    psi      = uu(6);       % yaw angle      
    t        = uu(7);      % time

    % define persistent variables 
    persistent uav_handle;
    persistent Vertices
    persistent Faces
    persistent facecolors
    
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1), clf
        [Vertices, Faces, facecolors] = defineACBody;
        uav_handle = drawACBody(Vertices,Faces,facecolors,...
                                               pn,pe,pd,phi,theta,psi,...
                                               [],'normal');
        title('AC')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the view angle for figure
        axis([-10,10,-10,10,-10,10]);
        grid on
        hold on
        
    % at every other time step, redraw base and rod
    else 
        drawACBody(Vertices,Faces,facecolors,...
                           pn,pe,pd,phi,theta,psi,...
                           uav_handle);
    end
end

  
%=======================================================================
% drawAC
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawACBody(V,F,patchcolors,...
                                     pn,pe,pd,phi,theta,psi,...
                                     handle,mode)
  V = rotate(V', phi, theta, psi)';  % rotate AC
  V = translate(V', pn, pe, pd)';    % translate AC
  %V = rotate(V', phi, theta, psi)';  % rotate AC
  
  
  % transform vertices from NED to XYZ (for matlab rendering)
  % Rotation about x axis by -180 deg then rotation about z' by -90deg
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  V = V*R;
  
  if isempty(handle)
  handle = patch('Vertices', V, 'Faces', F,...
                 'FaceVertexCData',patchcolors,...
                 'FaceColor','flat',...
                 'EraseMode', mode);
  else
    set(handle,'Vertices',V,'Faces',F);
    xlim(handle.Parent, [pe-10,pe+10]);
    ylim(handle.Parent, [pn-10,pn+10]);
    zlim(handle.Parent, [-pd-10,-pd+10]);
    drawnow
  end
end

%%%%%%%%%%%%%%%%%%%%%%%
function XYZ=rotate(XYZ,phi,theta,psi)
  % define rotation matrix
  R_roll = [...
          1, 0, 0;...
          0, cos(phi), -sin(phi);...
          0, sin(phi), cos(phi)];
  R_pitch = [...
          cos(theta), 0, sin(theta);...
          0, 1, 0;...
          -sin(theta), 0, cos(theta)];
  R_yaw = [...
          cos(psi), -sin(psi), 0;...
          sin(psi), cos(psi), 0;...
          0, 0, 1];
  R = R_roll*R_pitch*R_yaw;
  % rotate vertices
  XYZ = R*XYZ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function XYZ = translate(XYZ,pn,pe,pd)
  XYZ = XYZ + repmat([pn;pe;pd],1,size(XYZ,2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define AC vertices and faces
function [V,F,colors] = defineACBody()
    % Define the vertices (physical location of vertices)

    fusel1 = 2;
    fusel2 = 0.5;
    fusel3 = 8;
    fusel_w = 2;
    wingspan = 14;
    chord = 2;
    htail_span = 6;
    htail_chord = 1;
    vtail_span = 4;
    vtail_chord = 1.5;
    V = [...
        fusel1     0    0;... % point 1
        fusel2   fusel_w/2   -fusel_w/2;... % point 2
        fusel2  -fusel_w/2   -fusel_w/2;... % point 3
        fusel2  -fusel_w/2    fusel_w/2;... % point 4
        fusel2   fusel_w/2    fusel_w/2;... % point 5
        -fusel3    0                  0;... % point 6
        -0.5,           wingspan/2,   0;...% 7
        -0.5,           -wingspan/2,  0;...% 8
        -(0.5+chord),   -wingspan/2,  0;...% 9
        -(0.5+chord),   wingspan/2,   0;...% 10
       -(fusel3 - htail_chord),  vtail_span/2, 0;...%11
       -(fusel3 - htail_chord), -vtail_span/2, 0;...%12
       -fusel3,                 -vtail_span/2, 0;...%13
       -fusel3,                  vtail_span/2, 0;...%14
       -(fusel3 - vtail_chord), 0,           0;...%15,
       -fusel3,                 0, -vtail_span;...%16
    ];

    % AC = stlread("pioneer.stl");
    % V = -AC.Points;
    % F = AC.ConnectivityList;
    % colors = [1,1,1];

    % define faces as a list of vertices numbered above
    F = [...
        1, 2, 3, 1;...  % front
        1, 3, 4, 1;...  % back
        1, 4, 5, 1;...
        1, 2, 5, 1;...
        6, 2, 3, 6;...
        6, 3, 4, 6;...
        6, 4, 5, 6;...
        6, 5, 2, 6;... 
        7, 8, 9, 10;...% Wing
        11, 12, 13, 14;...% Horizontal Tail
        15, 16, 6, 15;...% Vertical Tail
        ];

    colors = ones(length(F),3);
end
  