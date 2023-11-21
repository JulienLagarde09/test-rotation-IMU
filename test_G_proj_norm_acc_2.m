% Projet : Simuler une rotation d'une IMU et une accélération
% de l'IMU par rapport au répère externe (lab frame).
% = Comment évoluent les mesures de l'accélération en translation
% qd une IMU (désignée par S, d'où "S frame" = SF)) subit une accélération et une rotation
% par rapport à une base laboratoire ("lab frame" = LF) ?
% Résultat visé : ajouter l'accélération du centre du répère fixé à l'IMU
% et l'accélération gravitaire et voir notamment l'évolution
% de la norme de l'accélération mesurée par l'IMU.
%% Question subsidiaire (ou pas): est ce que norme de acc vraie ("free acceleration")
%% = [norme de acc totate (mesurée)] - 9.81 ?
%% acc totate (mesurée) = accélération du centre de la base IMU + gravité,
%% définies dans LF donc on applique la rotation pour passer dans SF
%
%% la norme des différence n'est pas la différence des normes. CQFD
%
%% Petit tuto de Bruno Watier (Ensam, Prof Uni Paul Sabatier, Laboratoire LAAS eq. Gepetto, Toulouse) sur les rotations ----------------------
% "Globalement, si on savait lire une matrice de passage, on aurait pas besoin d'interpréter
% le mouvement par 3 angles (qui nous parlent plus). La matrice de passage elle est unique
% et localise le repère d'un solide dans un autre repère de manière complète. Hélas, lire
% les 9 paramètres de la matrice orthonormale, ça nous parle pas beaucoup... C'est là qu
%     ça se complique. On peut, en effet interpréter cette matrice de différentes façon.
% Par exemple en utilisant 3 angles. Ainsi, on montre que l'on peut toujours retrouver la
% position finale d'un solide en tournant d'abord d'un certain angle autour de Z puis autour
% de la transformée de Y par la première rotation (appelons le Y') et enfin par la
% transformée de X par les deux rotations précédentes (appelons le X"). On a donc 3 rotations
% successives autour d'axes mobiles (la dénomination est donc simple à comprendre) autour de ZY'X" et
% ces 3 angles sont uniques. Tu verras dans le poly que je t'envoie que, dans ces cas là, la rotation 
% est donnée par les matrices élémentaires multipliées dans l'ordre de rotation: R = RzRyRx.
% Et c'est là que tout se complique car on montre aussi que l'on peut obtenir la position finale de 
% l'objet par 3 rotations successives autour d'axes fixes. Z d'abord, puis Y (le Y d'origine - c'est plus 
% difficile à visualiser par rapport à l'objet en déplacement mais c'est une référence fixe). Et enfin
% le X d'origine. On a alors une rotation autour d'axes fixes ZYX. On montre alors ici que la matrice 
% de rotation s’obtient en multipliant les matrices élémentaires dans l'ordre inverse: R = RxRyRz
% Note que du coup cette interprétation autour d'axes fixes correspond aussi à la séquence d'axes mobiles
% XY'Z" si t'as suivi.."
%% -------------------------------------------- FIN DU TUTO ----------------------------
%
%
% méthode = convention = les angles d'Euler (Cardan en fait XYZ, et ceci
% dans la base de référence LF),
% et les représentations des rotations par les matrices de rotations correspondantes
% from textbook: un matrice de rotation = carrée, 3 x 3
% inverse R * R = 1, 
% inverse R = transpose R
% déterminant R = 1
% transformation par R (R*(vecteur)) : préserve les longueurs (norme) des
% vecteurs, et préserve les angles entre vecteurs
% 
% S mesure les accélérations dans sa base "S frame" SF :
% ASF(t) = [aSFx(t),aSFy(t), aSFz(t)]
% soit le lab fame = LF, x,y,z, z positif vers le haut
%
% on connaît l'accélération ALF(t) du CM de S dans LF :
% ALF(t) = [aLFx(t), aLFy(t), aLFz(t)]
% on connaît la rotation R(t) du solide S dans LF
% si SF et LF alignées : on connaît l'accélération gSF(t) mesurée
% par S due à la gravité dans SF qui dans ce cas = gLF(t) : (0,0,-9.81), dans LF g(t) = constant
% si S tourne dans SF les x,y,z de gSF(t) varient (pas sa norme)
% 
% on fait varier l'accélération de S viz LF :
% soit ALF(t) : aLFx(t) = sin(t), aLFy(t) = cos(t), aLFz(t) = sin(2*t)
%
% on fait varier l'orientation de S viz LF :
% càd la rotation 3D de SF par rapport à LF : R = Rz*Ry*Rx, <=> multiplication à gauche
% convention angles Euler (x y z),
% càd : alpha(t) sur x, puis beta(t) sur y, puis gamma(t) sur z
% avec les axes x y z axes de la base fixe LF
%
% NB : si on prenait les axes de la base "tournée", càd SF, (Textbook Zatsiorky par ex.)
% l'axe x est idem que base fixe, LF, puis second axe est y', càd nouveau y de SF tourné
% par la première rotation,
% puis troisième axe = z", tourné par la rotation autour de y'
% dans ce second cas : R = Rx*Ry*Rz, <=> multiplication à droite
% 
%
%% on fait varier alpha, beta, gamma, donc alpha(t), beta(t), gamma(t)
% on a donc Rx(t), Ry(t),Rz(t)
%% pour l'exemple ici choisir qqchose de raisonnable pour la rotation de S viz LF :
% first guess qqchose comme : soit alpha = acos(?), beta = atan2(?), et gamma = asin(?)
%
%% les mesures d'accélérations par S (donc dans SF) deviennent :
% ASF(t) = Rz(t)*Ry(t)*Rx(t)*ALF(t)
% gSF(t) dans SF = Rz(t)*Ry(t)*Rx(t)*gLF(t)
% mesures = ASF(t) + gSF(t)

clear all, close all

dt = 1/100;
time = 0:dt:1;

% generate time series of acceleration of S viz LF
% and of angles of orientation of SF viz LF with fixed axis
for loop = 1:length(time)
    t = time(loop);
aLFx(loop) = sin(t); aLFy(loop) = cos(t); aLFz(loop) = sin(2*t);
alpha(loop) = acos(t); beta(loop) = atan2(t,2); gamma(loop) = asin(0.3*t);
end
ALF = [aLFx; aLFy,; aLFz]';% in a single 3D vector x time values form
gLF = [0,0,-9.81]';


for i = 1:length(time)
Rx = rotx(alpha(i));
Ry = roty(beta(i));
Rz = rotz(gamma(i));
% ici je fais numériquement la * des 3 matrices (ou écrire R explicitement)
R = Rz*Ry*Rx;
gSF(:,i) = R*gLF;
ASF(:,i) = R*ALF(i,:)';
Atot(:,i) = R*gLF + R*ALF(i,:)';% matrix multiplication by column vect is distributive

end

%% est ce que norme de acc vraie = [norme de acc totate (mesurée)] - 9.81 ?
test = vecnorm(Atot)-9.81;% compute norm for each column then subtract 9.81
true_accNorm = vecnorm(ASF);
check_g_SF = vecnorm(gSF);% just check norm g

figure
subplot(211)
plot(check_g_SF),ylabel('check: norm g dans SF = 9.81')
subplot(212)
plot(true_accNorm,'k')
hold on
plot(test,'g')
grid on
legend('true norm of acc','test')
title('est ce que norme de acc vraie = [norme de acc totate (mesurée)] - 9.81 ?')

% convention: angles cardan viz fixed reference frame LF
function Rx = rotx(alpha)
Rx=[1     0           0;
 0     cos(alpha)     -sin(alpha);
 0     sin(alpha)     cos(alpha)];
end
function Ry = roty(beta)
Ry =[ cos(beta)       0       sin(beta)
 0            1       0
 -1*(sin(beta))      0       cos(beta)];
end
function Rz = rotz(gamma)
Rz =[cos(gamma)     -1*(sin(gamma))     0
 sin(gamma)     cos(gamma)       0
 0           0             1];
end
