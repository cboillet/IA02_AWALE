/** Base de données **/
etat_initial([4,4,4,4,4,4,21,4,4,4,4,4]).

joueur_adverse(joueur1,JA) :- JA = joueur2.
joueur_adverse(joueur2,JA) :- JA = joueur1.

tour(joueur1).

/** Fin base de d **/


/** Jeu **/
% Predicat main(_) : lance le jeu.
lancer_jeu(_) :- tour(J), etat_initial(L), jeu(J,L,0,0).

% Predicat jeu(J,L,NGJ1,NGJ2) : le jeu.
% J = joueur en cours, L = etat du jeu, NGJ1 = graines de J1, NGJ2 = graines de J2
jeu(joueur1,L,NGJ1,NGJ2) :- afficherTour(joueur1), afficherNbGraines(NGJ1,NGJ2), afficher(L), tourDeJeu(joueur1,L,LA,NGJ1,NGJ1A), jeu(joueur2,LA,NGJ1A,NGJ2).
jeu(joueur2,L,NGJ1,NGJ2) :- afficherTour(joueur2), afficherNbGraines(NGJ1,NGJ2), afficher(L), tourDeJeu(joueur2,L,LA,NGJ2,NGJ2A), jeu(joueur1,LA,NGJ1,NGJ2A).

% Predicat tourDeJeu(J,L,LA,NGJ,NGJA) : un tour de jeu du joueur J.
% L = etat de départ, LA = etat d'arrivée, NGJ = graines du joueur pour L, NGJA = graines du joueur pour LA
tourDeJeu(J,L,LA,NGJ,NGJA) :- coups_possibles(J,L,LCases), afficherIndiceCases(LCases), askValidCase(J,C,L), member(C,LCases), jouer(J,C,L,LA,NGJ,NGJA), !.
tourDeJeu(J,L,LA,NGJ,NGJA) :- write("Ce coup est impossible car il affame l'adversaire.\n"), tourDeJeu(J,L,LA,NGJ,NGJA).

% Prédicat jouer(J,C,L) : le joueur J joue la case C.
jouer(J,C,L,LA2,NGJ,NGJA) :- coups_possibles(J,C,L,LCases), member(C,LCases), nb_graines(C,L,G), C1 is C+1, set_nb_graines(C,L,0,L2), distribuer(G,C1,L2,LA,CA), ramasser(J,CA,LA,LA2,NGR), NGJA is NGJ+NGR,!.

/** Fin jeu **/


/** Choix joueur de la case à distribuer **/
% Predicat askValidCase(J,C,L) : demande quelle case distribuer, jusqu'à ce qu'elle soit valide, et la renvoie.
% J = joueur en cousr, C = case, L = etat du jeu
askValidCase(J,C,L) :- askNombre(C), case_du_camp(J,C), nb_graines(C,L,G), G > 0, !.
askValidCase(J,C,L) :- write('Cette case n''est pas valide car elle n''est pas dans votre camp ou ne contient pas de graines. Merci de fournir une case valide.\n'), askValidCase(J,C,L).

% Predicat askNombre(C) : demande d'entrer un nombre, et le renvoie.
% C = le nombre.
askNombreb(C) :- write('Vous devez entrer un nombre\n'), current_input(STDIN), flush_instream(STDIN), askNombre(C).
askNombre(C) :- catch(askCase(C), _, askNombreb(C)).

% Predicat askCase(C) : demande quelle case distribuer et la renvoie.
% C = la case.
askCase(C) :- current_input(STDIN), write('Quelle case souhaitez-vous distribuer?\n'), read_number(STDIN,C).

% Configuration
flush_instream(STREAM) :- get_char(STREAM,'\n'), !.
flush_instream(STREAM) :- get_char(STREAM,_), flush_instream(STREAM).

/** Fin choix joueur de la case à distribuer **/


/** Prédicats d'affichage **/
% Predicat afficherTour(J) : affiche "Tour de J".
% J = le joueur
afficherTour(J) :- write('Tour de '), write(J), nl.

% Predicat afficherNbGraines(NGJ1,NGJ2) : affiche "Nb graines joueur X : NGJX".
% NGJ1 = graines de J1, NGJ2 = graines de J2
afficherNbGraines(NGJ1,NGJ2) :- afficherNbGrainesJ(joueur1,NGJ1), afficherNbGrainesJ(joueur2,NGJ2).
afficherNbGrainesJ(J,NGJ) :- write(J), write(' possede '), write(NGJ), write(' graines.'), nl.

% Predicat afficherIndiceCases(LCases) : affiche un message d'indice des mouvements possibles
% LCases = les mouvements possibles
afficherIndiceCases(LCases) :- write('Indice : vous pouvez jouer les cases : '), afficherListe(LCases).
afficherListe([T]) :- write(T), nl.
afficherListe([T|Q]) :- write(T), write(','), afficherListe(Q).


% Predicat afficher(L) : affiche l'état du jeu.
afficher(L) :- diviser(L,L1,L2,1), affiche2(L2), nl, affiche1(L1), nl, nl.

% Predicat afficher(L) : affiche la liste L dans l'ordre.
affiche1([]) :- write('|').
affiche1([T|Q]) :- write('|'), affiche_espace(T), write(T), affiche1(Q).

% Predicat afficher2(L) : affiche la liste L dans l'ordre inverse.
affiche2([]) :- write('|').
affiche2([T|Q]) :- affiche2(Q), affiche_espace(T), write(T), write('|').

% Predicat affiche_espace(NB) : affiche un espace si NB<10.
affiche_espace(NB) :- NB<10, write(' '),!.
affiche_espace(_).

% Predicat diviser(L,L1,L2,C) : divise la liste L en deux sous-listes L1 et L2.
diviser([],[],[],_) :- !.
diviser([T|Q],[T|L1],L2,C) :- C<7, !, C2 is C+1, diviser(Q,L1,L2,C2).
diviser([T|Q],L1,[T|L2],C) :- C2 is C+1 ,diviser(Q,L1,L2,C2).

/** Prédicats d'affichage **/


/** Prédicats de manipulation **/
% Prédicat nb_graines(C,L,G) : donne le nombre G de graines de la case C de l'état L.
nb_graines(1,[T|_],T) :- !.
nb_graines(C,[_|Q],G) :- C1 is C-1, nb_graines(C1,Q,G).

% Prédicat set_nb_graines(C,L,G,LA) : affecte un nombre de graine et retourne le nouvel état.
% 
set_nb_graines(1,[_|Q],G,[G|Q]) :- !.
set_nb_graines(C,[T|Q],G,[T|R]) :- C1 is C-1, set_nb_graines(C1,Q,G,R).

%Prédicat case_du_camp(J,C) : teste si le joueur peut jouer la case C.
case_du_camp(joueur1,C) :- C<7, C>0.
case_du_camp(joueur2,C) :- C>6, C<13.

%Prédicat famine(J,L) : teste si le joueur J est en famine, c-à-d. s'il n'a plus de graines dans son camp.
famine(J,L) :- famine(J,1,L).
famine(_,_,[]) :- !.
famine(J,C,[T|Q]) :- case_du_camp(J,C), !, T =:= 0, C1 is C+1, famine(J,C1,Q).
famine(J,C,[_|Q]) :- C1 is C+1, famine(J,C1,Q).

%Prédicat coups_possibles(J,L,LCases) : renvoie la liste des cases possibles pour le joueur, c-à-d. celles qui appartiennent au joueur, non vides, et n'entrainant pas de famine chez l'autre joueur
coups_possibles(J,L,LCases) :- length(L,C), coups_possibles(J,C,L,LCases).
coups_possibles(_,0,_,[]) :- !.
coups_possibles(J,C,L,LCases) :- case_du_camp(J,C), nb_graines(C,L,G), G > 0, joueur_adverse(J,JA), C1 is C+1, distribuer(G,C1,L,LA,_), \+famine(JA,LA), !, C2 is C-1, coups_possibles(J,C2,L,LCases1), LCases = [C|LCases1]. 
coups_possibles(J,C,L,LCases) :- C1 is C-1, coups_possibles(J,C1,L,LCases).

%Prédicat distribuer(GD,C,L,LA,CA) : distribue le nombre G de graines de la case C à la case d'arrivée CA.
distribuer(0,C,L,L,CA) :- CA is C-1, !.
distribuer(GD,13,L,LA,CA) :- distribuer(GD,1,L,LA,CA).
distribuer(GD,C,L,LA,CA) :- C1 is C+1, GD1 is GD-1, distribuer(GD1,C1,L,L1,CA), nb_graines(C,L,G), G1 is G+1, set_nb_graines(C,L1,G1,LA).

%Predicat ramasser_internal(L,C,J,LA,G) : ramasse les graines L liste de graines, C case où l'on arrive, LA, liste retournée une fois ramassée, NG nb de graines ramassée
ramasser_internal(J,C,L,L,0) :- case_du_camp(J,C), !. 
ramasser_internal(_,C,L,L,0) :- nb_graines(C,L,G1), G1>3, !.
ramasser_internal(_,C,L,L,0) :- nb_graines(C,L,G1), G1<2, !.
ramasser_internal(J,0,L,LA,G) :- ramasser_internal(J,12,L,LA,G).
ramasser_internal(J,C,L,LA,G) :- nb_graines(C,L,G1), set_nb_graines(C,L,0,L1), C1 is C-1, ramasser_internal(J,C1,L1,LA,G2), G is G1+G2.

% Predicat ramasser(J,C,L,LA,G): ramasse les graines. 
% L = liste de graines, C = case où l'on arrive, LA, liste retournée une fois ramassée, NG nb de graines ramassée en s'assurant qu'il n'y a pas famine.
ramasser(J,C,L,LA,G):-ramasser_internal(J,C,L,LA,G), joueur_adverse(J,JA),\+famine(JA,LA),!.
ramasser(J,C,L,L,0):-ramasser_internal(J,C,L,_,_).

/** Fin prédicats de manipulation **/
