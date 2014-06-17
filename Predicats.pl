/** Base de données **/
etat_initial([4,4,4,4,4,4,4,4,4,4,4,4]).

joueur_adverse(joueur1,JA) :- JA = joueur2.
joueur_adverse(joueur2,JA) :- JA = joueur1.

tour(joueur1).

grainesMinVictoire(25). % Le nombre minimum de graines à avoir pour gagne

/** Fin base de données **/


/** Jeu **/
% Predicat lancerJeu(IA1,IA2) : lance le jeu.
% IA = type du joueur1 
% IA1 et IA02 définissent si le joueur est une IA ou un humain. Ce sont le numéro du type de l'IA ou 0 si c'est un joueur humain.
lancerJeu(IA1,IA2) :- tour(J), etat_initial(L), jeu(J,L,0,0,IA1,IA2).

% Predicat jeu(J,L,NGJ1,NGJ2,IA1,IA2) : le jeu.
% J = joueur en cours, L = état du jeu, NGJ1 = graines de J1, NGJ2 = graines de J2, IA1 = le type du joueur1, IA2 = le type du joueur2.
jeu(joueur1,L,NGJ1,NGJ2,IA1,IA2) :- afficherTour(joueur1), afficherNbGraines(NGJ1,NGJ2), afficher(L), tourDeJeu(joueur1,L,LA,NGJ1,NGJ1A,CJ,IA1), CJ = 1, jeu(joueur2,LA,NGJ1A,NGJ2,IA1,IA2), !.
jeu(joueur2,L,NGJ1,NGJ2,IA1,IA2) :- afficherTour(joueur2), afficherNbGraines(NGJ1,NGJ2), afficher(L), tourDeJeu(joueur2,L,LA,NGJ2,NGJ2A,CJ,IA2), CJ = 1, jeu(joueur1,LA,NGJ1,NGJ2A,IA1,IA2), !.
jeu(_,L,NGJ1,NGJ2,_,_) :- finPartie(L,NGJ1,NGJ2).

% Predicat tourDeJeu(J,L,LA,NGJ,NGJA,CJ,IA) : un tour de jeu du joueur J.
% L = état de départ, LA = état d'arrivée, NGJ = graines du joueur pour L, NGJA = graines du joueur pour LA, CJ = bool continuer de jouer, IA = le type du joueur.
tourDeJeu(J,L,LA,NGJ,NGJA,CJ,0) :- tourDeJeuHumain(J,L,LA,NGJ,NGJA,CJ).
tourDeJeu(J,L,LA,NGJ,NGJA,CJ,1) :- write('L''IA joue \n'), tourDeJeuIA1(J,L,LA,NGJ,NGJA,CJ).

% Predicat tourDeJeuHumain(J,L,LA,NGJ,NGJA,CJ) : un tour de Jeu du joueur J;=, humain.
% L = état de départ, LA = état d'arrivée, NGJ = graines du joueur pour L, NGJA = graines du joueur pour LA, CJ = bool continuer de jouer.
tourDeJeuHumain(J,L,_,_,_,0) :- mouvementsPossibles(J,L,LCases), LCases == [], !.
tourDeJeuHumain(J,L,LA,NGJ,NGJA,1) :- mouvementsPossibles(J,L,LCases), afficherIndiceCases(LCases), askValidCase(J,C,L), member(C,LCases), jouer(J,C,L,LA,NGJ,NGJA), !.
tourDeJeuHumain(J,L,LA,NGJ,NGJA,1) :- write("Ce coup est impossible, il affame l'adversaire.\n"), tourDeJeuHumain(J,L,LA,NGJ,NGJA,1).

% Prédicat jouer(J,C,L,LA,NGJ,NGJA) : le joueur J joue la case C.
jouer(J,C,L,LA,NGJ,NGJA) :- mouvementsPossibles(J,C,L,LCases), member(C,LCases), nbGraines(C,L,G), setNbGraines(C,L,0,L2), distribuer(G,C,C,L2,LA1,CA), ramasser(J,CA,LA1,LA,NGR), NGJA is NGJ+NGR, !.

% Prédicat finPartie(L,NGJ1,NGJ2) : le joueur J ramasse les derniers jetons, et le jeu affiche le vainqueur.
finPartie(L,NGJ1,NGJ2) :- diviser(L,L1,L2,12), sum_list(L2,NG1), sum_list(L1,NG2), N1 is NGJ1+NG1, N2 is NGJ2+NG2, afficherNbGraines(N1,N2), gagne(N1,N2).

/** Fin jeu **/


/** Les IA **/
% Predicat tourDeJeuIA1(J,L,LA,NGJ,NGJA,CJ) : un tour de jeu du joueur J, IA.
% L = état de départ, LA = état d'arrivée, NGJ = graines du joueur pour L, NGJA = graines du joueur pour LA, CJ = bool continuer de jouer.
tourDeJeuIA1(J,L,_,_,_,0) :- mouvementsPossibles(J,L,LCases), LCases == [], !.
tourDeJeuIA1(J,L,LA,NGJ,NGJA,1) :- mouvementsPossibles(J,L,[T|_]), jouer(J,T,L,LA,NGJ,NGJA), sleep(1), write('Case distribuee : '), write(T), nl.

/** Fin IA **/


/** Choix joueur de la case à distribuer **/
% Predicat askValidCase(J,C,L) : demande quelle case distribuer, jusqu'à ce qu'elle soit valide, et la renvoie.
% J = joueur en cours, C = case, L = état du jeu.
askValidCase(J,C,L) :- askNombre(C), caseDuCamp(J,C), nbGraines(C,L,G), G > 0, !.
askValidCase(J,C,L) :- write('Cette case n''est pas valide car elle n''est pas dans votre camp ou ne contient pas de graines. Merci de fournir une case valide.\n'), askValidCase(J,C,L).

% Predicat askNombre(C) : demande d'entrer un nombre, et le renvoie.
% C = le nombre.
askNombreb(C) :- write('Vous devez entrer un nombre\n'), current_input(STDIN), flush_instream(STDIN), askNombre(C).
askNombre(C) :- catch(askCase(C), _, askNombreb(C)).

% Predicat askCase(C) : demande quelle case distribuer et la renvoie.
% C = la case.
askCase(C) :- current_input(STDIN), write('Quelle case souhaitez-vous distribuer?\n'), read_number(STDIN,C).

% Configuration.
flush_instream(STREAM) :- get_char(STREAM,'\n'), !.
flush_instream(STREAM) :- get_char(STREAM,_), flush_instream(STREAM).

/** Fin choix joueur de la case à distribuer **/


/** Prédicats d'affichage **/
% Predicat afficherTour(J) : affiche le joueur dont c'est le tour.
% J = le joueur.
afficherTour(J) :- nl, write('Tour de '), write(J), nl.

% Predicat afficherNbGraines(NGJ1,NGJ2) : affiche le nombre de graines possedées par les joueurs.
% NGJ1 = graines du joueur1, NGJ2 = graines du joueur2.
afficherNbGraines(NGJ1,NGJ2) :- afficherNbGrainesJ(joueur1,NGJ1), afficherNbGrainesJ(joueur2,NGJ2).
afficherNbGrainesJ(J,NGJ) :- write(J), write(' possede '), write(NGJ), write(' graines.'), nl.

% Predicat afficherIndiceCases(LCases) : affiche un message d'indice des mouvements possibles
% LCases = les mouvements possibles.
afficherIndiceCases(LCases) :- write('Indice : vous pouvez jouer les cases : '), afficherListe(LCases).
afficherListe([T]) :- write(T), nl.
afficherListe([T|Q]) :- write(T), write(','), afficherListe(Q).

% Predicat gagne(NGJ1,NGJ1) : affiche le gagnant du jeu.
% NGJ1 = graines du joueur1, NGJ2 = graines du joueur2.
gagne(NGJ1,NGJ2) :- NGJ1 > NGJ2, grainesMinVictoire(GM), NGJ1 >= GM, !, write('Le joueur 1 gagne').
gagne(_,NGJ2) :- grainesMinVictoire(GM), NGJ2 >= GM, !, write('Le joueur 2 gagne').
gagne(_,_) :- write('Aucun gagnant, egalite des joueurs').


% Predicat afficher(L) : affiche l'état du jeu.
afficher(L) :- diviser(L,L1,L2,1), afficher2(L2), nl, afficher1(L1), nl, nl.

% Predicat afficher(L) : affiche la liste L dans l'ordre.
afficher1([]) :- write('|').
afficher1([T|Q]) :- write('|'), affiche_espace(T), write(T), afficher1(Q).

% Predicat afficher2(L) : affiche la liste L dans l'ordre inverse.
afficher2([]) :- write('|').
afficher2([T|Q]) :- afficher2(Q), affiche_espace(T), write(T), write('|').

% Predicat affiche_espace(NB) : affiche un espace si NB<10.
affiche_espace(NB) :- NB<10, write(' '),!.
affiche_espace(_).

% Predicat diviser(L,L1,L2,C) : divise la liste L en deux sous-listes L1 et L2.
diviser([],[],[],_) :- !.
diviser([T|Q],[T|L1],L2,C) :- C<7, !, C2 is C+1, diviser(Q,L1,L2,C2).
diviser([T|Q],L1,[T|L2],C) :- C2 is C+1 ,diviser(Q,L1,L2,C2).

/** Prédicats d'affichage **/


/** Prédicats de manipulation **/
% Prédicat nbGraines(C,L,G) : donne le nombre G de graines de la case C de l'état L.
nbGraines(1,[T|_],T) :- !.
nbGraines(C,[_|Q],G) :- C1 is C-1, nbGraines(C1,Q,G).

% Prédicat setNbGraines(C,L,G,LA) : affecte un nombre de graines et retourne le nouvel état de jeu LA.
setNbGraines(1,[_|Q],G,[G|Q]) :- !.
setNbGraines(C,[T|Q],G,[T|R]) :- C1 is C-1, setNbGraines(C1,Q,G,R).

% Prédicat caseDuCamp(J,C) : teste si le joueur peut jouer la case C.
caseDuCamp(joueur1,C) :- C<7, C>0.
caseDuCamp(joueur2,C) :- C>6, C<13.

% Prédicat famine(J,L) : teste si le joueur J est en famine, c-à-d. s'il n'a plus de graines dans son camp.
famine(J,L) :- famine(J,1,L).
famine(_,_,[]) :- !.
famine(J,C,[T|Q]) :- caseDuCamp(J,C), !, T =:= 0, C1 is C+1, famine(J,C1,Q).
famine(J,C,[_|Q]) :- C1 is C+1, famine(J,C1,Q).

% Prédicat mouvementsPossibles(J,L,LCases) : renvoie la liste des cases possibles pour le joueur, c-à-d. celles qui appartiennent au joueur, non vides, et n'entrainant pas de famine chez l'autre joueur
mouvementsPossibles(J,L,LCases) :- length(L,C), mouvementsPossibles(J,C,L,LCases).
mouvementsPossibles(_,0,_,[]) :- !.
mouvementsPossibles(J,C,L,LCases) :- caseDuCamp(J,C), nbGraines(C,L,G), G > 0, joueur_adverse(J,JA), distribuer(G,C,C,L,LA,_), \+famine(JA,LA), !, C2 is C-1, mouvementsPossibles(J,C2,L,LCases1), LCases = [C|LCases1]. 
mouvementsPossibles(J,C,L,LCases) :- C1 is C-1, mouvementsPossibles(J,C1,L,LCases).

% Prédicat distribuer(GD,CD,C,L,LA,CA) : distribue le nombre GD de graines de la case CD à la case d'arrivée CA.77
% GD = nombre de graines à distribuer, CD = la case du début de distribution, C = la prochaine case à distribuer, L = état de départ, LA = état après distribution
distribuer(GD,CD,CD,L,LA,CA) :- C1 is CD+1, distribuer(GD,CD,C1,L,LA,CA), !.
distribuer(0,_,C,L,L,CA) :- CA is C-1, !.
distribuer(GD,CD,13,L,LA,CA) :- distribuer(GD,CD,1,L,LA,CA), !.
distribuer(GD,CD,C,L,LA,CA) :- C1 is C+1, GD1 is GD-1, distribuer(GD1,CD,C1,L,L1,CA), nbGraines(C,L1,G), G1 is G+1, setNbGraines(C,L1,G1,LA).

% Predicat ramasser(J,C,L,LA,G): ramasse les graines. 
% L = liste de graines, C = case où l'on arrive, LA, liste retournée une fois ramassée, NG nb de graines ramassée en s'assurant qu'il n'y a pas famine.
ramasser(J,C,L,LA,G):-ramasser_internal(J,C,L,LA,G), joueur_adverse(J,JA),\+famine(JA,LA),!.
ramasser(J,C,L,L,0):-ramasser_internal(J,C,L,_,_).

% Predicat ramasser_internal(L,C,J,LA,G) : ramasse les graines.
% L = état de départ, C = case actuelle de distribution, LA = état après ramasser, NG = nb de graines ramassée.
ramasser_internal(J,C,L,L,0) :- caseDuCamp(J,C), !. 
ramasser_internal(_,C,L,L,0) :- nbGraines(C,L,G1), G1>3, !.
ramasser_internal(_,C,L,L,0) :- nbGraines(C,L,G1), G1<2, !.
ramasser_internal(J,0,L,LA,G) :- ramasser_internal(J,12,L,LA,G).
ramasser_internal(J,C,L,LA,G) :- nbGraines(C,L,G1), setNbGraines(C,L,0,L1), C1 is C-1, ramasser_internal(J,C1,L1,LA,G2), G is G1+G2.

/** Fin prédicats de manipulation **/