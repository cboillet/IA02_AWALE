/* Base de Données */

%include('Donnees.pl').
etat_initial([4,4,4,4,4,4,4,4,4,4,4,4]).
liste_test([1,2,3,4,5,6,7,8,9,10,11,12]).
liste_test2([1,0,2,3,0,1,0,0,0,0,0,0]).
liste_test3([1,0,2,3,0,1,1,0,0,0,0,0]).

nb_jetons(joueur1,0).
nb_jetons(joueur2,0).

joueur_adverse(joueur1,JA) :- JA = joueur2.
joueur_adverse(joueur2,JA) :- JA = joueur1.

tour(joueur1).

/* Jeux d'essais */
%liste_test2(L), afficher(L), jouer(joueur1,4,L,LA), afficher(LA), jouer(joueur2,7,LA,LA1), afficher(LA1).
%liste_test2(L), afficher(L), jouer(joueur1,4,L,LA), afficher(LA), jouer(joueur2,12,LA,LA1), afficher(LA1). %La case 12 est impossible à jouer


/* Predicat de manipulation */

%Affichage de la liste du jeu
	%Predicat diviser(L,L1,L2,C) : divise la liste L en deux sous-listes L1 et L2
	diviser([],[],[],_) :- !.
	diviser([T|Q],[T|L1],L2,C) :- C<7, !, C2 is C+1, diviser(Q,L1,L2,C2).
	diviser([T|Q],L1,[T|L2],C) :- C2 is C+1 ,diviser(Q,L1,L2,C2).

	%Predicat afficher(L) : affiche une liste L dans l'ordre
	affiche1([]) :- write('|').
	affiche1([T|Q]) :- write('|'), affiche_espace(T), write(T), affiche1(Q).

	%Predicat afficher2(L) : affiche une liste L dans l'ordre inverse
	affiche2([]) :- write('|').
	affiche2([T|Q]) :- affiche2(Q), affiche_espace(T), write(T), write('|').
	
	%Predicat affiche_espace(NB) affiche un espace si NB<10
	affiche_espace(NB) :- NB<10, write(' '),!.
	affiche_espace(_).

	%Predicat afficher(L) : affiche la liste L du jeu
	afficher(L) :- diviser(L,L1,L2,1), affiche2(L2), nl, affiche1(L1), nl, nl.
	

%Prédicat nb_graines(C,L,G) : donne le nombre G de graines de la case C de la liste L
nb_graines(1,[T|_],T) :- !.
nb_graines(C,[_|Q],G) :- C1 is C-1, nb_graines(C1,Q,G).

%Prédicat set_nb_graines(C,L,G,LA) : affecte le nombre G de graines dans la case C de la liste LA
set_nb_graines(1,[_|Q],G,[G|Q]) :- !.
set_nb_graines(C,[T|Q],G,[T|R]) :- C1 is C-1, set_nb_graines(C1,Q,G,R).


%Prédicat jouer(J,C,L) : le joueur J joue la case C
jouer(J,C,L,LA) :- coups_possibles(J,C,L,LCases), member(C,LCases), nb_graines(C,L,G), C1 is C+1, set_nb_graines(C,L,0,L2), distribuer(G,C1,L2,LA,_), !.

%Prédicat case_du_camp(J,C) : teste si le joueur peut jouer la case C
case_du_camp(joueur1,C) :- C<7, C>0.
case_du_camp(joueur2,C) :- C>6, C<13.

%Prédicat famine(J,L) : teste si le joueur J est en famine, c-à-d. s'il n'a plus de graines dans son camp
famine(J,L) :- famine(J,1,L).
famine(_,_,[]) :- !.
famine(J,C,[T|Q]) :- case_du_camp(J,C), !, T =:= 0, C1 is C+1, famine(J,C1,Q).
famine(J,C,[_|Q]) :- C1 is C+1, famine(J,C1,Q).
%famine(J,L) :- length(L,C), famine(J,C,L). % Autre version, peut-être plus claire, mais moins performante selon moi
%famine(_,0,_) :- !.
%famine(J,C,L) :- case_du_camp(J,C), !, nb_graines(C,L,G), G =:= 0, C1 is C-1, famine(J,C1,L).
%famine(J,C,L) :- C1 is C-1, famine(J,C1,L).

%Prédicat coups_possibles(J,L,LCases) : renvoie la liste des cases possibles pour le joueur, c-à-d. celles qui appartiennent au joueur, non vides, et n'entrainant pas de famine chez l'autre joueur
coups_possibles(J,L,LCases) :- length(L,C), coups_possibles(J,C,L,LCases).
coups_possibles(_,0,_,[]) :- !.
coups_possibles(J,C,L,LCases) :- case_du_camp(J,C), nb_graines(C,L,G), G > 0, joueur_adverse(J,JA), C1 is C+1, distribuer(G,C1,L,LA,_), \+famine(JA,LA), !, C2 is C-1, coups_possibles(J,C2,L,LCases1), LCases = [C|LCases1]. 
coups_possibles(J,C,L,LCases) :- C1 is C-1, coups_possibles(J,C1,L,LCases).

%Prédicat distribuer(GD,C,L,LA,CA) : distribue le nombre G de graines de la case C à la case d'arrivée CA
distribuer(0,C,L,L,CA) :- CA is C-1, !.
distribuer(GD,13,L,LA,CA) :- distribuer(GD,1,L,LA,CA).
distribuer(GD,C,L,LA,CA) :- C1 is C+1, GD1 is GD-1, distribuer(GD1,C1,L,L1,CA), nb_graines(C,L,G), G1 is G+1, set_nb_graines(C,L1,G1,LA).

%Predicat ramasser_internal(L,C,J,LA,G) : ramasse les graines L liste de graines, C case où l'on arrive, LA, liste retournée une fois ramassée, NG nb de graines ramassée
ramasser_internal(J,C,L,L,0) :- case_du_camp(J,C), !. 
ramasser_internal(_,C,L,L,0) :- nb_graines(C,L,G1), G1>3, !.
ramasser_internal(_,C,L,L,0) :- nb_graines(C,L,G1), G1<2, !.
ramasser_internal(J,0,L,LA,G) :- ramasser_internal(J,12,L,LA,G).
ramasser_internal(J,C,L,LA,G) :- nb_graines(C,L,G1), set_nb_graines(C,L,0,L1), C1 is C-1, ramasser_internal(J,C1,L1,LA,G2), G is G1+G2.

%Predicat ramasser(J,C,L,LA,G): ramasse les graines L liste de graines, C case où l'on arrive, LA, liste retournée une fois ramassée, NG nb de graines ramassée en s'assurant qu'il n'y a pas famine
ramasser(J,C,L,LA,G):-ramasser_internal(J,C,L,LA,G),joueur_adverse(J,JA),\+famine(JA,LA),!.
ramasser(J,C,L,L,0):-ramasser_internal(J,C,L,_,_).

%Predicat askCaseFinal(C) : demande quelle case distribuée et renvoit la case, boucle tant que l'utilisateur ne rentre pas un nombre
flush_instream(STREAM) :- get_char(STREAM,'\n'), !.
flush_instream(STREAM) :- get_char(STREAM,_), flush_instream(STREAM).
reAskCase(C) :- write('Vous devez entrer un nombre\n'), current_input(STDIN), flush_instream(STDIN), askCaseFinal(C).
askCaseFinal(C) :- catch(askCase(C),_,reAskCase(C)).

%Predicat askValidCase(J,C,L) : demande quelle case distribuée, si elle n'est pas dans le camp du joueur, lui redemande jusqu'à ce que la case soit valide
askValidCase(J,C,L) :- askCaseFinal(C), case_du_camp(J,C), nb_graines(C,L,G), G > 0, !.
askValidCase(J,C,L) :- write('Cette case n''est pas valide (elle n''est pas dans votre camp ou ne contient pas de graines). Merci de fournir une case valide\n'), askValidCase(J,C,L).

%Predicat askCase(C) : demande quelle case distribuée et renvoie la case
askCase(C) :- current_input(STDIN), write('Quelle case souhaitez-vous distribuer?\n'), read_number(STDIN,C).
