
% load data P1, 2, 3

A = [P1;P2;P3]; 
B = A./1000;% en mètres
dt = 1/100;

[norm_ang_vel,alpha,beta,gamma] = myangvelo2(A,dt);
[norm_ang_vel2,alpha2,beta2,gamma2] = myangvelo2(B,dt);

time = (1:length(norm_angvel))*dt;

scrsz = get(0,'ScreenSize');
figure('Position',[10 (scrsz(4)/6) scrsz(3)/1.2 scrsz(4)/1.5])
subplot(2,1,1)
plot(time,norm_angvel,'Linewidth',1)
grid on
xlabel('time (sec.)','FontSize',20,'FontName','Bell MT')
ylabel('norm angular velocity (rad/sec.)','FontSize',15,'FontName','Bell MT')
subplot(2,1,2)
plot(time,alpha,'m')
hold on
plot(time,beta,'k')
hold on
plot(time,gamma,'g')
grid on
xlabel('time (sec.)','FontSize',15,'FontName','Bell MT')
ylabel('Euler angles (rad.)','FontSize',20,'FontName','Bell MT')