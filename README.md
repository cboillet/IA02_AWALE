IA02_AWALE
==========

Besoins :
/*******STEP 1********/
- liste pour modéliser l'état du jeu : ok liste([4,4,4,4,4]): ok
- prédicat pour afficher la liste: afficher(L): ok
- prédicat pour tester le nombre de points de chacun des joueurs : ok
- prédicat qui distribue les graines d'une case dans les cases suivantes jouer(X,Y) //X joue la case Y
- prédicat qui récupère les graines de la case et les mets dans la pôche du joueur recuperer(X,Y) //X recupere les graines de la case Y

/********STEP 2 pour le 04/06 => DONE**********/
- finir affichage Cam
- ramasser Jean
- test famine (test si camp sans graines) Erwan 
- input Jean


Jouer : 
- distribuer
- tester famine : si oui revenir à distribuer pour choisir un autre coup. S'il est impossible de choisir un autre coup, fin de la partie et le joueur qui devait jouer ramasse toutes les graines restantes.
- si non ramasser
- tester famine : si oui on ne ramasse pas mais on garde la distribution.


Stratégie gagnante:
- a chercher sur internet
- prédicat qui teste les différentes possibilités de jeu (quelle case tirer) et valide celle qui répond aux mieux aux stratégie gagnantes.


Fin :
- déclenchement fin du jeu
- puis gagne celui qui a le plus de graines et au moins 25 graines


Aides :
- changer de répertoire : change_directory('Z:/public_html/TP1').
- executer programme : consult('age').

/******STEP 3*******/
- variable nbgraines par joueur //Camille
- prédicats qui est le gagnant //Camille
- prédicats detecter la fin de partie (famine en continue chez l'autre joueur),ramasse graines si fin de partie et test qui est le gagant //Camille

- predicats teste tous les coups regarde si ca créer une famine et renvoi la liste des cases qui peuvent être jouées //Erwan
-  ramasser: tester si ramasserinternal fait une famine //Jean

