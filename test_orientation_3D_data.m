

%% Orientation des capteurs depuis MOCAP
% code pour tester et visualiser la méthode
% on définit une base ortho 3D X,Y,Z sur une surface portant les points
% P1,2,3
% puis on calcule l'orientation de cette surface par rapport à la base de
% départ avec des angles d'Euler XYZ
% une boucle pour changer les positions des points de la surface

clear all
close all
% 
% % load 3 points coordinates
% load('C:\Users\LAGARDE\Dropbox\Mon PC (STAR60RECH)\Documents\Park_2020\donnees_mouvements_enzo_Park\process_data_Enzo\ang_velocity\P1_angvelo.mat');
% load('C:\Users\LAGARDE\Dropbox\Mon PC (STAR60RECH)\Documents\Park_2020\donnees_mouvements_enzo_Park\process_data_Enzo\ang_velocity\P2_angvelo.mat')
% load('C:\Users\LAGARDE\Dropbox\Mon PC (STAR60RECH)\Documents\Park_2020\donnees_mouvements_enzo_Park\process_data_Enzo\ang_velocity\P3_angvelo.mat')

% Rename to avoid overriding variables with same names, scale in meters
P11 = P1./1000;
P22 = P2./1000;
P33 = P3./1000;

% mettre le graphique à l'échelle selon distance marqueurs au centre de lab
% frame
scalepos = norm(P11(:,1));
scalepos = scalepos/5;

clear P1 P2 P3

deb = 1;
fin = 10;
for anim = deb:fin
P1 = P11(:,anim);
P2 = P22(:,anim);
P3 = P33(:,anim);

% translation sur axe Y  pour rapprocher
% la surface du centre lab frame (-0.3 m)
xSURF = [P1(1) P2(1) P3(1)];
ySURF = [P1(2)-0.3 P2(2)-0.3 P3(2)-0.3];
zSURF = [P1(3) P2(3) P3(3)];

xvSURF = linspace(min(xSURF), max(xSURF), 20); 
yvSURF = linspace(min(ySURF), max(ySURF), 20);
[XSURF,YSURF] = meshgrid(xvSURF, yvSURF);
ZSURF = griddata(xSURF,ySURF,zSURF,XSURF,YSURF);

% inputs: 3 points (x,y,z) on a plane (coplanar points P1,2,3 in clockwise
% order looking from the top
% outputs: orientation angles, Euler, here using roll-pitch-yaw in the order XYZ

x = (P1+P2)/2 -P3; % x axis of the body-fixed frame, example vector starting from P3 passing
% through the midpoint of the segment joining P2 and P3
v1 = P2-P1; v2 = P3-P1;
z = cross(v1,v2); % cross product to get vertical axis z perpendicular to the plane
z = z/norm(z);% normalize to get unit vector
x = x/ norm(x);% idem
y = cross(z,x);

X = [x(1); x(2); x(3)];
Y = [y(1); y(2); y(3)];
Z = [z(1); z(2); z(3)];

% angles first method
    alpha= atan2(-Z(2), Z(3));
    beta = asin(Z(1));
    gamma = atan2(-Y(1),X(1));


center = [0 0 0];

figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);

X = X./6;
Y = Y./6;
Z = Z./6;
% plot the surface
surf(XSURF, YSURF, ZSURF);hold on
% % plot the object frame
plot3(X(1),X(2),X(3),'o','MarkerFaceColor','r'),hold on
plot3(Y(1),Y(2),Y(3),'o','MarkerFaceColor','k'),hold on
plot3(Z(1),Z(2),Z(3),'o','MarkerFaceColor','b'),hold on
% plot the 3 markers
% translation sur axe Y  pour rapprocher
% la surface du centre lab frame (-0.3 m)
plot3(P1(1),P1(2)-0.3,P1(3),'*'),hold on
plot3(P2(1),P2(2)-0.3,P2(3),'*'),hold on
plot3(P3(1),P3(2)-0.3,P3(3),'*'), hold on
% plot du repère labo
line([center(1),scalepos],[center(2),0],[center(3),0],'LineStyle',':','LineWidth',3,'Color','g'),hold on
line([center(1),0],[center(2),scalepos],[center(3),0],'LineStyle',':','LineWidth',3,'Color','c'),hold on
line([center(1),0],[center(2),0],[center(3),scalepos],'LineStyle',':','LineWidth',3,'Color','m'),hold on
% plot du repère "IMU"/ plaque
line([center(1),X(1)],[center(2),X(2)],[center(3),X(3)],'LineWidth',3,'Color','r'),hold on
line([center(1),Y(1)],[center(2),Y(2)],[center(3),Y(3)],'LineWidth',3,'Color','k'),hold on
line([center(1),Z(1)],[center(2),Z(2)],[center(3),Z(3)],'LineWidth',3,'Color','b'),hold on
grid on
axis square, axis equal
% xlim([-6 6])
% ylim([-6 6])
% zlim([-6 6])
xlabel('X'), ylabel('Y'), zlabel('Z')
view(axes1,[46.9719386119717 26.9882926829268]);
title(strcat('alpha =',num2str(alpha),', ', 'beta =',num2str(beta),', ', 'gamma =', num2str(gamma')))

pause
close
end % anim