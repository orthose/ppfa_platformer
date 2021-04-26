# Introduction
Projet de PFA (Programmation Fonctionnelle Avancée) L3 INFO S6 Université Paris-Saclay 2021, ayant pour but la création d'un jeu-vidéo de type plateforme.

Ce fichier tient lieu de rapport de projet. Je ne fais pas de captures
d'écran car je veux être sûr que vous irez jouer avec ;)

Si tout se passe comme prévu le jeu devrait être jouable sur mon
serveur personnel [ici](http://pyroxene.ddns.net/ppfa_platformer).

# L'équipe des étudiant(s)
* Maxime Vincent
* ~~Clément Pham Van~~

Mon coéquipier Clément Pham Van a abandonné ma cause,
me laissant en monôme ! C'est dommage car un projet
est toujours plus intéressant en équipe.

# Site du cours
[Kim Nguyen](https://www.lri.fr/~kn/ppfa_en.html)

# Copier le dépôt
`git clone https://github.com/orthose/ppfa_platformer`

# Paquets à installer
`apt-get install -y ocaml dune js-of-ocaml libjs-of-ocaml`

# Compilation du projet
`dune build`

# Nettoyage de _build
* Il est nécessaire de nettoyer avant de compiler le projet
pour prendre en compte les modifications des fichiers de niveau
dans resources/files/
`dune clean`

# Lancement du jeu
`firefox index.html`
* Attention sous firefox il faut cliquer sur le joueur pour obtenir le focus sinon il est impossible de le bouger !
* Les touches de contrôle sont les classiques Z, Q, S, D (en supposant
que vous disposez d'un clavier azerty). Pour tirer une boule de feu
lorsque vous êtes Mario Fire utilisez P.

# Comment créer un niveau ?
* Rendez-vous dans resources/levels/ puis ajoutez les fichiers
de niveaux voulus en les nommant par exemple level[0-9]+.txt.
Pour qu'ils soient pris en compte par le jeu, ajoutez-les dans
le bon ordre dans le tableau levels du fichier src/game.ml.

* Un fichier de niveau est une matrice de caractères simples,
représentant chacun un élément du jeu (plateforme, ennemi, items, etc).
Attention chaque ligne doit comporter le même nombre de caractères.
La matrice devra avoir une hauteur de 19-20 caractères. Par défaut,
le scrolling vertical est désactivé donc il ne sert à rien d'augmenter
cette hauteur (ce ne sera pas visible à l'écran).
La nomenclature est définie dans src/io/level_parser.ml.

1. - Case vide
2. * Plateforme standard
3. = Plateforme gelée glissante
4. # Plateforme champignon rebondissante
5. ~ Plateforme sable freinante
6. ^ Plateforme piquante (tue instantanément)
7. ? Bloc mystère (donne un champignon ou une fleur)
8. ! Interrupteur (pour passer au prochain niveau)
9. $ Pièce étoile (pour augmenter le score)
10. g Ennemi Goomba (déplacement horizontal)
11. b Ennemi Boo (déplacement vertical)

Afin de créer un niveau jouable, il convient de respecter
certaines bonnes pratiques de conception.
 
* En premier lieu, si vous comptez mettre des trous, pensez
à ajouter une ligne tout en bas de la matrice avec uniquement
des ^. Ainsi quand le joueur tombera il sera tué. 

* Ajoutez des murs sur les côtés du niveau pour qu'on ne puisse
pas sortir du niveau. De même si vous comptez utiliser des plateformes
rebondissantes, pour éviter que le joueur ne saute trop haut, vous pouvez
ajouter un toit.

* Les ennemis font en continu des parcours d'une certaine longueur.
Veuillez leur laissez suffisamment de place, car sinon ils se retrouveront
coincés à marcher dans un mur.

* Pour aller au prochain niveau il suffit que Mario appuie sur
un interrupteur. Veuillez donc toujours en placer au moins un 
dans votre niveau (vous pouvez le cacher si vous êtes fourbe).
Notez qu'au dernier niveau, un appui sur l'interrupteur fait
revenir au premier niveau. 

* Le joueur est toujours initialisé à la même position.
Plus précisément 2 blocs au-dessus du bas du niveau dans le coin
gauche. Il faudra donc que le niveau commence toujours à cette hauteur.

* Une fois votre niveau achevé pensez à toujours le tester. Vérifiez
en particulier que toutes les plateformes et objets sont bien accessibles.

# Features implémentées
* Déplacements du joueur haut, bas, gauche, droite. Sprites différents
en fonction de l'action en cours.

* Différents états de Mario : Small, Big, Fire. Pour devenir Big il faut
prendre un champignon et pour devenir Fire il faut prendre une fleur.
La récupération de ces items fait regagner toute la barre de vie.
Mario Fire peut lancer des boules de feu.

* Quand on touche un bloc mystère par le bas il en sort un champignon ou
une fleur selon l'état actuel du joueur.

* Les goomba peuvent être écrasés. Au bout de 3 fois ils meurent.
Les boo sont invincibles. Les ennemis se déplacement automatiquement
selon une distance prédéfinie.

* Différentes plateformes avec différents effets sur le joueur.
Chacune avec un sprite différent. 

* Une caméra pour le scrolling horizontal et vertical (par défaut le
scrolling vertical est désactivé).

* Un système de collision optimisé pour ne prendre en compte que
les interactions nécessaires dans un jeu de plateforme.

* Un compteur de score et une barre de vie qui clignote lorsque le
joueur est invincible après s'être fait touché par un ennemi.

* Un background propre à chaque niveau qui défile selon une méthode
de pavage.

* Un parser de niveau, pour rendre faciliter la création de niveau.

* Un système de destruction dynamique des objets pour éviter les
fuites mémoire.

* Récupération de pièces animées pour faire augmenter le score.

* Interrupteur pour passer au niveau suivant. Ce qui implique un
système d'enchaînement des niveaux permettant de vider la mémoire
entre deux niveaux et de repartir de zéro.

* Respawn du joueur en début de niveau en cas de mort.

# Architecture du projet

* Le jeu est basé sur le modèle ECS (Entity Component System).

* Les fichiers permettant ce créer des entités concrètes sont
tous situés dans src/game/. J'ai toujours ajouté une interface
pour chaque fichier.ml dans ce répertoire. Ce n'est pas toujours
nécessaire, mais c'est au cas où.

* Le répertoire src/io/ contient les fichiers pour la gestion
des contrôles, le parsing des niveaux et le chargement des images.

* Le répertoire src/system/ contient les différents systèmes.
Je l'ai enrichi d'un module pour la caméra, d'un système de déplacement
automatique pour l'IA et d'un système de suppression d'entité pour
éviter les fuites mémoire.

* Dans src/component/component_defs.ml vous trouverez l'ensemble des
composants. J'en ai ajouté un certain nombre comme Friction, Elasticity
qui sont utilisés par le système de collision. Life pour enregistrer
la vie restante des goomba. Ai pour sauvegarder les fonctions de déplacement
exécutées par Autopilot_S. Remove pour les fonctions de suppression exécutées
par Remove_S.

* Le composant qui est sûrement le plus important est ElementGrid qui est
créé à partir de level.ml. Il sert à enregistrer l'ensemble des objets
de la matrice représentant le niveau grâce au grand type énuméré Level.t.

* En réalité je ne stocke pas une matrice du niveau, elle sert seulement
d'intermédiaire lors du parsing. Par la suite l'ensemble des coordonnées des
objets sont stockées sous forme de listes de points grâce au type MultiPoint,
notamment pour les plateformes. On a donc pour un type de plateforme une seule
entité e à laquelle on associe une liste de points.

* Certains objets ne peuvent pas être créés ainsi, car chacun de leur représentant
sont indépendants. Ce sont des objets dynamiques qui obtiennent chacun un numéro
d'entité e différent. Ils sont susceptibles d'être supprimés dynamiquement au cours
du jeu. C'est le cas des ennemis, des pièces, du champignon, de la fleur ou
des boules de feu par exemple.

* Le fichier src/game/game_state.ml est un fichier un peu particulier pour stocker
l'état courant du jeu. C'est une méthode impérative, mais j'ai essayé de ne pas
l'utiliser dans l'excès et de préférer des méthodes fonctionnelles là où c'était
possible.

* Le fichier globals.ml contient la plupart des constantes ce qui est utile pour modeler
rapidement le jeu.

# Bogues rencontrés

* Mauvaise collision avec les blocs mystère. La Velocity était utilisée pour
l'animation. Pourtant, c'est un objet immobile. Il a fallu décomposer le type
Velocity pour 2 utilisations différentes.

* Fuites mémoire car je ne supprimais pas les entités de leur composant quand
elles disparaissaient. C'était problématique pour les boules de feu car on peut
en produire beaucoup. Le problème c'est que si l'on supprime trop tôt, au dernier
update des systèmes on se retrouve avec des MissingComponent. Donc j'ai introduit
à ce moment Remove_S.

* Les boules de feu ne s'affichaient pas ! Elles étaient masquées par le background.
J'ai dû rusé en ajoutant une liste d'entités dynamiquement créées et qui doivent
s'afficher par-dessus le background et pas après. Je l'ai fait dans Draw_system.ml.

* Les boules de feu ne disparaissaient que après avoir parcouru une certaine distance,
mais pas au bout d'un certain temps. J'ai dû utiliser un float option pour initialiser
le temps de création de la boule de feu.

* Bogue non-résolu : Je peux passer à travers les plateformes si je reste appuyé
sur les touches pour avancer.

* Bogue non-résolu : Si on ne joue pas pendant quelques temps, ou qu'on quitte le navigateur le jeu plante sans raison. On va mettre ça sur le dos de Javascript.
