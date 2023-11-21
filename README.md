# test-rotation-IMU

% Orientation des capteurs depuis MOCAP
code pour tester et visualiser la méthode
on définit une base ortho 3D X,Y,Z sur une surface portant les points
P1,2,3
puis on calcule l'orientation de cette surface par rapport à la base de
départ avec des angles d'Euler XYZ
une boucle pour changer les positions des points de la surface


Projet : Simuler une rotation d'une IMU et une accélération
de l'IMU par rapport au répère externe (lab frame).
= Comment évoluent les mesures de l'accélération en translation
qd une IMU (désignée par S, d'où "S frame" = SF)) subit une accélération et une rotation
par rapport à une base laboratoire ("lab frame" = LF) ?
Résultat visé : ajouter l'accélération du centre du répère fixé à l'IMU
et l'accélération gravitaire et voir notamment l'évolution
de la norme de l'accélération mesurée par l'IMU.
% Question subsidiaire (ou pas): est ce que norme de acc vraie ("free acceleration")
% = [norme de acc totate (mesurée)] - 9.81 ?
% acc totate (mesurée) = accélération du centre de la base IMU + gravité,
% définies dans LF donc on applique la rotation pour passer dans SF

% la norme des différence n'est pas la différence des normes. CQFD

% Petit tuto de Bruno Watier (Ensam, Prof Uni Paul Sabatier, Laboratoire LAAS eq. Gepetto, Toulouse) sur les rotations ----------------------
"Globalement, si on savait lire une matrice de passage, on aurait pas besoin d'interpréter
le mouvement par 3 angles (qui nous parlent plus). La matrice de passage elle est unique
et localise le repère d'un solide dans un autre repère de manière complète. Hélas, lire
les 9 paramètres de la matrice orthonormale, ça nous parle pas beaucoup... C'est là qu
    ça se complique. On peut, en effet interpréter cette matrice de différentes façon.
Par exemple en utilisant 3 angles. Ainsi, on montre que l'on peut toujours retrouver la
position finale d'un solide en tournant d'abord d'un certain angle autour de Z puis autour
de la transformée de Y par la première rotation (appelons le Y') et enfin par la
transformée de X par les deux rotations précédentes (appelons le X"). On a donc 3 rotations
successives autour d'axes mobiles (la dénomination est donc simple à comprendre) autour de ZY'X" et
ces 3 angles sont uniques. Tu verras dans le poly que je t'envoie que, dans ces cas là, la rotation 
est donnée par les matrices élémentaires multipliées dans l'ordre de rotation: R = RzRyRx.
Et c'est là que tout se complique car on montre aussi que l'on peut obtenir la position finale de 
l'objet par 3 rotations successives autour d'axes fixes. Z d'abord, puis Y (le Y d'origine - c'est plus 
difficile à visualiser par rapport à l'objet en déplacement mais c'est une référence fixe). Et enfin
le X d'origine. On a alors une rotation autour d'axes fixes ZYX. On montre alors ici que la matrice 
de rotation s’obtient en multipliant les matrices élémentaires dans l'ordre inverse: R = RxRyRz
Note que du coup cette interprétation autour d'axes fixes correspond aussi à la séquence d'axes mobiles
XY'Z" si t'as suivi.."
% -------------------------------------------- FIN DU TUTO ----------------------------


méthode = convention = les angles d'Euler (Cardan en fait XYZ, et ceci
dans la base de référence LF),
et les représentations des rotations par les matrices de rotations correspondantes
from textbook: un matrice de rotation = carrée, 3 x 3
inverse R * R = 1, 
inverse R = transpose R
déterminant R = 1
transformation par R (R*(vecteur)) : préserve les longueurs (norme) des
vecteurs, et préserve les angles entre vecteurs

S mesure les accélérations dans sa base "S frame" SF :
ASF(t) = [aSFx(t),aSFy(t), aSFz(t)]
soit le lab fame = LF, x,y,z, z positif vers le haut

on connaît l'accélération ALF(t) du CM de S dans LF :
ALF(t) = [aLFx(t), aLFy(t), aLFz(t)]
on connaît la rotation R(t) du solide S dans LF
si SF et LF alignées : on connaît l'accélération gSF(t) mesurée
par S due à la gravité dans SF qui dans ce cas = gLF(t) : (0,0,-9.81), dans LF g(t) = constant
si S tourne dans SF les x,y,z de gSF(t) varient (pas sa norme)

on fait varier l'accélération de S viz LF :
soit ALF(t) : aLFx(t) = sin(t), aLFy(t) = cos(t), aLFz(t) = sin(2*t)

on fait varier l'orientation de S viz LF :
càd la rotation 3D de SF par rapport à LF : R = Rz*Ry*Rx, <=> multiplication à gauche
convention angles Euler (x y z),
càd : alpha(t) sur x, puis beta(t) sur y, puis gamma(t) sur z
avec les axes x y z axes de la base fixe LF

NB : si on prenait les axes de la base "tournée", càd SF, (Textbook Zatsiorky par ex.)
l'axe x est idem que base fixe, LF, puis second axe est y', càd nouveau y de SF tourné
par la première rotation,
puis troisième axe = z", tourné par la rotation autour de y'
dans ce second cas : R = Rx*Ry*Rz, <=> multiplication à droite


% on fait varier alpha, beta, gamma, donc alpha(t), beta(t), gamma(t)
on a donc Rx(t), Ry(t),Rz(t)
% pour l'exemple ici choisir qqchose de raisonnable pour la rotation de S viz LF :
first guess qqchose comme : soit alpha = acos(?), beta = atan2(?), et gamma = asin(?)

% les mesures d'accélérations par S (donc dans SF) deviennent :
ASF(t) = Rz(t)*Ry(t)*Rx(t)*ALF(t)
gSF(t) dans SF = Rz(t)*Ry(t)*Rx(t)*gLF(t)
mesures = ASF(t) + gSF(t)
