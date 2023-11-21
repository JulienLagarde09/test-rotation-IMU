function [norm_ang_vel,alpha,beta,gamma] = myangvelo2(A,dt)

% inputs:
% dt = 1/sampling frequency in seconds
% inputs: 3 points (x,y,z) on a plane (coplanar points P1,2,3 in clockwise
% order looking from the top
% ---------------------------------------------------------------------
% A is the matrix with coordinates for 3 points P1, P2, P3 in mocap lab
% frame
% A = 9 rows X as much columns as time points
% Rows: xP1, yP1, zP1, then xP2, yP2, zP2, then xP3, yP3, zP3
% Example with 1000 time points samples: A = randn(9,1000); dt = 1/100;
% Initial example of inputs (just one time sample):
% P1 = [1 2 0];
% P2 = [3 4 0];
% P3 = [2 5 0];
% ---------------------------------------------------------------------
% Outputs:
% vector of the time series of (Euclidean) norm of angular velocity of the object frame relative to the lab frame
% ---------------------------------------------------------------------
%
% on définit une base ortho 3D X,Y,Z sur une surface portant les points
% P1,2,3
% puis on calcule l'orientation de cette surface par rapport à la base de
% départ avec des angles d'Euler XYZ
% on utilise les fonctions quaternion de la toolbox matlab robotics pour
% calculer la vitesse angulaire
% Exemple Matlab:
% eulerAngles = [(0:10:90).',zeros(numel(0:10:90),2)]; % this shows it MUST BE time samples X 3 angles (angles in columns)
% q = quaternion(eulerAngles,'eulerd','ZYX','frame');
% dt = 1;
% av = angvel(q,dt,'frame') % units in rad/s
%
% test inputs 
% A = randn(9,1000); dt = 1/100;norm_ang_vel = myangvelo2(A,dt);

P1 = A([1 2 3],:); % axes x y z du premier marqueur de la plaquette
P2 = A([4 5 6],:); % idem avec deuxième marqueur
P3 = A([7 8 9],:); % idem troisième marqueur
    
% build the basis on the object(surface)
x = (P1+P2)/2 -P3; % x axis of the body-fixed frame, example vector starting from P3 passing
% through the midpoint of the segment joining P2 and P3
v1 = P2-P1; v2 = P3-P1;
z = cross(v1,v2); % cross product to get vertical axis z perpendicular to the plane
z = z/norm(z);% normalize to get unit vector
x = x/ norm(x);% idem
y = cross(z,x);

% computes Euler angles in XYZ sequence
    alpha= atan2(-z(2,:), z(3,:));
    beta = asin(z(1,:));
    gamma = atan2(-y(1,:),x(1,:));
    
% Other method using R rotation matrix and
% R = [x(1),y(1),z(1); x(2),y(2),z(2); x(3),y(3),z(3)];
%     eulerAngles = rotm2eul(R);

% Euler angles: alpha, beta, gamma in columns
eulerAngles = [alpha; beta; gamma];
eulerAngles = eulerAngles';% angles in columns
% uses quaternion to get angular velocity
q = quaternion(eulerAngles,'euler','XYZ','frame');

angvel2 = angvel(q,dt,'frame');% get the angular velocity for each time (date) with the loop

norm_ang_vel = vecnorm(angvel2');% computes the euclidian norm at each time point, same length as myangvel
norm_ang_vel(1) = norm_ang_vel(2); % corrects for the first value


