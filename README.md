# Introduction
Projet de PFA (Programmation Fonctionnelle Avancée) L3 INFO S6 Université Paris-Saclay 2021, ayant pour but la création d'un jeu-vidéo de type plateforme.

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
resources/files/level*.txt
`dune clean`

# Lancement du jeu
`firefox index.html`
* Attention sous firefox il faut cliquer sur le joueur pour obtenir le focus sinon il est impossible de le bouger !
* Les touches de contrôle sont les classiques Z, Q, S, D (en supposant
que vous disposez d'un clavier azerty). Pour tirer une boule de feu
lorsque vous êtes Mario Fire utilisez P.

# Architecture du projet
* Le fichier TODO.md contient toutes les tâches en cours
et effectuées. Cela donne un aperçu de l'avancement du projet.
