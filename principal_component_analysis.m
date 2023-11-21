%% Matlab script for explaining how to calculate the PCA
%% Written by Philippe Lucidarme
%% http://www.lucidarme.me
close all;clear all;clc;


%% Parameters tuning

% Number of sample 
N=1000;

% Standard deviation along X and Y
StdX=3;
StdY=1;

% Offset along X and Y
offsetX = 8;
offsetY = 2;

% Rotation of sample (correlation)
alpha=pi/3;


%% Create random sample
X = randn(N,2);
X = X*[StdX,0;0,StdY]';
X = X*[cos(alpha) , -sin(alpha) ; sin(alpha) , cos(alpha) ]';
X = X+[offsetX offsetY];

%% Plot set of points
plot (X(:,1),X(:,2),'.b');
grid on; hold on;
axis square equal;



%% Compute center
Xc = mean(X)'


%% Compute covariance 
Sigma=cov(X-Xc')


%% Perform singular value decomposition
[U,S,D]=svd(Sigma)


%% Display results (an ellipse with 3x standard deviation)
%% The ellipse must contain 99% of the samples
a=[0:0.1:2*pi];
Xu=[cos(a);sin(a)];
Xu= (U*sqrt(S)) * Xu;
patch (Xc(1)+3*Xu(1,:),Xc(2)+3*Xu(2,:),'g','FaceAlpha',0.2);

% Compute and display Standard deviations:
std = sqrt(S)

% Compute and display angle
alpha = atan2(U(1,2), U(1,1))


%% Display PCA vectors
u=U*sqrt(S)*[1 ; 0]
v=U*sqrt(S)*[0 ; 1]
drawArrow = @(P1,P2,c) quiver( P1(1),P1(2),P2(1)-P1(1),P2(2)-P1(2),0, c, 'LineWidth', 4 );
drawArrow(Xc, Xc+u, 'r');
drawArrow(Xc, Xc+v, 'g');



